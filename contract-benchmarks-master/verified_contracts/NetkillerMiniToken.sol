pragma solidity ^0.4.24;

/******************************************/
/*       Netkiller Mini TOKEN             */
/******************************************/
/* Author netkiller <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="dab4bfaeb1b3b6b6bfa89ab7a9b4f4b9b5b7">[email protected]</a>&gt;   */&#13;
/* Home http://www.netkiller.cn           */&#13;
/* Version 2018-05-31 Fixed transfer bool */&#13;
/******************************************/&#13;
&#13;
contract NetkillerMiniToken {&#13;
    address public owner;&#13;
    // Public variables of the token&#13;
    string public name;&#13;
    string public symbol;&#13;
    uint public decimals;&#13;
    // 18 decimals is the strongly suggested default, avoid changing it&#13;
    uint256 public totalSupply;&#13;
&#13;
    // This creates an array with all balances&#13;
    mapping (address =&gt; uint256) public balanceOf;&#13;
    mapping (address =&gt; mapping (address =&gt; uint256)) public allowance;&#13;
&#13;
    // This generates a public event on the blockchain that will notify clients&#13;
    event Transfer(address indexed from, address indexed to, uint256 value);&#13;
    event Approval(address indexed owner, address indexed spender, uint256 value);&#13;
&#13;
    /**&#13;
     * Constrctor function&#13;
     *&#13;
     * Initializes contract with initial supply tokens to the creator of the contract&#13;
     */&#13;
    constructor(&#13;
        uint256 initialSupply,&#13;
        string tokenName,&#13;
        string tokenSymbol,&#13;
        uint decimalUnits&#13;
    ) public {&#13;
        owner = msg.sender;&#13;
        name = tokenName;                                   // Set the name for display purposes&#13;
        symbol = tokenSymbol; &#13;
        decimals = decimalUnits;&#13;
        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount&#13;
        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial token&#13;
    }&#13;
&#13;
    modifier onlyOwner {&#13;
        require(msg.sender == owner);&#13;
        _;&#13;
    }&#13;
&#13;
    function transferOwnership(address newOwner) onlyOwner public {&#13;
        if (newOwner != address(0)) {&#13;
            owner = newOwner;&#13;
        }&#13;
    }&#13;
 &#13;
    /* Internal transfer, only can be called by this contract */&#13;
    function _transfer(address _from, address _to, uint _value) internal {&#13;
        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead&#13;
        require (balanceOf[_from] &gt;= _value);               // Check if the sender has enough&#13;
        require (balanceOf[_to] + _value &gt; balanceOf[_to]); // Check for overflows&#13;
        balanceOf[_from] -= _value;                         // Subtract from the sender&#13;
        balanceOf[_to] += _value;                           // Add the same to the recipient&#13;
        emit Transfer(_from, _to, _value);&#13;
    }&#13;
&#13;
    /**&#13;
     * Transfer tokens&#13;
     *&#13;
     * Send `_value` tokens to `_to` from your account&#13;
     *&#13;
     * @param _to The address of the recipient&#13;
     * @param _value the amount to send&#13;
     */&#13;
    function transfer(address _to, uint256 _value) public returns (bool success){&#13;
        _transfer(msg.sender, _to, _value);&#13;
        return true;&#13;
    }&#13;
&#13;
    /**&#13;
     * Transfer tokens from other address&#13;
     *&#13;
     * Send `_value` tokens to `_to` in behalf of `_from`&#13;
     *&#13;
     * @param _from The address of the sender&#13;
     * @param _to The address of the recipient&#13;
     * @param _value the amount to send&#13;
     */&#13;
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {&#13;
        require(_value &lt;= allowance[_from][msg.sender]);     // Check allowance&#13;
        allowance[_from][msg.sender] -= _value;&#13;
        _transfer(_from, _to, _value);&#13;
        return true;&#13;
    }&#13;
&#13;
    /**&#13;
     * Set allowance for other address&#13;
     *&#13;
     * Allows `_spender` to spend no more than `_value` tokens in your behalf&#13;
     *&#13;
     * @param _spender The address authorized to spend&#13;
     * @param _value the max amount they can spend&#13;
     */&#13;
    function approve(address _spender, uint256 _value) public returns (bool success) {&#13;
        allowance[msg.sender][_spender] = _value;&#13;
        emit Approval(msg.sender, _spender, _value);&#13;
        return true;&#13;
    }&#13;
}