pragma solidity ^0.4.16;
/*
PAXCHANGE ICO Contract

PAXCHANGE TOKEN is an ERC-20 Token Standar Compliant

Contract developer: Fares A. Akel C.
<span class="__cf_email__" data-cfemail="ef89c18e819b80818680c18e848a83af88828e8683c18c8082">[email protected]</span>&#13;
MIT PGP KEY ID: 078E41CB&#13;
*/&#13;
&#13;
/**&#13;
 * @title SafeMath by OpenZeppelin&#13;
 * @dev Math operations with safety checks that throw on error&#13;
 */&#13;
library SafeMath {&#13;
&#13;
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {&#13;
        uint256 c = a * b;&#13;
        assert(a == 0 || c / a == b);&#13;
        return c;&#13;
    }&#13;
&#13;
    function add(uint256 a, uint256 b) internal pure returns (uint256) {&#13;
        uint256 c = a + b;&#13;
        assert(c &gt;= a);&#13;
        return c;&#13;
    }&#13;
}&#13;
&#13;
/**&#13;
* Token interface definition&#13;
*/&#13;
contract ERC20Token {&#13;
&#13;
    function transfer(address _to, uint256 _value) public returns (bool success); //transfer function to let the contract move own tokens&#13;
    function balanceOf(address _owner) public constant returns (uint256 balance); //Function to check an address balance&#13;
    &#13;
                }&#13;
&#13;
contract PAXCHANGEICO {&#13;
    using SafeMath for uint256;&#13;
    /**&#13;
    * This ICO have 3 states 0:PreSale 1:ICO 2:Successful&#13;
    */&#13;
    enum State {&#13;
        PreSale,&#13;
        ICO,&#13;
        Successful&#13;
    }&#13;
    /**&#13;
    * Variables definition - Public&#13;
    */&#13;
    State public state = State.PreSale; //Set initial stage&#13;
    uint256 public startTime = now; //block-time when it was deployed&#13;
    uint256 public totalRaised;&#13;
    uint256 public currentBalance;&#13;
    uint256 public preSaledeadline;&#13;
    uint256 public ICOdeadline;&#13;
    uint256 public completedAt;&#13;
    ERC20Token public tokenReward;&#13;
    address public creator;&#13;
    string public campaignUrl;&#13;
    uint256 public constant version = 1;&#13;
    uint256[4] public prices = [&#13;
    7800, // 1 eth~=300$ 1 PAXCHANGE = 0.05$ + 30% bonus =&gt; 1eth = 7800 PAXCHANGE&#13;
    7200, // 1 eth~=300$ 1 PAXCHANGE = 0.05$ + 20% bonus =&gt; 1eth = 7200 PAXCHANGE&#13;
    6600, // 1 eth~=300$ 1 PAXCHANGE = 0.05$ + 10% bonus =&gt; 1eth = 6600 PAXCHANGE&#13;
    3000  // 1 eth~=300$ 1 PAXCHANGE = 0.1$ =&gt; 1eth = 3000 PAXCHANGE&#13;
    ];&#13;
    /**&#13;
    *Log Events&#13;
    */&#13;
    event LogFundingReceived(address _addr, uint _amount, uint _currentTotal);&#13;
    event LogBeneficiaryPaid(address _beneficiaryAddress);&#13;
    event LogFundingSuccessful(uint _totalRaised);&#13;
    event LogICOInitialized(&#13;
        address _creator,&#13;
        string _url,&#13;
        uint256 _PreSaledeadline,&#13;
        uint256 _ICOdeadline);&#13;
    event LogContributorsPayout(address _addr, uint _amount);&#13;
    /**&#13;
    *Modifier to require the ICO is on going&#13;
    */&#13;
    modifier notFinished() {&#13;
        require(state != State.Successful);&#13;
        _;&#13;
    }&#13;
    /**&#13;
    *Constructor&#13;
    */&#13;
    function PAXCHANGEICO (&#13;
        string _campaignUrl,&#13;
        ERC20Token _addressOfTokenUsedAsReward)&#13;
        public&#13;
    {&#13;
        creator = msg.sender;&#13;
        campaignUrl = _campaignUrl;&#13;
        preSaledeadline = startTime.add(3 weeks);&#13;
        ICOdeadline = preSaledeadline.add(3 weeks);&#13;
        currentBalance = 0;&#13;
        tokenReward = ERC20Token(_addressOfTokenUsedAsReward);&#13;
        LogICOInitialized(&#13;
            creator,&#13;
            campaignUrl,&#13;
            preSaledeadline,&#13;
            ICOdeadline);&#13;
    }&#13;
    /**&#13;
    *@dev Function to contribute to the ICO&#13;
    *Its check first if ICO is ongoin&#13;
    *so no one can transfer to it after finished&#13;
    */&#13;
    function contribute() public notFinished payable {&#13;
&#13;
        uint256 tokenBought;&#13;
        totalRaised = totalRaised.add(msg.value);&#13;
        currentBalance = totalRaised;&#13;
&#13;
        if (state == State.PreSale &amp;&amp; now &lt; startTime + 1 weeks){ //if we are on the first week of the presale&#13;
            tokenBought = uint256(msg.value).mul(prices[0]);&#13;
            if (totalRaised.add(tokenBought) &gt; 10000000 * (10**18)){&#13;
                revert();&#13;
            }&#13;
        }&#13;
        else if (state == State.PreSale &amp;&amp; now &lt; startTime + 2 weeks){ //if we are on the second week of the presale&#13;
            tokenBought = uint256(msg.value).mul(prices[1]);&#13;
            if (totalRaised.add(tokenBought) &gt; 10000000 * (10**18)){&#13;
                revert();&#13;
            }&#13;
        }&#13;
        else if (state == State.PreSale &amp;&amp; now &lt; startTime + 3 weeks){ //if we are on the third week of the presale&#13;
            tokenBought = uint256(msg.value).mul(prices[2]);&#13;
            if (totalRaised.add(tokenBought) &gt; 10000000 * (10**18)){&#13;
                revert();&#13;
            }&#13;
        }&#13;
        else if (state == State.ICO) { //if we are on the ICO period&#13;
            tokenBought = uint256(msg.value).mul(prices[3]);&#13;
        }&#13;
        else {revert();}&#13;
&#13;
        tokenReward.transfer(msg.sender, tokenBought);&#13;
        &#13;
        LogFundingReceived(msg.sender, msg.value, totalRaised);&#13;
        LogContributorsPayout(msg.sender, tokenBought);&#13;
        &#13;
        checkIfFundingCompleteOrExpired();&#13;
    }&#13;
    /**&#13;
    *@dev Function to check if ICO if finished&#13;
    */&#13;
    function checkIfFundingCompleteOrExpired() public {&#13;
        &#13;
        if(now &gt; preSaledeadline &amp;&amp; now &lt; ICOdeadline){&#13;
            state = State.ICO;&#13;
        }&#13;
        else if(now &gt; ICOdeadline &amp;&amp; state==State.ICO){&#13;
            state = State.Successful;&#13;
            completedAt = now;&#13;
            LogFundingSuccessful(totalRaised);&#13;
            finished();  &#13;
        }&#13;
    }&#13;
    /**&#13;
    *@dev Function to do final transactions&#13;
    *When finished eth and remaining tokens are transfered to creator&#13;
    */&#13;
    function finished() public {&#13;
        require(state == State.Successful);&#13;
        &#13;
        uint remanent;&#13;
        remanent =  tokenReward.balanceOf(this);&#13;
        currentBalance = 0;&#13;
        &#13;
        tokenReward.transfer(creator,remanent);&#13;
        require(creator.send(this.balance));&#13;
&#13;
        LogBeneficiaryPaid(creator);&#13;
        LogContributorsPayout(creator, remanent);&#13;
    }&#13;
    /**&#13;
    *@dev Function to handle eth transfers&#13;
    *For security it require a minimun value&#13;
    *BEWARE: if a call to this functions doesnt have&#13;
    *enought gas transaction could not be finished&#13;
    */&#13;
    function () public payable {&#13;
        require(msg.value &gt; 1 finney);&#13;
        contribute();&#13;
    }&#13;
}