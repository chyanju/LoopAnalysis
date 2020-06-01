pragma solidity ^0.4.16;
 
/* 
   Blockchain Forest Ltd
Blockchain DAPP . Decentralized Token Private Placement Programme (DTPPP) . Environmental Digital Assets . 
Fintech Facilitation Office:
CoPlace 1, 2270 Jalan Usahawan 2, Cyber 6, 63000 Cyberjaya. West Malaysia
Support Line: +603.9212.6666
<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="a6c2c7d6d6e6c4cac9c5cdc5cec7cfc8c0c9d4c3d5d288cfc9">[email protected]</a>&#13;
&#13;
Malaysia . Hong Kong . Amsterdam . UK.  China&#13;
&#13;
#treetoken&#13;
 */&#13;
contract ERC20Basic {&#13;
  uint256 public totalSupply;&#13;
  function balanceOf(address who) constant returns (uint256);&#13;
  function transfer(address to, uint256 value) returns (bool);&#13;
  event Transfer(address indexed from, address indexed to, uint256 value);&#13;
}&#13;
 &#13;
/*&#13;
   ERC20 interface&#13;
  see https://github.com/ethereum/EIPs/issues/20&#13;
 */&#13;
contract ERC20 is ERC20Basic {&#13;
  function allowance(address owner, address spender) constant returns (uint256);&#13;
  function transferFrom(address from, address to, uint256 value) returns (bool);&#13;
  function approve(address spender, uint256 value) returns (bool);&#13;
  event Approval(address indexed owner, address indexed spender, uint256 value);&#13;
}&#13;
 &#13;
/*  SafeMath - the lowest gas library&#13;
  Math operations with safety checks that throw on error&#13;
 */&#13;
library SafeMath {&#13;
    &#13;
  function mul(uint256 a, uint256 b) internal constant returns (uint256) {&#13;
    uint256 c = a * b;&#13;
    assert(a == 0 || c / a == b);&#13;
    return c;&#13;
  }&#13;
 &#13;
  function div(uint256 a, uint256 b) internal constant returns (uint256) {&#13;
    // assert(b &gt; 0); // Solidity automatically throws when dividing by 0&#13;
    uint256 c = a / b;&#13;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold&#13;
    return c;&#13;
  }&#13;
 &#13;
  function sub(uint256 a, uint256 b) internal constant returns (uint256) {&#13;
    assert(b &lt;= a);&#13;
    return a - b;&#13;
  }&#13;
 &#13;
  function add(uint256 a, uint256 b) internal constant returns (uint256) {&#13;
    uint256 c = a + b;&#13;
    assert(c &gt;= a);&#13;
    return c;&#13;
  }&#13;
  &#13;
}&#13;
 &#13;
/*&#13;
Basic token&#13;
 Basic version of StandardToken, with no allowances. &#13;
 */&#13;
contract BasicToken is ERC20Basic {&#13;
    &#13;
  using SafeMath for uint256;&#13;
 &#13;
  mapping(address =&gt; uint256) balances;&#13;
 &#13;
 function transfer(address _to, uint256 _value) returns (bool) {&#13;
    balances[msg.sender] = balances[msg.sender].sub(_value);&#13;
    balances[_to] = balances[_to].add(_value);&#13;
    Transfer(msg.sender, _to, _value);&#13;
    return true;&#13;
  }&#13;
 &#13;
  /*&#13;
  Gets the balance of the specified address.&#13;
   param _owner The address to query the the balance of. &#13;
   return An uint256 representing the amount owned by the passed address.&#13;
  */&#13;
  function balanceOf(address _owner) constant returns (uint256 balance) {&#13;
    return balances[_owner];&#13;
  }&#13;
 &#13;
}&#13;
 &#13;
/* Implementation of the basic standard token.&#13;
  https://github.com/ethereum/EIPs/issues/20&#13;
 */&#13;
contract StandardToken is ERC20, BasicToken {&#13;
 &#13;
  mapping (address =&gt; mapping (address =&gt; uint256)) allowed;&#13;
 &#13;
  /*&#13;
    Transfer tokens from one address to another&#13;
    param _from address The address which you want to send tokens from&#13;
    param _to address The address which you want to transfer to&#13;
    param _value uint256 the amout of tokens to be transfered&#13;
   */&#13;
  function transferFrom(address _from, address _to, uint256 _value) returns (bool) {&#13;
    var _allowance = allowed[_from][msg.sender];&#13;
 &#13;
    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met&#13;
    // require (_value &lt;= _allowance);&#13;
 &#13;
    balances[_to] = balances[_to].add(_value);&#13;
    balances[_from] = balances[_from].sub(_value);&#13;
    allowed[_from][msg.sender] = _allowance.sub(_value);&#13;
    Transfer(_from, _to, _value);&#13;
    return true;&#13;
  }&#13;
 &#13;
  /*&#13;
  Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.&#13;
   param _spender The address which will spend the funds.&#13;
   param _value The amount of Roman Lanskoj's tokens to be spent.&#13;
   */&#13;
  function approve(address _spender, uint256 _value) returns (bool) {&#13;
 &#13;
    // To change the approve amount you first have to reduce the addresses`&#13;
    //  allowance to zero by calling `approve(_spender, 0)` if it is not&#13;
    //  already 0 to mitigate the race condition described here:&#13;
    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729&#13;
    require((_value == 0) || (allowed[msg.sender][_spender] == 0));&#13;
 &#13;
    allowed[msg.sender][_spender] = _value;&#13;
    Approval(msg.sender, _spender, _value);&#13;
    return true;&#13;
  }&#13;
 &#13;
  /*&#13;
  Function to check the amount of tokens that an owner allowed to a spender.&#13;
  param _owner address The address which owns the funds.&#13;
  param _spender address The address which will spend the funds.&#13;
  return A uint256 specifing the amount of tokens still available for the spender.&#13;
   */&#13;
  function allowance(address _owner, address _spender) constant returns (uint256 remaining) {&#13;
    return allowed[_owner][_spender];&#13;
}&#13;
}&#13;
 &#13;
/*&#13;
The Ownable contract has an owner address, and provides basic authorization control&#13;
 functions, this simplifies the implementation of "user permissions".&#13;
 */&#13;
contract Ownable {&#13;
    &#13;
  address public owner;&#13;
 &#13;
 &#13;
  function Ownable() {&#13;
    owner = msg.sender;&#13;
  }&#13;
 &#13;
  /*&#13;
  Throws if called by any account other than the owner.&#13;
   */&#13;
  modifier onlyOwner() {&#13;
    require(msg.sender == owner);&#13;
    _;&#13;
  }&#13;
 &#13;
  /*&#13;
  Allows the current owner to transfer control of the contract to a newOwner.&#13;
  param newOwner The address to transfer ownership to.&#13;
   */&#13;
  function transferOwnership(address newOwner) onlyOwner {&#13;
    require(newOwner != address(0));      &#13;
    owner = newOwner;&#13;
  }&#13;
 &#13;
}&#13;
 &#13;
contract TheLiquidToken is StandardToken, Ownable {&#13;
    // mint can be finished and token become fixed for forever&#13;
  event Mint(address indexed to, uint256 amount);&#13;
  event MintFinished();&#13;
  bool mintingFinished = false;&#13;
  modifier canMint() {&#13;
    require(!mintingFinished);&#13;
    _;&#13;
  }&#13;
 &#13;
 function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {&#13;
    totalSupply = totalSupply.add(_amount);&#13;
    balances[_to] = balances[_to].add(_amount);&#13;
    Mint(_to, _amount);&#13;
    return true;&#13;
  }&#13;
 &#13;
  /*&#13;
  Function to stop minting new tokens.&#13;
  return True if the operation was successful.&#13;
   */&#13;
  function finishMinting() onlyOwner returns (bool) {}&#13;
  &#13;
}&#13;
    &#13;
contract TREETOKEN is TheLiquidToken {&#13;
  string public constant name = "TREE TOKEN";&#13;
  string public constant symbol = "TREE";&#13;
  uint public constant decimals = 2;&#13;
  uint256 public initialSupply;&#13;
    &#13;
  function TREETOKEN () { &#13;
     totalSupply = 300000000 * 10 ** decimals;&#13;
      balances[msg.sender] = totalSupply;&#13;
      initialSupply = totalSupply; &#13;
        Transfer(0, this, totalSupply);&#13;
        Transfer(this, msg.sender, totalSupply);&#13;
  }&#13;
}