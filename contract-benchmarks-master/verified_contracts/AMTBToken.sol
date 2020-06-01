pragma solidity ^0.4.16;

/*
 * Copyright © 2018 by Capital Trust Group Limited
 * Author : <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="107c7577717c5073647775687378717e77753e737f7d">[email protected]</a>&#13;
*/&#13;
&#13;
contract Token {&#13;
&#13;
    /// @return total amount of tokens&#13;
    function totalSupply() constant returns (uint256 supply) {}&#13;
&#13;
    /// @param _owner The address from which the balance will be retrieved&#13;
    /// @return The balance&#13;
    function balanceOf(address _owner) constant returns (uint256 balance) {}&#13;
&#13;
    /// @notice send `_value` token to `_to` from `msg.sender`&#13;
    /// @param _to The address of the recipient&#13;
    /// @param _value The amount of token to be transferred&#13;
    /// @return Whether the transfer was successful or not&#13;
    function transfer(address _to, uint256 _value) returns (bool success) {}&#13;
&#13;
    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`&#13;
    /// @param _from The address of the sender&#13;
    /// @param _to The address of the recipient&#13;
    /// @param _value The amount of token to be transferred&#13;
    /// @return Whether the transfer was successful or not&#13;
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}&#13;
&#13;
    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens&#13;
    /// @param _spender The address of the account able to transfer the tokens&#13;
    /// @param _value The amount of wei to be approved for transfer&#13;
    /// @return Whether the approval was successful or not&#13;
    function approve(address _spender, uint256 _value) returns (bool success) {}&#13;
&#13;
    /// @param _owner The address of the account owning tokens&#13;
    /// @param _spender The address of the account able to transfer the tokens&#13;
    /// @return Amount of remaining tokens allowed to spent&#13;
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}&#13;
&#13;
    event Transfer(address indexed _from, address indexed _to, uint256 _value);&#13;
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);&#13;
    &#13;
}&#13;
&#13;
&#13;
contract StandardToken is Token {&#13;
&#13;
    function transfer(address _to, uint256 _value) returns (bool success) {&#13;
        if (balances[msg.sender] &gt;= _value &amp;&amp; _value &gt; 0) {&#13;
            balances[msg.sender] -= _value;&#13;
            balances[_to] += _value;&#13;
            Transfer(msg.sender, _to, _value);&#13;
            return true;&#13;
        } else { return false; }&#13;
    }&#13;
&#13;
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {&#13;
        if (balances[_from] &gt;= _value &amp;&amp; allowed[_from][msg.sender] &gt;= _value &amp;&amp; _value &gt; 0) {&#13;
            balances[_to] += _value;&#13;
            balances[_from] -= _value;&#13;
            allowed[_from][msg.sender] -= _value;&#13;
            Transfer(_from, _to, _value);&#13;
            return true;&#13;
        } else { return false; }&#13;
    }&#13;
&#13;
    function balanceOf(address _owner) constant returns (uint256 balance) {&#13;
        return balances[_owner];&#13;
    }&#13;
&#13;
    function approve(address _spender, uint256 _value) returns (bool success) {&#13;
        allowed[msg.sender][_spender] = _value;&#13;
        Approval(msg.sender, _spender, _value);&#13;
        return true;&#13;
    }&#13;
&#13;
    function allowance(address _owner, address _spender) constant returns (uint256 remaining) {&#13;
      return allowed[_owner][_spender];&#13;
    }&#13;
&#13;
    mapping (address =&gt; uint256) balances;&#13;
    mapping (address =&gt; mapping (address =&gt; uint256)) allowed;&#13;
    uint256 public totalSupply;&#13;
}&#13;
&#13;
&#13;
contract AMTBToken is StandardToken {&#13;
&#13;
    function () {&#13;
        //if ether is sent to this address, send it back.&#13;
        throw;&#13;
    }&#13;
&#13;
    /* Public variables of the token */&#13;
    &#13;
    string public name;                   &#13;
    uint8 public decimals;                &#13;
    string public symbol;                 &#13;
    string public version = 'H1.0';  &#13;
&#13;
&#13;
    function AMTBToken(&#13;
        ) {&#13;
        balances[msg.sender] = 22000000000 * 1000000000000000000;   // Give the creator all initial tokens, 18 zero is 18 Decimals&#13;
        totalSupply = 22000000000 * 1000000000000000000;            // Update total supply, , 18 zero is 18 Decimals&#13;
        name = "America Technology Bond";                                // Token Name&#13;
        decimals = 18;                                      // Amount of decimals for display purposes&#13;
        symbol = "AMTB";                                    // Token Symbol&#13;
    }&#13;
&#13;
    /* Approves and then calls the receiving contract */&#13;
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {&#13;
        allowed[msg.sender][_spender] = _value;&#13;
        Approval(msg.sender, _spender, _value);&#13;
&#13;
        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }&#13;
        return true;&#13;
    }&#13;
}