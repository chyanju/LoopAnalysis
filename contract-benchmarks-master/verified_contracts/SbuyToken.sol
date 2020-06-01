pragma solidity ^0.4.11;
// sol ควรจะสั้นๆ ตรงไปตรงมา อย่าเยอะ
// Dome C. <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="bdd9d2d0d8fdc9d8d193ded293c9d5">[email protected]</a>&gt; &#13;
contract SbuyToken {&#13;
&#13;
    string public name = "SbuyMining";      //  token name&#13;
    string public symbol = "SBUY";           //  token symbol&#13;
    uint256 public decimals = 0;            //  token digit&#13;
&#13;
    mapping (address =&gt; uint256) public balanceOf;&#13;
    mapping (address =&gt; mapping (address =&gt; uint256)) public allowance;&#13;
&#13;
    uint256 public totalSupply = 0;&#13;
    bool public stopped = false;&#13;
&#13;
    uint256 constant valueFounder = 2000000000;&#13;
    address owner = 0x0;&#13;
&#13;
    modifier isOwner {&#13;
        assert(owner == msg.sender);&#13;
        _;&#13;
    }&#13;
&#13;
    modifier isRunning {&#13;
        assert (!stopped);&#13;
        _;&#13;
    }&#13;
&#13;
    modifier validAddress {&#13;
        assert(0x0 != msg.sender);&#13;
        _;&#13;
    }&#13;
&#13;
    function  SbuyToken(address _addressFounder) public {&#13;
        owner = msg.sender;&#13;
        totalSupply = valueFounder;&#13;
        balanceOf[_addressFounder] = valueFounder;&#13;
        Transfer(0x0, _addressFounder, valueFounder);&#13;
    }&#13;
    &#13;
&#13;
    function transfer (address _to, uint256 _value) public isRunning validAddress returns (bool success)  {&#13;
        require(balanceOf[msg.sender] &gt;= _value);&#13;
        require(balanceOf[_to] + _value &gt;= balanceOf[_to]);&#13;
        balanceOf[msg.sender] -= _value;&#13;
        balanceOf[_to] += _value;&#13;
        Transfer(msg.sender, _to, _value);&#13;
        return true;&#13;
    }&#13;
&#13;
    function transferFrom  (address _from, address _to, uint256 _value) public isRunning validAddress returns (bool success) {&#13;
        require(balanceOf[_from] &gt;= _value);&#13;
        require(balanceOf[_to] + _value &gt;= balanceOf[_to]);&#13;
        require(allowance[_from][msg.sender] &gt;= _value);&#13;
        balanceOf[_to] += _value;&#13;
        balanceOf[_from] -= _value;&#13;
        allowance[_from][msg.sender] -= _value;&#13;
        Transfer(_from, _to, _value);&#13;
        return true;&#13;
    }&#13;
&#13;
    function approve(address _spender, uint256 _value) public isRunning validAddress returns (bool success) {&#13;
        require(_value == 0 || allowance[msg.sender][_spender] == 0);&#13;
        allowance[msg.sender][_spender] = _value;&#13;
        Approval(msg.sender, _spender, _value);&#13;
        return true;&#13;
    }&#13;
&#13;
    function stop() isOwner public {&#13;
        stopped = true;&#13;
    }&#13;
&#13;
    function start() isOwner public {&#13;
        stopped = false;&#13;
    }&#13;
&#13;
    function setName(string _name) isOwner public {&#13;
        name = _name;&#13;
    }&#13;
&#13;
    function burn(uint256 _value) public {&#13;
        require(balanceOf[msg.sender] &gt;= _value);&#13;
        balanceOf[msg.sender] -= _value;&#13;
        balanceOf[0x0] += _value;&#13;
        Transfer(msg.sender, 0x0, _value);&#13;
    }&#13;
&#13;
    event Transfer(address indexed _from, address indexed _to, uint256 _value);&#13;
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);&#13;
}