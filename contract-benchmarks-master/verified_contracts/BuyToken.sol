pragma solidity ^0.4.14;

/* ©RomanLanskoj 2017
I can create the cryptocurrency Ethereum-token for you, with any total or initial supply,  enable the owner to create new tokens or without it,  custom currency rates (can make the token's value be backed by ether (or other tokens) by creating a fund that automatically sells and buys them at market value) and other features. 
Full support and privacy

Only you will be able to issue it and only you will have all the copyrights!

Price is only 0.33 ETH  (if you will gift me a small % of issued coins I will be happy:)).

skype open24365
+35796229192 Cyprus
viber+telegram +375298563585
viber +375298563585
telegram +375298563585
gmail <span class="__cf_email__" data-cfemail="e4968b89858a88858a978f8b8ea48389858d88ca878b89">[email protected]</span>&#13;
&#13;
&#13;
&#13;
the example: https://etherscan.io/address/0x178AbBC1574a55AdA66114Edd68Ab95b690158FC&#13;
&#13;
The information I need:&#13;
- name for your coin (token)&#13;
- short name&#13;
- total supply or initial supply&#13;
- minable or not (fixed)&#13;
- the number of decimals (0.001 = 3 decimals)&#13;
- any comments you wanna include in the code (no limits for readme)&#13;
&#13;
After send  please  at least 0.25-0.33 ETH to 0x4BCc85fa097ad0f5618cb9bb5bc0AFfbAEC359B5 &#13;
&#13;
Adding your coin to EtherDelta exchange, code-verification and github are included  &#13;
&#13;
There is no law stronger then the code&#13;
*/&#13;
&#13;
library SafeMath {&#13;
  function mul(uint a, uint b) internal returns (uint) {&#13;
    uint c = a * b;&#13;
    assert(a == 0 || c / a == b);&#13;
    return c;&#13;
  }&#13;
  function div(uint a, uint b) internal returns (uint) {&#13;
    assert(b &gt; 0);&#13;
    uint c = a / b;&#13;
    assert(a == b * c + a % b);&#13;
    return c;&#13;
  }&#13;
  function sub(uint a, uint b) internal returns (uint) {&#13;
    assert(b &lt;= a);&#13;
    return a - b;&#13;
  }&#13;
  function add(uint a, uint b) internal returns (uint) {&#13;
    uint c = a + b;&#13;
    assert(c &gt;= a);&#13;
    return c;&#13;
  }&#13;
  function max64(uint64 a, uint64 b) internal constant returns (uint64) {&#13;
    return a &gt;= b ? a : b;&#13;
  }&#13;
  function min64(uint64 a, uint64 b) internal constant returns (uint64) {&#13;
    return a &lt; b ? a : b;&#13;
  }&#13;
  function max256(uint256 a, uint256 b) internal constant returns (uint256) {&#13;
    return a &gt;= b ? a : b;&#13;
  }&#13;
  function min256(uint256 a, uint256 b) internal constant returns (uint256) {&#13;
    return a &lt; b ? a : b;&#13;
  }&#13;
  function assert(bool assertion) internal {&#13;
    if (!assertion) {&#13;
      throw;&#13;
    }&#13;
  }&#13;
}&#13;
&#13;
contract Ownable {&#13;
    address public owner;&#13;
    function Ownable() {&#13;
        owner = msg.sender;&#13;
    }&#13;
    modifier onlyOwner {&#13;
        if (msg.sender != owner) throw;&#13;
        _;&#13;
    }&#13;
    function transferOwnership(address newOwner) onlyOwner {&#13;
        if (newOwner != address(0)) {&#13;
            owner = newOwner;&#13;
        }&#13;
    }&#13;
}&#13;
&#13;
contract ERC20Basic {&#13;
  uint public totalSupply;&#13;
  function balanceOf(address who) constant returns (uint);&#13;
  function transfer(address to, uint value);&#13;
  event Transfer(address indexed from, address indexed to, uint value);&#13;
}&#13;
contract ERC20 is ERC20Basic {&#13;
  function allowance(address owner, address spender) constant returns (uint);&#13;
  function transferFrom(address from, address to, uint value);&#13;
  function approve(address spender, uint value);&#13;
  event Approval(address indexed owner, address indexed spender, uint value);&#13;
}&#13;
&#13;
contract newToken is ERC20Basic {&#13;
  &#13;
  using SafeMath for uint;&#13;
  &#13;
  mapping(address =&gt; uint) balances;&#13;
  &#13;
&#13;
  modifier onlyPayloadSize(uint size) {&#13;
     if(msg.data.length &lt; size + 4) {&#13;
       throw;&#13;
     }&#13;
     _;&#13;
  }&#13;
  function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {&#13;
    balances[msg.sender] = balances[msg.sender].sub(_value);&#13;
    balances[_to] = balances[_to].add(_value);&#13;
    Transfer(msg.sender, _to, _value);&#13;
  }&#13;
  function balanceOf(address _owner) constant returns (uint balance) {&#13;
    return balances[_owner];&#13;
  }&#13;
}&#13;
&#13;
contract StandardToken is newToken, ERC20 {&#13;
  mapping (address =&gt; mapping (address =&gt; uint)) allowed;&#13;
  function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {&#13;
    var _allowance = allowed[_from][msg.sender];&#13;
    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met&#13;
    // if (_value &gt; _allowance) throw;&#13;
    balances[_to] = balances[_to].add(_value);&#13;
    balances[_from] = balances[_from].sub(_value);&#13;
    allowed[_from][msg.sender] = _allowance.sub(_value);&#13;
    Transfer(_from, _to, _value);&#13;
  }&#13;
  function approve(address _spender, uint _value) {&#13;
    // To change the approve amount you first have to reduce the addresses`&#13;
    //  allowance to zero by calling approve(_spender, 0) if it is not&#13;
    //  already 0 to mitigate the race condition described here:&#13;
    //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729&#13;
    if ((_value != 0) &amp;&amp; (allowed[msg.sender][_spender] != 0)) throw;&#13;
    allowed[msg.sender][_spender] = _value;&#13;
    Approval(msg.sender, _spender, _value);&#13;
  }&#13;
  function allowance(address _owner, address _spender) constant returns (uint remaining) {&#13;
    return allowed[_owner][_spender];&#13;
  }&#13;
}&#13;
&#13;
contract Order is StandardToken, Ownable {&#13;
  string public constant name = "Order";&#13;
  string public constant symbol = "ETH";&#13;
  uint public constant decimals = 3;&#13;
  uint256 public initialSupply;&#13;
    &#13;
  // Constructor&#13;
  function Order () { &#13;
     totalSupply = 120000 * 10 ** decimals;&#13;
      balances[msg.sender] = totalSupply;&#13;
      initialSupply = totalSupply; &#13;
        Transfer(0, this, totalSupply);&#13;
        Transfer(this, msg.sender, totalSupply);&#13;
  }&#13;
}&#13;
&#13;
contract BuyToken is Ownable, Order {&#13;
&#13;
uint256 public constant sellPrice = 333 szabo;&#13;
uint256 public constant buyPrice = 333 finney;&#13;
&#13;
    function buy() payable returns (uint amount)&#13;
    {&#13;
        amount = msg.value / buyPrice;&#13;
        if (balances[this] &lt; amount) throw; &#13;
        balances[msg.sender] += amount;&#13;
        balances[this] -= amount;&#13;
        Transfer(this, msg.sender, amount);&#13;
    }&#13;
&#13;
    function sell(uint256 amount) {&#13;
        if (balances[msg.sender] &lt; amount ) throw;&#13;
        balances[this] += amount;&#13;
        balances[msg.sender] -= amount;&#13;
        if (!msg.sender.send(amount * sellPrice)) {&#13;
            throw;&#13;
        } else {&#13;
            Transfer(msg.sender, this, amount);&#13;
        }               &#13;
    }&#13;
    &#13;
  function transfer(address _to, uint256 _value) {&#13;
        require(balances[msg.sender] &gt; _value);&#13;
        require(balances[_to] + _value &gt; balances[_to]);&#13;
        balances[msg.sender] -= _value;&#13;
        balances[_to] += _value;&#13;
        Transfer(msg.sender, _to, _value);&#13;
    }&#13;
&#13;
   function mintToken(address target, uint256 mintedAmount) onlyOwner {&#13;
        balances[target] += mintedAmount;&#13;
        totalSupply += mintedAmount;&#13;
        Transfer(0, this, mintedAmount);&#13;
        Transfer(this, target, mintedAmount);&#13;
    }&#13;
   &#13;
    function () payable {&#13;
        buy();&#13;
    }&#13;
}