/**
 * Investors relations: <span class="__cf_email__" data-cfemail="3848594a4c565d4a4b78594a5a514c4a595f51565f165b57">[email protected]</span>&#13;
**/&#13;
&#13;
pragma solidity ^0.4.18;&#13;
&#13;
/**&#13;
 * @title Crowdsale&#13;
 * @dev Crowdsale is a base contract for managing a token crowdsale.&#13;
 * Crowdsales have a start and end timestamps, where investors can make&#13;
 * token purchases and the crowdsale will assign them tokens based&#13;
 * on a token per ETH rate. Funds collected are forwarded to a wallet&#13;
 * as they arrive.&#13;
 */&#13;
 &#13;
 &#13;
library SafeMath {&#13;
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {&#13;
    uint256 c = a * b;&#13;
    assert(a == 0 || c / a == b);&#13;
    return c;&#13;
  }&#13;
&#13;
 function div(uint256 a, uint256 b) internal pure returns (uint256) {&#13;
    assert(b &gt; 0); // Solidity automatically throws when dividing by 0&#13;
    uint256 c = a / b;&#13;
    assert(a == b * c + a % b); // There is no case in which this doesn't hold&#13;
    return c;&#13;
  }&#13;
&#13;
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {&#13;
    assert(b &lt;= a);&#13;
    return a - b;&#13;
  }&#13;
&#13;
  function add(uint256 a, uint256 b) internal pure returns (uint256) {&#13;
    uint256 c = a + b;&#13;
    assert(c &gt;= a);&#13;
    return c;&#13;
  }&#13;
}&#13;
&#13;
contract Ownable {&#13;
  address public owner;&#13;
&#13;
&#13;
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);&#13;
&#13;
&#13;
  /**&#13;
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender&#13;
   * account.&#13;
   */&#13;
  function Ownable() public {&#13;
    owner = msg.sender;&#13;
  }&#13;
&#13;
&#13;
  /**&#13;
   * @dev Throws if called by any account other than the owner.&#13;
   */&#13;
  modifier onlyOwner() {&#13;
    require(msg.sender == owner);&#13;
    _;&#13;
  }&#13;
&#13;
&#13;
  /**&#13;
   * @dev Allows the current owner to transfer control of the contract to a newOwner.&#13;
   * @param newOwner The address to transfer ownership to.&#13;
   */&#13;
  function transferOwnership(address newOwner) onlyOwner public {&#13;
    require(newOwner != address(0));&#13;
    OwnershipTransferred(owner, newOwner);&#13;
    owner = newOwner;&#13;
  }&#13;
&#13;
}&#13;
&#13;
/**&#13;
 * @title ERC20Standard&#13;
 * @dev Simpler version of ERC20 interface&#13;
 * @dev see https://github.com/ethereum/EIPs/issues/179&#13;
 */&#13;
contract ERC20Interface {&#13;
     function totalSupply() public constant returns (uint);&#13;
     function balanceOf(address tokenOwner) public constant returns (uint balance);&#13;
     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);&#13;
     function transfer(address to, uint tokens) public returns (bool success);&#13;
     function approve(address spender, uint tokens) public returns (bool success);&#13;
     function transferFrom(address from, address to, uint tokens) public returns (bool success);&#13;
     event Transfer(address indexed from, address indexed to, uint tokens);&#13;
     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);&#13;
}&#13;
&#13;
interface OldXRPCToken {&#13;
    function transfer(address receiver, uint amount) external;&#13;
    function balanceOf(address _owner) external returns (uint256 balance);&#13;
    function mint(address wallet, address buyer, uint256 tokenAmount) external;&#13;
    function showMyTokenBalance(address addr) external;&#13;
}&#13;
contract ARBITRAGEToken is ERC20Interface,Ownable {&#13;
&#13;
   using SafeMath for uint256;&#13;
    uint256 public totalSupply;&#13;
    mapping(address =&gt; uint256) tokenBalances;&#13;
   &#13;
   string public constant name = "ARBITRAGE";&#13;
   string public constant symbol = "ARB";&#13;
   uint256 public constant decimals = 18;&#13;
&#13;
   uint256 public constant INITIAL_SUPPLY = 10000000;&#13;
    address ownerWallet;&#13;
   // Owner of account approves the transfer of an amount to another account&#13;
   mapping (address =&gt; mapping (address =&gt; uint256)) allowed;&#13;
   event Debug(string message, address addr, uint256 number);&#13;
&#13;
    function ARBITRAGEToken(address wallet) public {&#13;
        owner = msg.sender;&#13;
        ownerWallet=wallet;&#13;
        totalSupply = INITIAL_SUPPLY * 10 ** 18;&#13;
        tokenBalances[wallet] = INITIAL_SUPPLY * 10 ** 18;   //Since we divided the token into 10^18 parts&#13;
    }&#13;
 /**&#13;
  * @dev transfer token for a specified address&#13;
  * @param _to The address to transfer to.&#13;
  * @param _value The amount to be transferred.&#13;
  */&#13;
  function transfer(address _to, uint256 _value) public returns (bool) {&#13;
    require(tokenBalances[msg.sender]&gt;=_value);&#13;
    tokenBalances[msg.sender] = tokenBalances[msg.sender].sub(_value);&#13;
    tokenBalances[_to] = tokenBalances[_to].add(_value);&#13;
    Transfer(msg.sender, _to, _value);&#13;
    return true;&#13;
  }&#13;
  &#13;
  &#13;
     /**&#13;
   * @dev Transfer tokens from one address to another&#13;
   * @param _from address The address which you want to send tokens from&#13;
   * @param _to address The address which you want to transfer to&#13;
   * @param _value uint256 the amount of tokens to be transferred&#13;
   */&#13;
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {&#13;
    require(_to != address(0));&#13;
    require(_value &lt;= tokenBalances[_from]);&#13;
    require(_value &lt;= allowed[_from][msg.sender]);&#13;
&#13;
    tokenBalances[_from] = tokenBalances[_from].sub(_value);&#13;
    tokenBalances[_to] = tokenBalances[_to].add(_value);&#13;
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);&#13;
    Transfer(_from, _to, _value);&#13;
    return true;&#13;
  }&#13;
  &#13;
     /**&#13;
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.&#13;
   *&#13;
   * Beware that changing an allowance with this method brings the risk that someone may use both the old&#13;
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this&#13;
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:&#13;
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729&#13;
   * @param _spender The address which will spend the funds.&#13;
   * @param _value The amount of tokens to be spent.&#13;
   */&#13;
  function approve(address _spender, uint256 _value) public returns (bool) {&#13;
    allowed[msg.sender][_spender] = _value;&#13;
    Approval(msg.sender, _spender, _value);&#13;
    return true;&#13;
  }&#13;
&#13;
     // ------------------------------------------------------------------------&#13;
     // Total supply&#13;
     // ------------------------------------------------------------------------&#13;
     function totalSupply() public constant returns (uint) {&#13;
         return totalSupply  - tokenBalances[address(0)];&#13;
     }&#13;
     &#13;
    &#13;
     &#13;
     // ------------------------------------------------------------------------&#13;
     // Returns the amount of tokens approved by the owner that can be&#13;
     // transferred to the spender's account&#13;
     // ------------------------------------------------------------------------&#13;
     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {&#13;
         return allowed[tokenOwner][spender];&#13;
     }&#13;
     &#13;
     /**&#13;
   * @dev Increase the amount of tokens that an owner allowed to a spender.&#13;
   *&#13;
   * approve should be called when allowed[_spender] == 0. To increment&#13;
   * allowed value is better to use this function to avoid 2 calls (and wait until&#13;
   * the first transaction is mined)&#13;
   * From MonolithDAO Token.sol&#13;
   * @param _spender The address which will spend the funds.&#13;
   * @param _addedValue The amount of tokens to increase the allowance by.&#13;
   */&#13;
  function increaseApproval(address _spender, uint _addedValue) public returns (bool) {&#13;
    allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);&#13;
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);&#13;
    return true;&#13;
  }&#13;
&#13;
  /**&#13;
   * @dev Decrease the amount of tokens that an owner allowed to a spender.&#13;
   *&#13;
   * approve should be called when allowed[_spender] == 0. To decrement&#13;
   * allowed value is better to use this function to avoid 2 calls (and wait until&#13;
   * the first transaction is mined)&#13;
   * From MonolithDAO Token.sol&#13;
   * @param _spender The address which will spend the funds.&#13;
   * @param _subtractedValue The amount of tokens to decrease the allowance by.&#13;
   */&#13;
  function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {&#13;
    uint oldValue = allowed[msg.sender][_spender];&#13;
    if (_subtractedValue &gt; oldValue) {&#13;
      allowed[msg.sender][_spender] = 0;&#13;
    } else {&#13;
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);&#13;
    }&#13;
    Approval(msg.sender, _spender, allowed[msg.sender][_spender]);&#13;
    return true;&#13;
  }&#13;
&#13;
     &#13;
     // ------------------------------------------------------------------------&#13;
     // Don't accept ETH&#13;
     // ------------------------------------------------------------------------&#13;
     function () public payable {&#13;
         revert();&#13;
     }&#13;
 &#13;
&#13;
  /**&#13;
  * @dev Gets the balance of the specified address.&#13;
  * @param _owner The address to query the the balance of.&#13;
  * @return An uint256 representing the amount owned by the passed address.&#13;
  */&#13;
  function balanceOf(address _owner) constant public returns (uint256 balance) {&#13;
    return tokenBalances[_owner];&#13;
  }&#13;
&#13;
    function mint(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {&#13;
      require(tokenBalances[wallet] &gt;= tokenAmount);               // checks if it has enough to sell&#13;
      tokenBalances[buyer] = tokenBalances[buyer].add(tokenAmount);                  // adds the amount to buyer's balance&#13;
      tokenBalances[wallet] = tokenBalances[wallet].sub(tokenAmount);                        // subtracts amount from seller's balance&#13;
      Transfer(wallet, buyer, tokenAmount); &#13;
      totalSupply=totalSupply.sub(tokenAmount);&#13;
    }&#13;
    function pullBack(address wallet, address buyer, uint256 tokenAmount) public onlyOwner {&#13;
        require(tokenBalances[buyer]&gt;=tokenAmount);&#13;
        tokenBalances[buyer] = tokenBalances[buyer].sub(tokenAmount);&#13;
        tokenBalances[wallet] = tokenBalances[wallet].add(tokenAmount);&#13;
        Transfer(buyer, wallet, tokenAmount);&#13;
        totalSupply=totalSupply.add(tokenAmount);&#13;
     }&#13;
    function showMyTokenBalance(address addr) public view returns (uint tokenBalance) {&#13;
        tokenBalance = tokenBalances[addr];&#13;
    }&#13;
}&#13;
contract ARBITRAGECrowdsale {&#13;
    &#13;
    struct Stakeholder&#13;
    {&#13;
        address stakeholderAddress;&#13;
        uint stakeholderPerc;&#13;
    }&#13;
  using SafeMath for uint256;&#13;
 &#13;
  // The token being sold&#13;
  ARBITRAGEToken public token;&#13;
  OldXRPCToken public prevXRPCToken;&#13;
  &#13;
  // start and end timestamps where investments are allowed (both inclusive)&#13;
  uint256 public startTime;&#13;
  Stakeholder[] ownersList;&#13;
  &#13;
  // address where funds are collected&#13;
  // address where tokens are deposited and from where we send tokens to buyers&#13;
  address public walletOwner;&#13;
  Stakeholder stakeholderObj;&#13;
  &#13;
&#13;
  uint256 public coinPercentage = 5;&#13;
&#13;
    // how many token units a buyer gets per wei&#13;
    uint256 public ratePerWei = 1657;&#13;
    uint256 public maxBuyLimit=2000;&#13;
    uint256 public tokensSoldInThisRound=0;&#13;
    uint256 public totalTokensSold = 0;&#13;
&#13;
    // amount of raised money in wei&#13;
    uint256 public weiRaised;&#13;
&#13;
&#13;
    bool public isCrowdsalePaused = false;&#13;
    address partnerHandler;&#13;
  &#13;
  /**&#13;
   * event for token purchase logging&#13;
   * @param purchaser who paid for the tokens&#13;
   * @param beneficiary who got the tokens&#13;
   * @param value weis paid for purchase&#13;
   * @param amount amount of tokens purchased&#13;
   */&#13;
  event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);&#13;
&#13;
&#13;
  function ARBITRAGECrowdsale(address _walletOwner, address _partnerHandler) public {&#13;
      &#13;
        prevXRPCToken = OldXRPCToken(0xAdb41FCD3DF9FF681680203A074271D3b3Dae526); &#13;
        &#13;
        startTime = now;&#13;
        &#13;
        require(_walletOwner != 0x0);&#13;
        walletOwner=_walletOwner;&#13;
&#13;
         stakeholderObj = Stakeholder({&#13;
         stakeholderAddress: walletOwner,&#13;
         stakeholderPerc : 100});&#13;
         &#13;
         ownersList.push(stakeholderObj);&#13;
        partnerHandler = _partnerHandler;&#13;
        token = createTokenContract(_walletOwner);&#13;
  }&#13;
&#13;
  // creates the token to be sold.&#13;
  function createTokenContract(address wall) internal returns (ARBITRAGEToken) {&#13;
    return new ARBITRAGEToken(wall);&#13;
  }&#13;
&#13;
&#13;
  // fallback function can be used to buy tokens&#13;
  function () public payable {&#13;
    buyTokens(msg.sender);&#13;
  }&#13;
&#13;
  &#13;
  // low level token purchase function&#13;
&#13;
  function buyTokens(address beneficiary) public payable {&#13;
    require (isCrowdsalePaused != true);&#13;
        &#13;
    require(beneficiary != 0x0);&#13;
    require(validPurchase());&#13;
    uint256 weiAmount = msg.value;&#13;
    // calculate token amount to be created&#13;
&#13;
    uint256 tokens = weiAmount.mul(ratePerWei);&#13;
    require(tokensSoldInThisRound.add(tokens)&lt;=maxBuyLimit);&#13;
    // update state&#13;
    weiRaised = weiRaised.add(weiAmount);&#13;
&#13;
    token.mint(walletOwner, beneficiary, tokens); &#13;
    tokensSoldInThisRound=tokensSoldInThisRound+tokens;&#13;
    TokenPurchase(walletOwner, beneficiary, weiAmount, tokens);&#13;
    totalTokensSold = totalTokensSold.add(tokens);&#13;
    uint partnerCoins = tokens.mul(coinPercentage);&#13;
    partnerCoins = partnerCoins.div(100);&#13;
    forwardFunds(partnerCoins);&#13;
  }&#13;
&#13;
   // send ether to the fund collection wallet(s)&#13;
    function forwardFunds(uint256 partnerTokenAmount) internal {&#13;
      for (uint i=0;i&lt;ownersList.length;i++)&#13;
      {&#13;
         uint percent = ownersList[i].stakeholderPerc;&#13;
         uint amountToBeSent = msg.value.mul(percent);&#13;
         amountToBeSent = amountToBeSent.div(100);&#13;
         ownersList[i].stakeholderAddress.transfer(amountToBeSent);&#13;
         &#13;
         if (ownersList[i].stakeholderAddress!=walletOwner &amp;&amp;  ownersList[i].stakeholderPerc&gt;0)&#13;
         {&#13;
             token.mint(walletOwner,ownersList[i].stakeholderAddress,partnerTokenAmount);&#13;
         }&#13;
      }&#13;
    }&#13;
    &#13;
    function updateOwnerShares(address[] partnersAddresses, uint[] partnersPercentages) public{&#13;
        require(msg.sender==partnerHandler);&#13;
        require(partnersAddresses.length==partnersPercentages.length);&#13;
        &#13;
        uint sumPerc=0;&#13;
        for(uint i=0; i&lt;partnersPercentages.length;i++)&#13;
        {&#13;
            sumPerc+=partnersPercentages[i];&#13;
        }&#13;
        require(sumPerc==100);&#13;
        &#13;
        delete ownersList;&#13;
        &#13;
        for(uint j=0; j&lt;partnersAddresses.length;j++)&#13;
        {&#13;
            delete stakeholderObj;&#13;
             stakeholderObj = Stakeholder({&#13;
             stakeholderAddress: partnersAddresses[j],&#13;
             stakeholderPerc : partnersPercentages[j]});&#13;
             ownersList.push(stakeholderObj);&#13;
        }&#13;
    }&#13;
&#13;
&#13;
  // @return true if the transaction can buy tokens&#13;
  function validPurchase() internal constant returns (bool) {&#13;
    bool nonZeroPurchase = msg.value != 0;&#13;
    return nonZeroPurchase;&#13;
  }&#13;
&#13;
  &#13;
   function showMyTokenBalance() public view returns (uint256 tokenBalance) {&#13;
        tokenBalance = token.showMyTokenBalance(msg.sender);&#13;
    }&#13;
    &#13;
    /**&#13;
     * The function to pull back tokens from a  notorious user&#13;
     * Can only be called from owner wallet&#13;
     **/&#13;
    function pullBack(address buyer) public {&#13;
        require(msg.sender==walletOwner);&#13;
        uint bal = token.balanceOf(buyer);&#13;
        token.pullBack(walletOwner,buyer,bal);&#13;
    }&#13;
    &#13;
&#13;
    /**&#13;
     * function to set the new price &#13;
     * can only be called from owner wallet&#13;
     **/ &#13;
    function setPriceRate(uint256 newPrice) public returns (bool) {&#13;
        require(msg.sender==walletOwner);&#13;
        ratePerWei = newPrice;&#13;
    }&#13;
    &#13;
    /**&#13;
     * function to set the max buy limit in 1 transaction &#13;
     * can only be called from owner wallet&#13;
     **/ &#13;
    &#13;
      function setMaxBuyLimit(uint256 maxlimit) public returns (bool) {&#13;
        require(msg.sender==walletOwner);&#13;
        maxBuyLimit = maxlimit *10 ** 18;&#13;
    }&#13;
    &#13;
      /**&#13;
     * function to start new ICO round &#13;
     * can only be called from owner wallet&#13;
     **/ &#13;
    &#13;
      function startNewICORound(uint256 maxlimit, uint256 newPrice) public returns (bool) {&#13;
        require(msg.sender==walletOwner);&#13;
        setMaxBuyLimit(maxlimit);&#13;
        setPriceRate(newPrice);&#13;
        tokensSoldInThisRound=0;&#13;
    }&#13;
    &#13;
      /**&#13;
     * function to get this round information &#13;
     * can only be called from owner wallet&#13;
     **/ &#13;
    &#13;
      function getCurrentICORoundInfo() public view returns &#13;
      (uint256 maxlimit, uint256 newPrice, uint tokensSold) {&#13;
       return(maxBuyLimit,ratePerWei,tokensSoldInThisRound);&#13;
    }&#13;
    &#13;
    /**&#13;
     * function to pause the crowdsale &#13;
     * can only be called from owner wallet&#13;
     **/&#13;
     &#13;
    function pauseCrowdsale() public returns(bool) {&#13;
        require(msg.sender==walletOwner);&#13;
        isCrowdsalePaused = true;&#13;
    }&#13;
&#13;
    /**&#13;
     * function to resume the crowdsale if it is paused&#13;
     * can only be called from owner wallet&#13;
     * if the crowdsale has been stopped, this function would not resume it&#13;
     **/ &#13;
    function resumeCrowdsale() public returns (bool) {&#13;
        require(msg.sender==walletOwner);&#13;
        isCrowdsalePaused = false;&#13;
    }&#13;
    &#13;
    /**&#13;
     * Shows the remaining tokens in the contract i.e. tokens remaining for sale&#13;
     **/ &#13;
    function tokensRemainingForSale() public view returns (uint256 balance) {&#13;
        balance = token.balanceOf(walletOwner);&#13;
    }&#13;
    &#13;
    /**&#13;
     * function to show the equity percentage of an owner - major or minor&#13;
     * can only be called from the owner wallet&#13;
     **/&#13;
    function checkOwnerShare (address owner) public constant returns (uint share) {&#13;
        require(msg.sender==walletOwner);&#13;
        &#13;
        for(uint i=0;i&lt;ownersList.length;i++)&#13;
        {&#13;
            if(ownersList[i].stakeholderAddress==owner)&#13;
            {&#13;
                return ownersList[i].stakeholderPerc;&#13;
            }&#13;
        }&#13;
        return 0;&#13;
    }&#13;
&#13;
    /**&#13;
     * function to change the coin percentage awarded to the partners&#13;
     * can only be called from the owner wallet&#13;
     **/&#13;
    function changePartnerCoinPercentage(uint percentage) public {&#13;
        require(msg.sender==walletOwner);&#13;
        coinPercentage = percentage;&#13;
    }&#13;
    &#13;
    /**&#13;
     * airdrop to old token holders&#13;
     **/ &#13;
    function airDropToOldTokenHolders(address[] oldTokenHolders) public {&#13;
        require(msg.sender==walletOwner);&#13;
        for(uint i = 0; i&lt;oldTokenHolders.length; i++){&#13;
            if(prevXRPCToken.balanceOf(oldTokenHolders[i])&gt;0)&#13;
            {&#13;
                token.mint(walletOwner,oldTokenHolders[i],prevXRPCToken.balanceOf(oldTokenHolders[i]));&#13;
            }&#13;
        }&#13;
    }&#13;
    &#13;
    function changeWalletOwner(address newWallet) public {&#13;
        require(msg.sender==walletOwner);&#13;
        walletOwner = newWallet;&#13;
    }&#13;
}