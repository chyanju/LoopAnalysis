pragma solidity 0.4.24;

// File: openzeppelin-solidity/contracts/ownership/Ownable.sol

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipRenounced(address indexed previousOwner);
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() public {
    owner = msg.sender;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipRenounced(owner);
    owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function transferOwnership(address _newOwner) public onlyOwner {
    _transferOwnership(_newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param _newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address _newOwner) internal {
    require(_newOwner != address(0));
    emit OwnershipTransferred(owner, _newOwner);
    owner = _newOwner;
  }
}

// File: openzeppelin-solidity/contracts/ownership/HasNoEther.sol

/**
 * @title Contracts that should not own Ether
 * @author Remco Bloemen <<span class="__cf_email__" data-cfemail="b5c7d0d8d6daf587">[email protected]</span>π.com&gt;&#13;
 * @dev This tries to block incoming ether to prevent accidental loss of Ether. Should Ether end up&#13;
 * in the contract, it will allow the owner to reclaim this Ether.&#13;
 * @notice Ether can still be sent to this contract by:&#13;
 * calling functions labeled `payable`&#13;
 * `selfdestruct(contract_address)`&#13;
 * mining directly to the contract address&#13;
 */&#13;
contract HasNoEther is Ownable {&#13;
&#13;
  /**&#13;
  * @dev Constructor that rejects incoming Ether&#13;
  * The `payable` flag is added so we can access `msg.value` without compiler warning. If we&#13;
  * leave out payable, then Solidity will allow inheriting contracts to implement a payable&#13;
  * constructor. By doing it this way we prevent a payable constructor from working. Alternatively&#13;
  * we could use assembly to access msg.value.&#13;
  */&#13;
  constructor() public payable {&#13;
    require(msg.value == 0);&#13;
  }&#13;
&#13;
  /**&#13;
   * @dev Disallows direct send by setting a default function without the `payable` flag.&#13;
   */&#13;
  function() external {&#13;
  }&#13;
&#13;
  /**&#13;
   * @dev Transfer all Ether held by the contract to the owner.&#13;
   */&#13;
  function reclaimEther() external onlyOwner {&#13;
    owner.transfer(address(this).balance);&#13;
  }&#13;
}&#13;
&#13;
// File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol&#13;
&#13;
/**&#13;
 * @title ERC20Basic&#13;
 * @dev Simpler version of ERC20 interface&#13;
 * See https://github.com/ethereum/EIPs/issues/179&#13;
 */&#13;
contract ERC20Basic {&#13;
  function totalSupply() public view returns (uint256);&#13;
  function balanceOf(address _who) public view returns (uint256);&#13;
  function transfer(address _to, uint256 _value) public returns (bool);&#13;
  event Transfer(address indexed from, address indexed to, uint256 value);&#13;
}&#13;
&#13;
// File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol&#13;
&#13;
/**&#13;
 * @title ERC20 interface&#13;
 * @dev see https://github.com/ethereum/EIPs/issues/20&#13;
 */&#13;
contract ERC20 is ERC20Basic {&#13;
  function allowance(address _owner, address _spender)&#13;
    public view returns (uint256);&#13;
&#13;
  function transferFrom(address _from, address _to, uint256 _value)&#13;
    public returns (bool);&#13;
&#13;
  function approve(address _spender, uint256 _value) public returns (bool);&#13;
  event Approval(&#13;
    address indexed owner,&#13;
    address indexed spender,&#13;
    uint256 value&#13;
  );&#13;
}&#13;
&#13;
// File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol&#13;
&#13;
/**&#13;
 * @title SafeERC20&#13;
 * @dev Wrappers around ERC20 operations that throw on failure.&#13;
 * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,&#13;
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.&#13;
 */&#13;
library SafeERC20 {&#13;
  function safeTransfer(&#13;
    ERC20Basic _token,&#13;
    address _to,&#13;
    uint256 _value&#13;
  )&#13;
    internal&#13;
  {&#13;
    require(_token.transfer(_to, _value));&#13;
  }&#13;
&#13;
  function safeTransferFrom(&#13;
    ERC20 _token,&#13;
    address _from,&#13;
    address _to,&#13;
    uint256 _value&#13;
  )&#13;
    internal&#13;
  {&#13;
    require(_token.transferFrom(_from, _to, _value));&#13;
  }&#13;
&#13;
  function safeApprove(&#13;
    ERC20 _token,&#13;
    address _spender,&#13;
    uint256 _value&#13;
  )&#13;
    internal&#13;
  {&#13;
    require(_token.approve(_spender, _value));&#13;
  }&#13;
}&#13;
&#13;
// File: openzeppelin-solidity/contracts/ownership/CanReclaimToken.sol&#13;
&#13;
/**&#13;
 * @title Contracts that should be able to recover tokens&#13;
 * @author SylTi&#13;
 * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.&#13;
 * This will prevent any accidental loss of tokens.&#13;
 */&#13;
contract CanReclaimToken is Ownable {&#13;
  using SafeERC20 for ERC20Basic;&#13;
&#13;
  /**&#13;
   * @dev Reclaim all ERC20Basic compatible tokens&#13;
   * @param _token ERC20Basic The address of the token contract&#13;
   */&#13;
  function reclaimToken(ERC20Basic _token) external onlyOwner {&#13;
    uint256 balance = _token.balanceOf(this);&#13;
    _token.safeTransfer(owner, balance);&#13;
  }&#13;
&#13;
}&#13;
&#13;
// File: openzeppelin-solidity/contracts/ownership/HasNoTokens.sol&#13;
&#13;
/**&#13;
 * @title Contracts that should not own Tokens&#13;
 * @author Remco Bloemen &lt;<span class="__cf_email__" data-cfemail="9ceef9f1fff3dcae">[email protected]</span>π.com&gt;&#13;
 * @dev This blocks incoming ERC223 tokens to prevent accidental loss of tokens.&#13;
 * Should tokens (any ERC20Basic compatible) end up in the contract, it allows the&#13;
 * owner to reclaim the tokens.&#13;
 */&#13;
contract HasNoTokens is CanReclaimToken {&#13;
&#13;
 /**&#13;
  * @dev Reject all ERC223 compatible tokens&#13;
  * @param _from address The address that is transferring the tokens&#13;
  * @param _value uint256 the amount of the specified token&#13;
  * @param _data Bytes The data passed from the caller.&#13;
  */&#13;
  function tokenFallback(&#13;
    address _from,&#13;
    uint256 _value,&#13;
    bytes _data&#13;
  )&#13;
    external&#13;
    pure&#13;
  {&#13;
    _from;&#13;
    _value;&#13;
    _data;&#13;
    revert();&#13;
  }&#13;
&#13;
}&#13;
&#13;
// File: openzeppelin-solidity/contracts/ownership/HasNoContracts.sol&#13;
&#13;
/**&#13;
 * @title Contracts that should not own Contracts&#13;
 * @author Remco Bloemen &lt;<span class="__cf_email__" data-cfemail="097b6c646a66493b">[email protected]</span>π.com&gt;&#13;
 * @dev Should contracts (anything Ownable) end up being owned by this contract, it allows the owner&#13;
 * of this contract to reclaim ownership of the contracts.&#13;
 */&#13;
contract HasNoContracts is Ownable {&#13;
&#13;
  /**&#13;
   * @dev Reclaim ownership of Ownable contracts&#13;
   * @param _contractAddr The address of the Ownable to be reclaimed.&#13;
   */&#13;
  function reclaimContract(address _contractAddr) external onlyOwner {&#13;
    Ownable contractInst = Ownable(_contractAddr);&#13;
    contractInst.transferOwnership(owner);&#13;
  }&#13;
}&#13;
&#13;
// File: openzeppelin-solidity/contracts/ownership/NoOwner.sol&#13;
&#13;
/**&#13;
 * @title Base contract for contracts that should not own things.&#13;
 * @author Remco Bloemen &lt;<span class="__cf_email__" data-cfemail="a0d2c5cdc3cfe092">[email protected]</span>π.com&gt;&#13;
 * @dev Solves a class of errors where a contract accidentally becomes owner of Ether, Tokens or&#13;
 * Owned contracts. See respective base contracts for details.&#13;
 */&#13;
contract NoOwner is HasNoEther, HasNoTokens, HasNoContracts {&#13;
}&#13;
&#13;
// File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol&#13;
&#13;
/**&#13;
 * @title DetailedERC20 token&#13;
 * @dev The decimals are only for visualization purposes.&#13;
 * All the operations are done using the smallest and indivisible token unit,&#13;
 * just as on Ethereum all the operations are done in wei.&#13;
 */&#13;
contract DetailedERC20 is ERC20 {&#13;
  string public name;&#13;
  string public symbol;&#13;
  uint8 public decimals;&#13;
&#13;
  constructor(string _name, string _symbol, uint8 _decimals) public {&#13;
    name = _name;&#13;
    symbol = _symbol;&#13;
    decimals = _decimals;&#13;
  }&#13;
}&#13;
&#13;
// File: openzeppelin-solidity/contracts/math/SafeMath.sol&#13;
&#13;
/**&#13;
 * @title SafeMath&#13;
 * @dev Math operations with safety checks that throw on error&#13;
 */&#13;
library SafeMath {&#13;
&#13;
  /**&#13;
  * @dev Multiplies two numbers, throws on overflow.&#13;
  */&#13;
  function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {&#13;
    // Gas optimization: this is cheaper than asserting 'a' not being zero, but the&#13;
    // benefit is lost if 'b' is also tested.&#13;
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522&#13;
    if (_a == 0) {&#13;
      return 0;&#13;
    }&#13;
&#13;
    c = _a * _b;&#13;
    assert(c / _a == _b);&#13;
    return c;&#13;
  }&#13;
&#13;
  /**&#13;
  * @dev Integer division of two numbers, truncating the quotient.&#13;
  */&#13;
  function div(uint256 _a, uint256 _b) internal pure returns (uint256) {&#13;
    // assert(_b &gt; 0); // Solidity automatically throws when dividing by 0&#13;
    // uint256 c = _a / _b;&#13;
    // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold&#13;
    return _a / _b;&#13;
  }&#13;
&#13;
  /**&#13;
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).&#13;
  */&#13;
  function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {&#13;
    assert(_b &lt;= _a);&#13;
    return _a - _b;&#13;
  }&#13;
&#13;
  /**&#13;
  * @dev Adds two numbers, throws on overflow.&#13;
  */&#13;
  function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {&#13;
    c = _a + _b;&#13;
    assert(c &gt;= _a);&#13;
    return c;&#13;
  }&#13;
}&#13;
&#13;
// File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol&#13;
&#13;
/**&#13;
 * @title Basic token&#13;
 * @dev Basic version of StandardToken, with no allowances.&#13;
 */&#13;
contract BasicToken is ERC20Basic {&#13;
  using SafeMath for uint256;&#13;
&#13;
  mapping(address =&gt; uint256) internal balances;&#13;
&#13;
  uint256 internal totalSupply_;&#13;
&#13;
  /**&#13;
  * @dev Total number of tokens in existence&#13;
  */&#13;
  function totalSupply() public view returns (uint256) {&#13;
    return totalSupply_;&#13;
  }&#13;
&#13;
  /**&#13;
  * @dev Transfer token for a specified address&#13;
  * @param _to The address to transfer to.&#13;
  * @param _value The amount to be transferred.&#13;
  */&#13;
  function transfer(address _to, uint256 _value) public returns (bool) {&#13;
    require(_value &lt;= balances[msg.sender]);&#13;
    require(_to != address(0));&#13;
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
// File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol&#13;
&#13;
/**&#13;
 * @title Burnable Token&#13;
 * @dev Token that can be irreversibly burned (destroyed).&#13;
 */&#13;
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
// File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol&#13;
&#13;
/**&#13;
 * @title Standard ERC20 token&#13;
 *&#13;
 * @dev Implementation of the basic standard token.&#13;
 * https://github.com/ethereum/EIPs/issues/20&#13;
 * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol&#13;
 */&#13;
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
    require(_value &lt;= balances[_from]);&#13;
    require(_value &lt;= allowed[_from][msg.sender]);&#13;
    require(_to != address(0));&#13;
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
   * approve should be called when allowed[_spender] == 0. To increment&#13;
   * allowed value is better to use this function to avoid 2 calls (and wait until&#13;
   * the first transaction is mined)&#13;
   * From MonolithDAO Token.sol&#13;
   * @param _spender The address which will spend the funds.&#13;
   * @param _addedValue The amount of tokens to increase the allowance by.&#13;
   */&#13;
  function increaseApproval(&#13;
    address _spender,&#13;
    uint256 _addedValue&#13;
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
   * approve should be called when allowed[_spender] == 0. To decrement&#13;
   * allowed value is better to use this function to avoid 2 calls (and wait until&#13;
   * the first transaction is mined)&#13;
   * From MonolithDAO Token.sol&#13;
   * @param _spender The address which will spend the funds.&#13;
   * @param _subtractedValue The amount of tokens to decrease the allowance by.&#13;
   */&#13;
  function decreaseApproval(&#13;
    address _spender,&#13;
    uint256 _subtractedValue&#13;
  )&#13;
    public&#13;
    returns (bool)&#13;
  {&#13;
    uint256 oldValue = allowed[msg.sender][_spender];&#13;
    if (_subtractedValue &gt;= oldValue) {&#13;
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
// File: openzeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol&#13;
&#13;
/**&#13;
 * @title Standard Burnable Token&#13;
 * @dev Adds burnFrom method to ERC20 implementations&#13;
 */&#13;
contract StandardBurnableToken is BurnableToken, StandardToken {&#13;
&#13;
  /**&#13;
   * @dev Burns a specific amount of tokens from the target address and decrements allowance&#13;
   * @param _from address The address which you want to send tokens from&#13;
   * @param _value uint256 The amount of token to be burned&#13;
   */&#13;
  function burnFrom(address _from, uint256 _value) public {&#13;
    require(_value &lt;= allowed[_from][msg.sender]);&#13;
    // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,&#13;
    // this function needs to emit an event with the updated approval.&#13;
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);&#13;
    _burn(_from, _value);&#13;
  }&#13;
}&#13;
&#13;
// File: contracts/lifecycle/Finalizable.sol&#13;
&#13;
/**&#13;
 * @title Finalizable contract&#13;
 * @dev Lifecycle extension where an owner can do extra work after finishing.&#13;
 */&#13;
contract Finalizable is Ownable {&#13;
  using SafeMath for uint256;&#13;
&#13;
  /// @dev Throws if called before the contract is finalized.&#13;
  modifier onlyFinalized() {&#13;
    require(isFinalized, "Contract not finalized.");&#13;
    _;&#13;
  }&#13;
&#13;
  /// @dev Throws if called after the contract is finalized.&#13;
  modifier onlyNotFinalized() {&#13;
    require(!isFinalized, "Contract already finalized.");&#13;
    _;&#13;
  }&#13;
&#13;
  bool public isFinalized = false;&#13;
&#13;
  event Finalized();&#13;
&#13;
  /**&#13;
   * @dev Called by owner to do some extra finalization&#13;
   * work. Calls the contract's finalization function.&#13;
   */&#13;
  function finalize() public onlyOwner onlyNotFinalized {&#13;
    finalization();&#13;
    emit Finalized();&#13;
&#13;
    isFinalized = true;&#13;
  }&#13;
&#13;
  /**&#13;
   * @dev Can be overridden to add finalization logic. The overriding function&#13;
   * should call super.finalization() to ensure the chain of finalization is&#13;
   * executed entirely.&#13;
   */&#13;
  function finalization() internal {&#13;
    // override&#13;
  }&#13;
&#13;
}&#13;
&#13;
// File: contracts/token/ERC20/SafeStandardToken.sol&#13;
&#13;
/**&#13;
 * @title SafeStandardToken&#13;
 * @dev An ERC20 token implementation which disallows transfers to this contract.&#13;
 */&#13;
contract SafeStandardToken is StandardToken {&#13;
&#13;
  /// @dev Throws if destination address is not valid.&#13;
  modifier onlyValidDestination(address _to) {&#13;
    require(_to != address(this), "Transfering tokens to this contract address is not allowed.");&#13;
    _;&#13;
  }&#13;
&#13;
  /**&#13;
   * @dev Transfer token for a specified address&#13;
   * @param _to The address to transfer to.&#13;
   * @param _value The amount to be transferred.&#13;
   */&#13;
  function transfer(address _to, uint256 _value)&#13;
    public&#13;
    onlyValidDestination(_to)&#13;
    returns (bool)&#13;
  {&#13;
    return super.transfer(_to, _value);&#13;
  }&#13;
&#13;
  /**&#13;
   * @dev Transfer tokens from one address to another&#13;
   * @param _from address The address which you want to send tokens from&#13;
   * @param _to address The address which you want to transfer to&#13;
   * @param _value uint256 the amount of tokens to be transferred&#13;
   */&#13;
  function transferFrom(address _from, address _to, uint256 _value)&#13;
    public&#13;
    onlyValidDestination(_to)&#13;
    returns (bool)&#13;
  {&#13;
    return super.transferFrom(_from, _to, _value);&#13;
  }&#13;
&#13;
&#13;
}&#13;
&#13;
// File: contracts/TolarToken.sol&#13;
&#13;
/**&#13;
 * @title TolarToken&#13;
 * @dev ERC20 Tolar Token (TOL)&#13;
 *&#13;
 * TOL Tokens are divisible by 1e18 (1 000 000 000 000 000 000) base.&#13;
 *&#13;
 * TOL are displayed using 18 decimal places of precision.&#13;
 *&#13;
 * 1 TOL is equivalent to:&#13;
 *   1 000 000 000 000 000 000 == 1 * 10**18 == 1e18&#13;
 *&#13;
 * 1 Billion TOL (total supply) is equivalent to:&#13;
 *   1000000000 * 10**18 == 1e27&#13;
 *&#13;
 * @notice All tokens are pre-assigned to the creator. Note they can later distribute these&#13;
 * tokens as they wish using `transfer` and other `StandardToken` functions.&#13;
 * This is a BurnableToken where users can burn tokens when the burning functionality is&#13;
 * enabled (contract is finalized) by the owner.&#13;
 */&#13;
contract TolarToken is NoOwner, Finalizable, DetailedERC20, SafeStandardToken, StandardBurnableToken {&#13;
&#13;
  string public constant NAME = "Tolar Token";&#13;
  string public constant SYMBOL = "TOL";&#13;
  uint8 public constant DECIMALS = 18;&#13;
&#13;
  uint256 public constant INITIAL_SUPPLY = 1000000000 * (10 ** uint256(DECIMALS));&#13;
&#13;
  /// @dev Throws if called before the contract is finalized.&#13;
  modifier onlyFinalizedOrOwner() {&#13;
    require(isFinalized || msg.sender == owner, "Contract not finalized or sender not owner.");&#13;
    _;&#13;
  }&#13;
&#13;
  /// @dev Constructor that gives msg.sender all of existing tokens.&#13;
  constructor() public DetailedERC20(NAME, SYMBOL, DECIMALS) {&#13;
    totalSupply_ = INITIAL_SUPPLY;&#13;
    balances[msg.sender] = INITIAL_SUPPLY;&#13;
    emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);&#13;
  }&#13;
&#13;
  /**&#13;
   * @dev Overrides StandardToken._burn in order for burn and burnFrom to be disabled&#13;
   * when the contract is paused.&#13;
   */&#13;
  function _burn(address _who, uint256 _value) internal onlyFinalizedOrOwner {&#13;
    super._burn(_who, _value);&#13;
  }&#13;
&#13;
}