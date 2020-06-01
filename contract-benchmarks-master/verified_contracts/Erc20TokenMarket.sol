// This is ERC 2.0 Token's Trading Market, Decentralized Exchange. 
// by he.guanjun, email: <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="137b763d773d773d607b727d537b7c677e727a7f3d707c7e">[email protected]</a>&#13;
// 2017-09-03&#13;
&#13;
pragma solidity ^0.4.11; &#13;
&#13;
// ERC Token Standard #20 Interface&#13;
// https://github.com/ethereum/EIPs/issues/20&#13;
interface ERC20Token {&#13;
      function totalSupply() constant returns (uint256 totalSupply);&#13;
      function balanceOf(address _owner) constant returns (uint256 balance);&#13;
&#13;
      function transfer(address _to, uint256 _value) returns (bool success);&#13;
&#13;
      function allowance(address _owner, address _spender) constant returns (uint256 remaining);&#13;
      function approve(address _spender, uint256 _value) returns (bool success);&#13;
      function transferFrom(address _from, address _to, uint256 _value) returns (bool success);&#13;
&#13;
      event Transfer(address indexed _from, address indexed _to, uint256 _value);&#13;
      event Approval(address indexed _owner, address indexed _spender, uint256 _value);&#13;
&#13;
      function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success);&#13;
}&#13;
&#13;
contract Base { &#13;
    uint createTime = now;&#13;
&#13;
    address public owner;&#13;
    &#13;
    function Base() {&#13;
        owner = msg.sender;&#13;
    }&#13;
    &#13;
    modifier onlyOwner {&#13;
        require(msg.sender == owner);&#13;
        _;&#13;
    }&#13;
    &#13;
    function transferOwnership(address _newOwner)  public  onlyOwner {&#13;
        owner = _newOwner;&#13;
    }&#13;
&#13;
    mapping (address =&gt; uint256) public userEtherOf;   &#13;
&#13;
    function userRefund() public   {&#13;
         _userRefund(msg.sender, msg.sender);&#13;
    }&#13;
&#13;
    function userRefundTo(address _to) public   {&#13;
        _userRefund(msg.sender, _to);&#13;
    }&#13;
&#13;
    function _userRefund(address _from,  address _to) private {&#13;
        require (_to != 0x0);  &#13;
        uint256 amount = userEtherOf[_from];&#13;
        if(amount &gt; 0){&#13;
            userEtherOf[_from] -= amount;&#13;
            _to.transfer(amount); &#13;
        }&#13;
    }&#13;
&#13;
}&#13;
&#13;
//执行 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }&#13;
contract  Erc20TokenMarket is Base         //for exchange token&#13;
{&#13;
    function Erc20TokenMarket()  Base ()  {&#13;
    }&#13;
&#13;
    mapping (address =&gt; uint) public BadTokenOf;      //Token 黑名单！&#13;
&#13;
    function addBadToken(address _tokenAddress) public onlyOwner{&#13;
        BadTokenOf[_tokenAddress] += 1;&#13;
    }&#13;
&#13;
    function removeBadToken(address _tokenAddress) public onlyOwner{&#13;
        BadTokenOf[_tokenAddress] = 0;&#13;
    }&#13;
&#13;
    function isBadToken(address _tokenAddress) private returns(bool _result) {&#13;
        return BadTokenOf[_tokenAddress] &gt; 0;        &#13;
    }&#13;
&#13;
    bool public hasSellerGuarantee = false;&#13;
    &#13;
    uint256 public sellerGuaranteeEther = 0 ether;      //保证金，最大惩罚金额。&#13;
&#13;
    function setSellerGuarantee(bool _has, uint256 _gurateeEther) public onlyOwner {&#13;
        require(now - createTime &gt; 1 years);    //至少一年后才启用保证金&#13;
        require(_gurateeEther &lt; 0.1 ether);     //不能太高，表示一下，能够拒绝恶意者就好。&#13;
        hasSellerGuarantee = _has;&#13;
        sellerGuaranteeEther = _gurateeEther;        &#13;
    }    &#13;
&#13;
    function checkSellerGuarantee(address _seller) private returns (bool _result){&#13;
        if (hasSellerGuarantee){&#13;
            return userEtherOf[_seller] &gt;= sellerGuaranteeEther;            //保证金不强制冻结，如果保证金不足，将无法完成交易（买和卖）。&#13;
        }&#13;
        return true;&#13;
    }&#13;
&#13;
    function userRefundWithoutGuaranteeEther() public   {       //退款，但是保留保证金&#13;
        if (userEtherOf[msg.sender] &gt;= sellerGuaranteeEther){&#13;
            uint256 amount = userEtherOf[msg.sender] - sellerGuaranteeEther;&#13;
            userEtherOf[msg.sender] -= amount;&#13;
            msg.sender.transfer(amount); &#13;
        }&#13;
    }&#13;
&#13;
    struct SellingToken{                //TokenInfo，包括：当前金额，已卖总金额，出售价格，是否出售，出售时间限制，转入总金额，转入总金额， TODO：&#13;
        uint256    thisAmount;          //currentAmount，当前金额，可以出售的金额,转入到 this 地址的金额。&#13;
        uint256    soldoutAmount;       //&#13;
        uint256    price;      &#13;
        bool       cancel;              //正在出售，是否出售&#13;
        uint       lineTime;            //出售时间限制&#13;
    }    &#13;
&#13;
    mapping (address =&gt; mapping(address =&gt; SellingToken)) public userSellingTokenOf;    //销售者，代币地址，销售信息&#13;
&#13;
    event OnSetSellingToken(address indexed _tokenAddress, address _seller, uint indexed _sellingAmount, uint256 indexed _price, uint _lineTime, bool _cancel);&#13;
&#13;
    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public {&#13;
        _extraData;&#13;
        _value;&#13;
        require(_from != 0x0);&#13;
        require(_token != 0x0);&#13;
        //require(_value &gt; 0);              //no&#13;
        require(_token == msg.sender &amp;&amp; msg.sender != tx.origin);   //防范攻击，防止被发送大量的垃圾信息！就算攻击，也要写一个智能合约来攻击！&#13;
        require(!isBadToken(msg.sender));                           //黑名单判断，主要防范垃圾信息，&#13;
&#13;
        ERC20Token token = ERC20Token(msg.sender);&#13;
        var sellingAmount = token.allowance(_from, this);   //_from == tx.origin != msg.sender = _token , _from == tx.origin 不一定，但一般如此，多重签名钱包就不是。&#13;
&#13;
        //var sa = token.balanceOf(_from);        //检查用户实际拥有的Token，但用户拥有的Token随时可能变化，所以还是无法检查，只能在购买的时候检查。&#13;
        //if (sa &lt; sellingAmount){&#13;
        //    sellingAmount = sa;&#13;
        //}&#13;
&#13;
        //require(sellingAmount &gt; 0);       //no &#13;
&#13;
        var st = userSellingTokenOf[_from][_token];                 //用户(卖家)地址， Token地址，&#13;
        st.thisAmount = sellingAmount;&#13;
        //st.price = 0;&#13;
        //st.lineTime = 0;&#13;
        //st.cancel = true;      &#13;
        OnSetSellingToken(_token, _from, sellingAmount, st.price, st.lineTime, st.cancel);&#13;
    }&#13;
      &#13;
    function setSellingToken(address _tokenAddress,  uint256 _price, uint _lineTime) public returns(uint256  _sellingAmount) {&#13;
        require(_tokenAddress != 0x0);&#13;
        require(_price &gt; 0);&#13;
        require(_lineTime &gt; now);&#13;
        require(!isBadToken(msg.sender));              //黑名单&#13;
        require(checkSellerGuarantee(msg.sender));     //保证金，&#13;
&#13;
        ERC20Token token = ERC20Token(_tokenAddress);&#13;
        _sellingAmount = token.allowance(msg.sender,this);&#13;
&#13;
        //var sa = token.balanceOf(_from);        //检查用户实际拥有的Token&#13;
        //if (sa &lt; _sellingAmount){&#13;
        //    _sellingAmount = sa;&#13;
        //}&#13;
&#13;
        var st = userSellingTokenOf[msg.sender][_tokenAddress];&#13;
        st.thisAmount = _sellingAmount;&#13;
        st.price = _price;&#13;
        st.lineTime = _lineTime;&#13;
        st.cancel = false;&#13;
&#13;
        OnSetSellingToken(_tokenAddress, msg.sender, _sellingAmount, _price, _lineTime, st.cancel);&#13;
    }   &#13;
&#13;
    function cancelSellingToken(address _tokenAddress)  public returns(bool _result){&#13;
        require(_tokenAddress != 0x0);    &#13;
        _result = false;       &#13;
&#13;
        var st = userSellingTokenOf[msg.sender][_tokenAddress];&#13;
        st.cancel = true;&#13;
        &#13;
        ERC20Token token = ERC20Token(_tokenAddress);&#13;
        var sellingAmount = token.allowance(msg.sender,this);&#13;
        st.thisAmount = sellingAmount;&#13;
        &#13;
        OnSetSellingToken(_tokenAddress, msg.sender, sellingAmount, st.price, st.lineTime, st.cancel);&#13;
    }    &#13;
&#13;
    event OnBuyToken(uint __ramianBuyerEtherAmount, address _buyer, address indexed _seller, address indexed _tokenAddress, uint256  _transAmount, uint256 indexed _tokenPrice, uint256 _ramianTokenAmount);&#13;
&#13;
    bool public _isBuying = false;              //lock &#13;
&#13;
    function setIsBuying()  public onlyOwner{   //sometime, _isBuying always is true???&#13;
        _isBuying = false;        &#13;
    }&#13;
&#13;
    function buyTokenFrom(address _seller, address _tokenAddress, uint256 _buyerTokenPrice) public payable returns(bool _result) {   &#13;
        require(_seller != 0x0);&#13;
        require(_tokenAddress != 0x0);&#13;
        require(_buyerTokenPrice &gt; 0);&#13;
&#13;
        require(!_isBuying);            //拒绝二次进入！&#13;
        _isBuying = true;               //加锁&#13;
&#13;
        userEtherOf[msg.sender] += msg.value;&#13;
        if (userEtherOf[msg.sender] == 0){&#13;
            _isBuying = false;&#13;
            return; &#13;
        }&#13;
&#13;
        ERC20Token token = ERC20Token(_tokenAddress);&#13;
        var sellingAmount = token.allowance(_seller, this);     //卖家， _spender   &#13;
        var st = userSellingTokenOf[_seller][_tokenAddress];    //卖家，Token&#13;
&#13;
        var sa = token.balanceOf(_seller);        //检查用户实际拥有的Token，但用户拥有的Token随时可能变化，只能在购买的时候检查。&#13;
        bool bigger = false;&#13;
        if (sa &lt; sellingAmount){                  //一种策略，卖家交定金，如果发现出现这种情况，定金没收，owner 和 买家平分定金。&#13;
            sellingAmount = sa;&#13;
            bigger = true;&#13;
        }&#13;
&#13;
        if (st.price &gt; 0 &amp;&amp; st.lineTime &gt; now &amp;&amp; sellingAmount &gt; 0 &amp;&amp; !st.cancel){&#13;
            if(_buyerTokenPrice &lt; st.price){                                                //price maybe be changed!&#13;
                OnBuyToken(userEtherOf[msg.sender], msg.sender, _seller, _tokenAddress, 0, _buyerTokenPrice, sellingAmount);&#13;
                _result = false;&#13;
                _isBuying = false;&#13;
                return;&#13;
            }&#13;
&#13;
            uint256 canTokenAmount =  userEtherOf[msg.sender]  / st.price;      &#13;
            if(canTokenAmount &gt; 0 &amp;&amp; canTokenAmount *  st.price &gt;  userEtherOf[msg.sender]){&#13;
                 canTokenAmount -= 1;&#13;
            }&#13;
            if(canTokenAmount == 0){&#13;
                OnBuyToken(userEtherOf[msg.sender], msg.sender, _seller, _tokenAddress, 0, st.price, sellingAmount);&#13;
                _result = false;&#13;
                _isBuying = false;&#13;
                return;&#13;
            }&#13;
            if (canTokenAmount &gt; sellingAmount){&#13;
                canTokenAmount = sellingAmount; &#13;
            }&#13;
            &#13;
            var etherAmount =  canTokenAmount *  st.price;&#13;
            userEtherOf[msg.sender] -= etherAmount;                     //减少记账金额&#13;
            require(userEtherOf[msg.sender] &gt;= 0);                      //冗余判断:&#13;
&#13;
            token.transferFrom(_seller, msg.sender, canTokenAmount);    //转代币, ，预防类似 the dao 潜在的风险       &#13;
            if(userEtherOf[_seller]  &gt;= sellerGuaranteeEther){          //大于等于最低保证金，这样鼓励卖家存留一点保证金。&#13;
                _seller.transfer(etherAmount);                          //转以太币，预防类似 the dao 潜在的风险      &#13;
            }   &#13;
            else{                                                       //小于最低保证金&#13;
                userEtherOf[_seller] +=  etherAmount;                   //由推改为拖，更安全！&#13;
            }      &#13;
            st.soldoutAmount += canTokenAmount;                         //更新销售额&#13;
            st.thisAmount = token.allowance(_seller, this);             //更新可销售代币数量&#13;
&#13;
            OnBuyToken(userEtherOf[msg.sender], msg.sender, _seller, _tokenAddress, canTokenAmount, st.price, st.thisAmount);     &#13;
            _result = true;&#13;
        }&#13;
        else{&#13;
            _result = false;&#13;
            OnBuyToken(userEtherOf[msg.sender], msg.sender, _seller, _tokenAddress, 0, _buyerTokenPrice, sellingAmount);&#13;
        }&#13;
&#13;
        if (bigger &amp;&amp; sellerGuaranteeEther &gt; 0){                                  //虚报可出售Token，要惩罚卖家&#13;
            if(checkSellerGuarantee(_seller)) {          //虚报可出售Token，把此用户的保证金分了, owner 和 buyer 均分，然后继续处理；否则不能交易。&#13;
                userEtherOf[owner] +=  sellerGuaranteeEther / 2; &#13;
                userEtherOf[msg.sender] +=   sellerGuaranteeEther / 2;&#13;
                userEtherOf[_seller] -= sellerGuaranteeEther;&#13;
            }&#13;
            else if (userEtherOf[_seller] &gt; 0)     //Buyer可以恶意攻击，明知卖家保证金不足，就每次小金额的购买代币，让卖家账上始终小于保证金金额，这种情况其实买家也不划算，毕竟gas蛮贵,而保证金最高才0.1 ether，暂不处理！&#13;
            {&#13;
                userEtherOf[owner] +=  userEtherOf[_seller] / 2; &#13;
                userEtherOf[msg.sender] +=   userEtherOf[_seller] - userEtherOf[_seller] / 2;&#13;
                userEtherOf[_seller] = 0;&#13;
            }&#13;
        }&#13;
        &#13;
        _isBuying = false;          //解锁&#13;
        return;&#13;
    }&#13;
&#13;
    function () public payable {&#13;
        if(msg.value &gt; 0){          //来者不拒，比抛出异常或许更合适。&#13;
            userEtherOf[msg.sender] += msg.value;&#13;
        }&#13;
    }&#13;
&#13;
    function disToken(address _token) public {          //处理捡到的各种Token，也就是别人误操作，直接给 this 发送了 token 。由调用者和Owner平分。因为这种误操作导致的丢失过去一年的损失达到几十万美元。&#13;
        ERC20Token token = ERC20Token(_token);  //目前只处理 ERC20 Token，那些非标准Token就会永久丢失！&#13;
        var amount = token.balanceOf(this);  &#13;
        if (amount &gt; 0){&#13;
            var a1 = amount / 2;&#13;
            if (a1 &gt; 0){&#13;
                token.transfer(msg.sender, a1);&#13;
            }&#13;
            var a2 = amount - a1;&#13;
            if (a2 &gt; 0){&#13;
                token.transfer(owner, a1);&#13;
            }&#13;
        }&#13;
    }&#13;
&#13;
}