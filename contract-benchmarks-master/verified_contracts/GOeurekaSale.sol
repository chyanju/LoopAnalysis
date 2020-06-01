pragma solidity ^0.4.23;
// produced by the Solididy File Flattener (c) David Appleton 2018
// contact : <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="f591948390b5949e9a989794db969a98">[email protected]</a>&#13;
// released under Apache 2.0 licence&#13;
contract GoConfig {&#13;
    string public constant NAME = "GOeureka";&#13;
    string public constant SYMBOL = "GOT";&#13;
    uint8 public constant DECIMALS = 18;&#13;
    uint public constant DECIMALSFACTOR = 10 ** uint(DECIMALS);&#13;
    uint public constant TOTALSUPPLY = 1000000000 * DECIMALSFACTOR;&#13;
}&#13;
&#13;
&#13;
contract Ownable {&#13;
  address public owner;&#13;
&#13;
&#13;
  event OwnershipRenounced(address indexed previousOwner);&#13;
  event OwnershipTransferred(&#13;
    address indexed previousOwner,&#13;
    address indexed newOwner&#13;
  );&#13;
&#13;
&#13;
  /**&#13;
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender&#13;
   * account.&#13;
   */&#13;
  constructor() public {&#13;
    owner = msg.sender;&#13;
  }&#13;
&#13;
  /**&#13;
   * @dev Throws if called by any account other than the owner.&#13;
   */&#13;
  modifier onlyOwner() {&#13;
    require(msg.sender == owner);&#13;
    _;&#13;
  }&#13;
&#13;
  /**&#13;
   * @dev Allows the current owner to transfer control of the contract to a newOwner.&#13;
   * @param newOwner The address to transfer ownership to.&#13;
   */&#13;
  function transferOwnership(address newOwner) public onlyOwner {&#13;
    require(newOwner != address(0));&#13;
    emit OwnershipTransferred(owner, newOwner);&#13;
    owner = newOwner;&#13;
  }&#13;
&#13;
  /**&#13;
   * @dev Allows the current owner to relinquish control of the contract.&#13;
   */&#13;
  function renounceOwnership() public onlyOwner {&#13;
    emit OwnershipRenounced(owner);&#13;
    owner = address(0);&#13;
  }&#13;
}&#13;
&#13;
contract WhiteListedBasic {&#13;
    function addWhiteListed(address[] addrs) external;&#13;
    function removeWhiteListed(address addr) external;&#13;
    function isWhiteListed(address addr) external view returns (bool);&#13;
}&#13;
library SafeMath {&#13;
&#13;
  /**&#13;
  * @dev Multiplies two numbers, throws on overflow.&#13;
  */&#13;
  function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {&#13;
    if (a == 0) {&#13;
      return 0;&#13;
    }&#13;
    c = a * b;&#13;
    assert(c / a == b);&#13;
    return c;&#13;
  }&#13;
&#13;
  /**&#13;
  * @dev Integer division of two numbers, truncating the quotient.&#13;
  */&#13;
  function div(uint256 a, uint256 b) internal pure returns (uint256) {&#13;
    // assert(b &gt; 0); // Solidity automatically throws when dividing by 0&#13;
    // uint256 c = a / b;&#13;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold&#13;
    return a / b;&#13;
  }&#13;
&#13;
  /**&#13;
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).&#13;
  */&#13;
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {&#13;
    assert(b &lt;= a);&#13;
    return a - b;&#13;
  }&#13;
&#13;
  /**&#13;
  * @dev Adds two numbers, throws on overflow.&#13;
  */&#13;
  function add(uint256 a, uint256 b) internal pure returns (uint256 c) {&#13;
    c = a + b;&#13;
    assert(c &gt;= a);&#13;
    return c;&#13;
  }&#13;
}&#13;
&#13;
contract ERC20Basic {&#13;
  function totalSupply() public view returns (uint256);&#13;
  function balanceOf(address who) public view returns (uint256);&#13;
  function transfer(address to, uint256 value) public returns (bool);&#13;
  event Transfer(address indexed from, address indexed to, uint256 value);&#13;
}&#13;
&#13;
contract OperatableBasic {&#13;
    function setMinter (address addr) external;&#13;
    function setWhiteLister (address addr) external;&#13;
}&#13;
contract gotTokenSaleConfig is GoConfig {&#13;
    uint public constant MIN_PRESALE = 5 ether;&#13;
    uint public constant MIN_PRESALE2 = 1 ether;&#13;
    &#13;
&#13;
    uint public constant VESTING_AMOUNT = 100000000 * DECIMALSFACTOR;&#13;
    address public constant VESTING_WALLET = 0x8B6EB396eF85D2a9ADbb79955dEB5d77Ee61Af88;&#13;
        &#13;
    uint public constant RESERVE_AMOUNT = 300000000 * DECIMALSFACTOR;&#13;
    address public constant RESERVE_WALLET = 0x8B6EB396eF85D2a9ADbb79955dEB5d77Ee61Af88;&#13;
&#13;
    uint public constant PRESALE_START = 1529035246; // Friday, June 15, 2018 12:00:46 PM GMT+08:00&#13;
    uint public constant SALE_START = PRESALE_START + 4 weeks;&#13;
        &#13;
    uint public constant SALE_CAP = 600000000 * DECIMALSFACTOR;&#13;
&#13;
    address public constant MULTISIG_ETH = RESERVE_WALLET;&#13;
&#13;
}&#13;
contract Pausable is Ownable {&#13;
  event Pause();&#13;
  event Unpause();&#13;
&#13;
  bool public paused = false;&#13;
&#13;
&#13;
  /**&#13;
   * @dev Modifier to make a function callable only when the contract is not paused.&#13;
   */&#13;
  modifier whenNotPaused() {&#13;
    require(!paused);&#13;
    _;&#13;
  }&#13;
&#13;
  /**&#13;
   * @dev Modifier to make a function callable only when the contract is paused.&#13;
   */&#13;
  modifier whenPaused() {&#13;
    require(paused);&#13;
    _;&#13;
  }&#13;
&#13;
  /**&#13;
   * @dev called by the owner to pause, triggers stopped state&#13;
   */&#13;
  function pause() onlyOwner whenNotPaused public {&#13;
    paused = true;&#13;
    emit Pause();&#13;
  }&#13;
&#13;
  /**&#13;
   * @dev called by the owner to unpause, returns to normal state&#13;
   */&#13;
  function unpause() onlyOwner whenPaused public {&#13;
    paused = false;&#13;
    emit Unpause();&#13;
  }&#13;
}&#13;
&#13;
contract BasicToken is ERC20Basic {&#13;
  using SafeMath for uint256;&#13;
&#13;
  mapping(address =&gt; uint256) balances;&#13;
&#13;
  uint256 totalSupply_;&#13;
&#13;
  /**&#13;
  * @dev total number of tokens in existence&#13;
  */&#13;
  function totalSupply() public view returns (uint256) {&#13;
    return totalSupply_;&#13;
  }&#13;
&#13;
  /**&#13;
  * @dev transfer token for a specified address&#13;
  * @param _to The address to transfer to.&#13;
  * @param _value The amount to be transferred.&#13;
  */&#13;
  function transfer(address _to, uint256 _value) public returns (bool) {&#13;
    require(_to != address(0));&#13;
    require(_value &lt;= balances[msg.sender]);&#13;
&#13;
    balances[msg.sender] = balances[msg.sender].sub(_value);&#13;
    balances[_to] = balances[_to].add(_value);&#13;
    emit Transfer(msg.sender, _to, _value);&#13;
    return true;&#13;
  }&#13;
&#13;
  /**&#13;
  * @dev Gets the balance of the specified address.&#13;
  * @param _owner The address to query the the balance of.&#13;
  * @return An uint256 representing the amount owned by the passed address.&#13;
  */&#13;
  function balanceOf(address _owner) public view returns (uint256) {&#13;
    return balances[_owner];&#13;
  }&#13;
&#13;
}&#13;
&#13;
contract Claimable is Ownable {&#13;
  address public pendingOwner;&#13;
&#13;
  /**&#13;
   * @dev Modifier throws if called by any account other than the pendingOwner.&#13;
   */&#13;
  modifier onlyPendingOwner() {&#13;
    require(msg.sender == pendingOwner);&#13;
    _;&#13;
  }&#13;
&#13;
  /**&#13;
   * @dev Allows the current owner to set the pendingOwner address.&#13;
   * @param newOwner The address to transfer ownership to.&#13;
   */&#13;
  function transferOwnership(address newOwner) onlyOwner public {&#13;
    pendingOwner = newOwner;&#13;
  }&#13;
&#13;
  /**&#13;
   * @dev Allows the pendingOwner address to finalize the transfer.&#13;
   */&#13;
  function claimOwnership() onlyPendingOwner public {&#13;
    emit OwnershipTransferred(owner, pendingOwner);&#13;
    owner = pendingOwner;&#13;
    pendingOwner = address(0);&#13;
  }&#13;
}&#13;
&#13;
contract Operatable is Claimable, OperatableBasic {&#13;
    address public minter;&#13;
    address public whiteLister;&#13;
    address public launcher;&#13;
&#13;
    event NewMinter(address newMinter);&#13;
    event NewWhiteLister(address newwhiteLister);&#13;
&#13;
    modifier canOperate() {&#13;
        require(msg.sender == minter || msg.sender == whiteLister || msg.sender == owner);&#13;
        _;&#13;
    }&#13;
&#13;
    constructor() public {&#13;
        minter = owner;&#13;
        whiteLister = owner;&#13;
        launcher = owner;&#13;
    }&#13;
&#13;
    function setMinter (address addr) external onlyOwner {&#13;
        minter = addr;&#13;
        emit NewMinter(minter);&#13;
    }&#13;
&#13;
    function setWhiteLister (address addr) external onlyOwner {&#13;
        whiteLister = addr;&#13;
        emit NewWhiteLister(whiteLister);&#13;
    }&#13;
&#13;
    modifier ownerOrMinter()  {&#13;
        require ((msg.sender == minter) || (msg.sender == owner));&#13;
        _;&#13;
    }&#13;
&#13;
    modifier onlyLauncher()  {&#13;
        require (msg.sender == launcher);&#13;
        _;&#13;
    }&#13;
&#13;
    modifier onlyWhiteLister()  {&#13;
        require (msg.sender == whiteLister);&#13;
        _;&#13;
    }&#13;
}&#13;
contract ERC20 is ERC20Basic {&#13;
  function allowance(address owner, address spender)&#13;
    public view returns (uint256);&#13;
&#13;
  function transferFrom(address from, address to, uint256 value)&#13;
    public returns (bool);&#13;
&#13;
  function approve(address spender, uint256 value) public returns (bool);&#13;
  event Approval(&#13;
    address indexed owner,&#13;
    address indexed spender,&#13;
    uint256 value&#13;
  );&#13;
}&#13;
&#13;
contract BurnableToken is BasicToken {&#13;
&#13;
  event Burn(address indexed burner, uint256 value);&#13;
&#13;
  /**&#13;
   * @dev Burns a specific amount of tokens.&#13;
   * @param _value The amount of token to be burned.&#13;
   */&#13;
  function burn(uint256 _value) public {&#13;
    _burn(msg.sender, _value);&#13;
  }&#13;
&#13;
  function _burn(address _who, uint256 _value) internal {&#13;
    require(_value &lt;= balances[_who]);&#13;
    // no need to require value &lt;= totalSupply, since that would imply the&#13;
    // sender's balance is greater than the totalSupply, which *should* be an assertion failure&#13;
&#13;
    balances[_who] = balances[_who].sub(_value);&#13;
    totalSupply_ = totalSupply_.sub(_value);&#13;
    emit Burn(_who, _value);&#13;
    emit Transfer(_who, address(0), _value);&#13;
  }&#13;
}&#13;
&#13;
contract Salvageable is Operatable {&#13;
    // Salvage other tokens that are accidentally sent into this token&#13;
    function emergencyERC20Drain(ERC20 oddToken, uint amount) public onlyLauncher {&#13;
        if (address(oddToken) == address(0)) {&#13;
            launcher.transfer(amount);&#13;
            return;&#13;
        }&#13;
        oddToken.transfer(launcher, amount);&#13;
    }&#13;
}&#13;
contract StandardToken is ERC20, BasicToken {&#13;
&#13;
  mapping (address =&gt; mapping (address =&gt; uint256)) internal allowed;&#13;
&#13;
&#13;
  /**&#13;
   * @dev Transfer tokens from one address to another&#13;
   * @param _from address The address which you want to send tokens from&#13;
   * @param _to address The address which you want to transfer to&#13;
   * @param _value uint256 the amount of tokens to be transferred&#13;
   */&#13;
  function transferFrom(&#13;
    address _from,&#13;
    address _to,&#13;
    uint256 _value&#13;
  )&#13;
    public&#13;
    returns (bool)&#13;
  {&#13;
    require(_to != address(0));&#13;
    require(_value &lt;= balances[_from]);&#13;
    require(_value &lt;= allowed[_from][msg.sender]);&#13;
&#13;
    balances[_from] = balances[_from].sub(_value);&#13;
    balances[_to] = balances[_to].add(_value);&#13;
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);&#13;
    emit Transfer(_from, _to, _value);&#13;
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
    emit Approval(msg.sender, _spender, _value);&#13;
    return true;&#13;
  }&#13;
&#13;
  /**&#13;
   * @dev Function to check the amount of tokens that an owner allowed to a spender.&#13;
   * @param _owner address The address which owns the funds.&#13;
   * @param _spender address The address which will spend the funds.&#13;
   * @return A uint256 specifying the amount of tokens still available for the spender.&#13;
   */&#13;
  function allowance(&#13;
    address _owner,&#13;
    address _spender&#13;
   )&#13;
    public&#13;
    view&#13;
    returns (uint256)&#13;
  {&#13;
    return allowed[_owner][_spender];&#13;
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
  function increaseApproval(&#13;
    address _spender,&#13;
    uint _addedValue&#13;
  )&#13;
    public&#13;
    returns (bool)&#13;
  {&#13;
    allowed[msg.sender][_spender] = (&#13;
      allowed[msg.sender][_spender].add(_addedValue));&#13;
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);&#13;
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
  function decreaseApproval(&#13;
    address _spender,&#13;
    uint _subtractedValue&#13;
  )&#13;
    public&#13;
    returns (bool)&#13;
  {&#13;
    uint oldValue = allowed[msg.sender][_spender];&#13;
    if (_subtractedValue &gt; oldValue) {&#13;
      allowed[msg.sender][_spender] = 0;&#13;
    } else {&#13;
      allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);&#13;
    }&#13;
    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);&#13;
    return true;&#13;
  }&#13;
&#13;
}&#13;
&#13;
contract PausableToken is StandardToken, Pausable {&#13;
&#13;
  function transfer(&#13;
    address _to,&#13;
    uint256 _value&#13;
  )&#13;
    public&#13;
    whenNotPaused&#13;
    returns (bool)&#13;
  {&#13;
    return super.transfer(_to, _value);&#13;
  }&#13;
&#13;
  function transferFrom(&#13;
    address _from,&#13;
    address _to,&#13;
    uint256 _value&#13;
  )&#13;
    public&#13;
    whenNotPaused&#13;
    returns (bool)&#13;
  {&#13;
    return super.transferFrom(_from, _to, _value);&#13;
  }&#13;
&#13;
  function approve(&#13;
    address _spender,&#13;
    uint256 _value&#13;
  )&#13;
    public&#13;
    whenNotPaused&#13;
    returns (bool)&#13;
  {&#13;
    return super.approve(_spender, _value);&#13;
  }&#13;
&#13;
  function increaseApproval(&#13;
    address _spender,&#13;
    uint _addedValue&#13;
  )&#13;
    public&#13;
    whenNotPaused&#13;
    returns (bool success)&#13;
  {&#13;
    return super.increaseApproval(_spender, _addedValue);&#13;
  }&#13;
&#13;
  function decreaseApproval(&#13;
    address _spender,&#13;
    uint _subtractedValue&#13;
  )&#13;
    public&#13;
    whenNotPaused&#13;
    returns (bool success)&#13;
  {&#13;
    return super.decreaseApproval(_spender, _subtractedValue);&#13;
  }&#13;
}&#13;
&#13;
contract GOeureka is  Salvageable, PausableToken, BurnableToken, GoConfig {&#13;
    using SafeMath for uint;&#13;
 &#13;
    string public name = NAME;&#13;
    string public symbol = SYMBOL;&#13;
    uint8 public decimals = DECIMALS;&#13;
    bool public mintingFinished = false;&#13;
&#13;
    event Mint(address indexed to, uint amount);&#13;
    event MintFinished();&#13;
&#13;
    modifier canMint() {&#13;
        require(!mintingFinished);&#13;
        _;&#13;
    }&#13;
&#13;
    constructor() public {&#13;
        paused = true;&#13;
    }&#13;
&#13;
    function mint(address _to, uint _amount) ownerOrMinter canMint public returns (bool) {&#13;
        require(totalSupply_.add(_amount) &lt;= TOTALSUPPLY);&#13;
        totalSupply_ = totalSupply_.add(_amount);&#13;
        balances[_to] = balances[_to].add(_amount);&#13;
        emit Mint(_to, _amount);&#13;
        emit Transfer(address(0), _to, _amount);&#13;
        return true;&#13;
    }&#13;
&#13;
    function finishMinting() ownerOrMinter canMint public returns (bool) {&#13;
        mintingFinished = true;&#13;
        emit MintFinished();&#13;
        return true;&#13;
    }&#13;
&#13;
    function sendBatchCS(address[] _recipients, uint[] _values) external ownerOrMinter returns (bool) {&#13;
        require(_recipients.length == _values.length);&#13;
        uint senderBalance = balances[msg.sender];&#13;
        for (uint i = 0; i &lt; _values.length; i++) {&#13;
            uint value = _values[i];&#13;
            address to = _recipients[i];&#13;
            require(senderBalance &gt;= value);        &#13;
            senderBalance = senderBalance - value;&#13;
            balances[to] += value;&#13;
            emit Transfer(msg.sender, to, value);&#13;
        }&#13;
        balances[msg.sender] = senderBalance;&#13;
        return true;&#13;
    }&#13;
&#13;
    // Lifted from ERC827&#13;
&#13;
      /**&#13;
   * @dev Addition to ERC20 token methods. Transfer tokens to a specified&#13;
   * @dev address and execute a call with the sent data on the same transaction&#13;
   *&#13;
   * @param _to address The address which you want to transfer to&#13;
   * @param _value uint256 the amout of tokens to be transfered&#13;
   * @param _data ABI-encoded contract call to call `_to` address.&#13;
   *&#13;
   * @return true if the call function was executed successfully&#13;
   */&#13;
    function transferAndCall(&#13;
        address _to,&#13;
        uint256 _value,&#13;
        bytes _data&#13;
    )&#13;
    public&#13;
    payable&#13;
    whenNotPaused&#13;
    returns (bool)&#13;
    {&#13;
        require(_to != address(this));&#13;
&#13;
        super.transfer(_to, _value);&#13;
&#13;
        // solium-disable-next-line security/no-call-value&#13;
        require(_to.call.value(msg.value)(_data));&#13;
        return true;&#13;
    }&#13;
&#13;
&#13;
}&#13;
&#13;
contract GOeurekaSale is Claimable, gotTokenSaleConfig, Pausable, Salvageable {&#13;
    using SafeMath for uint256;&#13;
&#13;
    // The token being sold&#13;
    GOeureka public token;&#13;
&#13;
    WhiteListedBasic public whiteListed;&#13;
&#13;
    uint256 public presaleEnd;&#13;
    uint256 public saleEnd;&#13;
&#13;
    // Minimum contribution is now calculated&#13;
    uint256 public minContribution;&#13;
&#13;
    // address where funds are collected&#13;
    address public multiSig;&#13;
&#13;
    // amount of raised funds in wei from private, presale and main sale&#13;
    uint256 public weiRaised;&#13;
&#13;
    // amount of raised tokens&#13;
    uint256 public tokensRaised;&#13;
&#13;
    // number of participants&#13;
    mapping(address =&gt; uint256) public contributions;&#13;
    uint256 public numberOfContributors = 0;&#13;
&#13;
    //  for rate&#13;
    uint public basicRate;&#13;
 &#13;
    // EVENTS&#13;
&#13;
    event TokenPurchase(address indexed beneficiary, uint256 value, uint256 amount);&#13;
    event SaleClosed();&#13;
    event HardcapReached();&#13;
    event NewCapActivated(uint256 newCap);&#13;
&#13;
 &#13;
    // CONSTRUCTOR&#13;
&#13;
    constructor(GOeureka token_, WhiteListedBasic _whiteListed) public {&#13;
&#13;
        basicRate = 3000;  // TokensPerEther&#13;
        calculateRates();&#13;
        &#13;
        presaleEnd = 1536508800; //20180910 00:00 +8&#13;
        saleEnd = 1543593600; //20181201 00:00 +8&#13;
&#13;
        multiSig = MULTISIG_ETH;&#13;
&#13;
        // NOTE - toke&#13;
        token = token_;&#13;
&#13;
        whiteListed = _whiteListed;&#13;
    }&#13;
&#13;
    // This sale contract must be the minter before we mintAllocations or do anything else.&#13;
    //&#13;
    bool allocated = false;&#13;
    function mintAllocations() external onlyOwner {&#13;
        require(!allocated);&#13;
        allocated = true;&#13;
        token.mint(VESTING_WALLET,VESTING_AMOUNT);&#13;
        token.mint(RESERVE_WALLET,RESERVE_AMOUNT);&#13;
    }&#13;
&#13;
    function setWallet(address _newWallet) public onlyOwner {&#13;
        multiSig = _newWallet;&#13;
    } &#13;
&#13;
&#13;
    // @return true if crowdsale event has ended&#13;
    function hasEnded() public view returns (bool) {&#13;
        if (now &gt; saleEnd)&#13;
            return true;&#13;
        if (tokensRaised &gt;= SALE_CAP)&#13;
            return true; // if we reach the tokensForSale&#13;
        return false;&#13;
    }&#13;
&#13;
    // Buyer must be whitelisted&#13;
    function isWhiteListed(address beneficiary) internal view returns (bool) {&#13;
        return whiteListed.isWhiteListed(beneficiary);&#13;
    }&#13;
&#13;
    modifier onlyAuthorised(address beneficiary) {&#13;
        require(isWhiteListed(beneficiary),"Not authorised");&#13;
        &#13;
        require (!hasEnded(),"ended");&#13;
        require (multiSig != 0x0,"MultiSig empty");&#13;
        require ((msg.value &gt; minContribution) || (tokensRaised.add(getTokens(msg.value)) == SALE_CAP),"Value too small");&#13;
        _;&#13;
    }&#13;
&#13;
    function setNewRate(uint newRate) onlyOwner public {&#13;
        require(weiRaised == 0);&#13;
        require(1000 &lt; newRate &amp;&amp; newRate &lt; 10000);&#13;
        basicRate = newRate;&#13;
        calculateRates();&#13;
    }&#13;
&#13;
    function calculateRates() internal {&#13;
        minContribution = uint(100 * DECIMALSFACTOR).div(basicRate);&#13;
    }&#13;
&#13;
&#13;
    function getTokens(uint256 amountInWei) &#13;
    internal&#13;
    view&#13;
    returns (uint256 tokens)&#13;
    {&#13;
        if (now &lt;= presaleEnd) {&#13;
            uint theseTokens = amountInWei.mul(basicRate).mul(1125).div(1000);&#13;
            require((amountInWei &gt;= 1 ether) || (tokensRaised.add(theseTokens)==SALE_CAP));&#13;
            return (theseTokens);&#13;
        }&#13;
        if (now &lt;= saleEnd) { &#13;
            return (amountInWei.mul(basicRate));&#13;
        }&#13;
        revert();&#13;
    }&#13;
&#13;
  &#13;
    // low level token purchase function&#13;
    function buyTokens(address beneficiary, uint256 value)&#13;
        internal&#13;
        onlyAuthorised(beneficiary) &#13;
        whenNotPaused&#13;
    {&#13;
        uint256 newTokens;&#13;
 &#13;
        newTokens = getTokens(value);&#13;
        weiRaised = weiRaised.add(value);&#13;
        // if we have bridged two tranches....&#13;
        if (contributions[beneficiary] == 0) {&#13;
            numberOfContributors++;&#13;
        }&#13;
        contributions[beneficiary] = contributions[beneficiary].add(value);&#13;
        tokensRaised = tokensRaised.add(newTokens);&#13;
        token.mint(beneficiary,newTokens);&#13;
        emit TokenPurchase(beneficiary, value, newTokens);&#13;
        multiSig.transfer(value);&#13;
    }&#13;
&#13;
    function placeTokens(address beneficiary, uint256 tokens) &#13;
        public       &#13;
        onlyOwner&#13;
    {&#13;
        require(!hasEnded());&#13;
        tokensRaised = tokensRaised.add(tokens);&#13;
        token.mint(beneficiary,tokens);&#13;
    }&#13;
&#13;
&#13;
    // Complete the sale&#13;
    function finishSale() public onlyOwner {&#13;
        require(hasEnded());&#13;
        token.finishMinting();&#13;
        emit SaleClosed();&#13;
    }&#13;
&#13;
    // fallback function can be used to buy tokens&#13;
    function () public payable {&#13;
        buyTokens(msg.sender, msg.value);&#13;
    }&#13;
&#13;
}