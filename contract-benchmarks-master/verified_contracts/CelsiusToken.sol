pragma solidity ^0.4.16;

/*
 * Abstract Token Smart Contract.  Copyright © 2017 by ABDK Consulting.
 * Author: Mikhail Vladimirov <<span class="__cf_email__" data-cfemail="5e333735363f37327028323f3a3733372c31281e39333f3732703d3133">[email protected]</span>&gt;&#13;
 */&#13;
pragma solidity ^0.4.20;&#13;
&#13;
/*&#13;
 * EIP-20 Standard Token Smart Contract Interface.&#13;
 * Copyright © 2016–2018 by ABDK Consulting.&#13;
 * Author: Mikhail Vladimirov &lt;<span class="__cf_email__" data-cfemail="b8d5d1d3d0d9d1d496ced4d9dcd1d5d1cad7cef8dfd5d9d1d496dbd7d5">[email protected]</span>&gt;&#13;
 */&#13;
pragma solidity ^0.4.20;&#13;
&#13;
/**&#13;
 * ERC-20 standard token interface, as defined&#13;
 * &lt;a href="https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md"&gt;here&lt;/a&gt;.&#13;
 */&#13;
contract Token {&#13;
  /**&#13;
   * Get total number of tokens in circulation.&#13;
   *&#13;
   * @return total number of tokens in circulation&#13;
   */&#13;
  function totalSupply () public view returns (uint256 supply);&#13;
&#13;
  /**&#13;
   * Get number of tokens currently belonging to given owner.&#13;
   *&#13;
   * @param _owner address to get number of tokens currently belonging to the&#13;
   *        owner of&#13;
   * @return number of tokens currently belonging to the owner of given address&#13;
   */&#13;
  function balanceOf (address _owner) public view returns (uint256 balance);&#13;
&#13;
  /**&#13;
   * Transfer given number of tokens from message sender to given recipient.&#13;
   *&#13;
   * @param _to address to transfer tokens to the owner of&#13;
   * @param _value number of tokens to transfer to the owner of given address&#13;
   * @return true if tokens were transferred successfully, false otherwise&#13;
   */&#13;
  function transfer (address _to, uint256 _value)&#13;
  public returns (bool success);&#13;
&#13;
  /**&#13;
   * Transfer given number of tokens from given owner to given recipient.&#13;
   *&#13;
   * @param _from address to transfer tokens from the owner of&#13;
   * @param _to address to transfer tokens to the owner of&#13;
   * @param _value number of tokens to transfer from given owner to given&#13;
   *        recipient&#13;
   * @return true if tokens were transferred successfully, false otherwise&#13;
   */&#13;
  function transferFrom (address _from, address _to, uint256 _value)&#13;
  public returns (bool success);&#13;
&#13;
  /**&#13;
   * Allow given spender to transfer given number of tokens from message sender.&#13;
   *&#13;
   * @param _spender address to allow the owner of to transfer tokens from&#13;
   *        message sender&#13;
   * @param _value number of tokens to allow to transfer&#13;
   * @return true if token transfer was successfully approved, false otherwise&#13;
   */&#13;
  function approve (address _spender, uint256 _value)&#13;
  public returns (bool success);&#13;
&#13;
  /**&#13;
   * Tell how many tokens given spender is currently allowed to transfer from&#13;
   * given owner.&#13;
   *&#13;
   * @param _owner address to get number of tokens allowed to be transferred&#13;
   *        from the owner of&#13;
   * @param _spender address to get number of tokens allowed to be transferred&#13;
   *        by the owner of&#13;
   * @return number of tokens given spender is currently allowed to transfer&#13;
   *         from given owner&#13;
   */&#13;
  function allowance (address _owner, address _spender)&#13;
  public view returns (uint256 remaining);&#13;
&#13;
  /**&#13;
   * Logged when tokens were transferred from one owner to another.&#13;
   *&#13;
   * @param _from address of the owner, tokens were transferred from&#13;
   * @param _to address of the owner, tokens were transferred to&#13;
   * @param _value number of tokens transferred&#13;
   */&#13;
  event Transfer (address indexed _from, address indexed _to, uint256 _value);&#13;
&#13;
  /**&#13;
   * Logged when owner approved his tokens to be transferred by some spender.&#13;
   *&#13;
   * @param _owner owner who approved his tokens to be transferred&#13;
   * @param _spender spender who were allowed to transfer the tokens belonging&#13;
   *        to the owner&#13;
   * @param _value number of tokens belonging to the owner, approved to be&#13;
   *        transferred by the spender&#13;
   */&#13;
  event Approval (&#13;
    address indexed _owner, address indexed _spender, uint256 _value);&#13;
}&#13;
/*&#13;
 * Safe Math Smart Contract.  Copyright © 2016–2017 by ABDK Consulting.&#13;
 * Author: Mikhail Vladimirov &lt;<span class="__cf_email__" data-cfemail="c7aaaeacafa6aeabe9b1aba6a3aeaaaeb5a8b187a0aaa6aeabe9a4a8aa">[email protected]</span>&gt;&#13;
 */&#13;
pragma solidity ^0.4.20;&#13;
&#13;
/**&#13;
 * Provides methods to safely add, subtract and multiply uint256 numbers.&#13;
 */&#13;
contract SafeMath {&#13;
  uint256 constant private MAX_UINT256 =&#13;
    0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;&#13;
&#13;
  /**&#13;
   * Add two uint256 values, throw in case of overflow.&#13;
   *&#13;
   * @param x first value to add&#13;
   * @param y second value to add&#13;
   * @return x + y&#13;
   */&#13;
  function safeAdd (uint256 x, uint256 y)&#13;
  pure internal&#13;
  returns (uint256 z) {&#13;
    assert (x &lt;= MAX_UINT256 - y);&#13;
    return x + y;&#13;
  }&#13;
&#13;
  /**&#13;
   * Subtract one uint256 value from another, throw in case of underflow.&#13;
   *&#13;
   * @param x value to subtract from&#13;
   * @param y value to subtract&#13;
   * @return x - y&#13;
   */&#13;
  function safeSub (uint256 x, uint256 y)&#13;
  pure internal&#13;
  returns (uint256 z) {&#13;
    assert (x &gt;= y);&#13;
    return x - y;&#13;
  }&#13;
&#13;
  /**&#13;
   * Multiply two uint256 values, throw in case of overflow.&#13;
   *&#13;
   * @param x first value to multiply&#13;
   * @param y second value to multiply&#13;
   * @return x * y&#13;
   */&#13;
  function safeMul (uint256 x, uint256 y)&#13;
  pure internal&#13;
  returns (uint256 z) {&#13;
    if (y == 0) return 0; // Prevent division by zero at the next line&#13;
    assert (x &lt;= MAX_UINT256 / y);&#13;
    return x * y;&#13;
  }&#13;
}&#13;
&#13;
&#13;
/**&#13;
 * Abstract Token Smart Contract that could be used as a base contract for&#13;
 * ERC-20 token contracts.&#13;
 */&#13;
contract AbstractToken is Token, SafeMath {&#13;
  /**&#13;
   * Create new Abstract Token contract.&#13;
   */&#13;
  function AbstractToken () public {&#13;
    // Do nothing&#13;
  }&#13;
&#13;
  /**&#13;
   * Get number of tokens currently belonging to given owner.&#13;
   *&#13;
   * @param _owner address to get number of tokens currently belonging to the&#13;
   *        owner of&#13;
   * @return number of tokens currently belonging to the owner of given address&#13;
   */&#13;
  function balanceOf (address _owner) public view returns (uint256 balance) {&#13;
    return accounts [_owner];&#13;
  }&#13;
&#13;
  /**&#13;
   * Transfer given number of tokens from message sender to given recipient.&#13;
   *&#13;
   * @param _to address to transfer tokens to the owner of&#13;
   * @param _value number of tokens to transfer to the owner of given address&#13;
   * @return true if tokens were transferred successfully, false otherwise&#13;
   */&#13;
  function transfer (address _to, uint256 _value)&#13;
  public returns (bool success) {&#13;
    uint256 fromBalance = accounts [msg.sender];&#13;
    if (fromBalance &lt; _value) return false;&#13;
    if (_value &gt; 0 &amp;&amp; msg.sender != _to) {&#13;
      accounts [msg.sender] = safeSub (fromBalance, _value);&#13;
      accounts [_to] = safeAdd (accounts [_to], _value);&#13;
    }&#13;
    Transfer (msg.sender, _to, _value);&#13;
    return true;&#13;
  }&#13;
&#13;
  /**&#13;
   * Transfer given number of tokens from given owner to given recipient.&#13;
   *&#13;
   * @param _from address to transfer tokens from the owner of&#13;
   * @param _to address to transfer tokens to the owner of&#13;
   * @param _value number of tokens to transfer from given owner to given&#13;
   *        recipient&#13;
   * @return true if tokens were transferred successfully, false otherwise&#13;
   */&#13;
  function transferFrom (address _from, address _to, uint256 _value)&#13;
  public returns (bool success) {&#13;
    uint256 spenderAllowance = allowances [_from][msg.sender];&#13;
    if (spenderAllowance &lt; _value) return false;&#13;
    uint256 fromBalance = accounts [_from];&#13;
    if (fromBalance &lt; _value) return false;&#13;
&#13;
    allowances [_from][msg.sender] =&#13;
      safeSub (spenderAllowance, _value);&#13;
&#13;
    if (_value &gt; 0 &amp;&amp; _from != _to) {&#13;
      accounts [_from] = safeSub (fromBalance, _value);&#13;
      accounts [_to] = safeAdd (accounts [_to], _value);&#13;
    }&#13;
    Transfer (_from, _to, _value);&#13;
    return true;&#13;
  }&#13;
&#13;
  /**&#13;
   * Allow given spender to transfer given number of tokens from message sender.&#13;
   *&#13;
   * @param _spender address to allow the owner of to transfer tokens from&#13;
   *        message sender&#13;
   * @param _value number of tokens to allow to transfer&#13;
   * @return true if token transfer was successfully approved, false otherwise&#13;
   */&#13;
  function approve (address _spender, uint256 _value)&#13;
  public returns (bool success) {&#13;
    allowances [msg.sender][_spender] = _value;&#13;
    Approval (msg.sender, _spender, _value);&#13;
&#13;
    return true;&#13;
  }&#13;
&#13;
  /**&#13;
   * Tell how many tokens given spender is currently allowed to transfer from&#13;
   * given owner.&#13;
   *&#13;
   * @param _owner address to get number of tokens allowed to be transferred&#13;
   *        from the owner of&#13;
   * @param _spender address to get number of tokens allowed to be transferred&#13;
   *        by the owner of&#13;
   * @return number of tokens given spender is currently allowed to transfer&#13;
   *         from given owner&#13;
   */&#13;
  function allowance (address _owner, address _spender)&#13;
  public view returns (uint256 remaining) {&#13;
    return allowances [_owner][_spender];&#13;
  }&#13;
&#13;
  /**&#13;
   * Mapping from addresses of token holders to the numbers of tokens belonging&#13;
   * to these token holders.&#13;
   */&#13;
  mapping (address =&gt; uint256) internal accounts;&#13;
&#13;
  /**&#13;
   * Mapping from addresses of token holders to the mapping of addresses of&#13;
   * spenders to the allowances set by these token holders to these spenders.&#13;
   */&#13;
  mapping (address =&gt; mapping (address =&gt; uint256)) internal allowances;&#13;
}&#13;
&#13;
&#13;
/**&#13;
 * Celsius Network token smart contract.&#13;
 */&#13;
contract CelsiusToken is AbstractToken {&#13;
  /**&#13;
   * Address of the owner of this smart contract.&#13;
   */&#13;
  address private owner;&#13;
&#13;
  /**&#13;
   * Total number of tokens in circulation.&#13;
   */&#13;
  uint256 tokenCount;&#13;
&#13;
  /**&#13;
   * True if tokens transfers are currently frozen, false otherwise.&#13;
   */&#13;
  bool frozen = false;&#13;
&#13;
  /**&#13;
   * Create new Celsius Network token smart contract, with given number of tokens issued&#13;
   * and given to msg.sender, and make msg.sender the owner of this smart&#13;
   * contract.&#13;
   *&#13;
   * @param _tokenCount number of tokens to issue and give to msg.sender&#13;
   */&#13;
  function CelsiusToken (uint256 _tokenCount) public {&#13;
    owner = msg.sender;&#13;
    tokenCount = _tokenCount;&#13;
    accounts [msg.sender] = _tokenCount;&#13;
  }&#13;
&#13;
  /**&#13;
   * Get total number of tokens in circulation.&#13;
   *&#13;
   * @return total number of tokens in circulation&#13;
   */&#13;
  function totalSupply () public view returns (uint256 supply) {&#13;
    return tokenCount;&#13;
  }&#13;
&#13;
  /**&#13;
   * Get name of this token.&#13;
   *&#13;
   * @return name of this token&#13;
   */&#13;
  function name () public pure returns (string result) {&#13;
    return "Celsius";&#13;
  }&#13;
&#13;
  /**&#13;
   * Get symbol of this token.&#13;
   *&#13;
   * @return symbol of this token&#13;
   */&#13;
  function symbol () public pure returns (string result) {&#13;
    return "CEL";&#13;
  }&#13;
&#13;
  /**&#13;
   * Get number of decimals for this token.&#13;
   *&#13;
   * @return number of decimals for this token&#13;
   */&#13;
  function decimals () public pure returns (uint8 result) {&#13;
    return 4;&#13;
  }&#13;
&#13;
  /**&#13;
   * Transfer given number of tokens from message sender to given recipient.&#13;
   *&#13;
   * @param _to address to transfer tokens to the owner of&#13;
   * @param _value number of tokens to transfer to the owner of given address&#13;
   * @return true if tokens were transferred successfully, false otherwise&#13;
   */&#13;
  function transfer (address _to, uint256 _value)&#13;
    public returns (bool success) {&#13;
    if (frozen) return false;&#13;
    else return AbstractToken.transfer (_to, _value);&#13;
  }&#13;
&#13;
  /**&#13;
   * Transfer given number of tokens from given owner to given recipient.&#13;
   *&#13;
   * @param _from address to transfer tokens from the owner of&#13;
   * @param _to address to transfer tokens to the owner of&#13;
   * @param _value number of tokens to transfer from given owner to given&#13;
   *        recipient&#13;
   * @return true if tokens were transferred successfully, false otherwise&#13;
   */&#13;
  function transferFrom (address _from, address _to, uint256 _value)&#13;
    public returns (bool success) {&#13;
    if (frozen) return false;&#13;
    else return AbstractToken.transferFrom (_from, _to, _value);&#13;
  }&#13;
&#13;
  /**&#13;
   * Change how many tokens given spender is allowed to transfer from message&#13;
   * spender.  In order to prevent double spending of allowance, this method&#13;
   * receives assumed current allowance value as an argument.  If actual&#13;
   * allowance differs from an assumed one, this method just returns false.&#13;
   *&#13;
   * @param _spender address to allow the owner of to transfer tokens from&#13;
   *        message sender&#13;
   * @param _currentValue assumed number of tokens currently allowed to be&#13;
   *        transferred&#13;
   * @param _newValue number of tokens to allow to transfer&#13;
   * @return true if token transfer was successfully approved, false otherwise&#13;
   */&#13;
  function approve (address _spender, uint256 _currentValue, uint256 _newValue)&#13;
    public returns (bool success) {&#13;
    if (allowance (msg.sender, _spender) == _currentValue)&#13;
      return approve (_spender, _newValue);&#13;
    else return false;&#13;
  }&#13;
&#13;
  /**&#13;
   * Burn given number of tokens belonging to message sender.&#13;
   *&#13;
   * @param _value number of tokens to burn&#13;
   * @return true on success, false on error&#13;
   */&#13;
  function burnTokens (uint256 _value) public returns (bool success) {&#13;
    if (_value &gt; accounts [msg.sender]) return false;&#13;
    else if (_value &gt; 0) {&#13;
      accounts [msg.sender] = safeSub (accounts [msg.sender], _value);&#13;
      tokenCount = safeSub (tokenCount, _value);&#13;
&#13;
      Transfer (msg.sender, address (0), _value);&#13;
      return true;&#13;
    } else return true;&#13;
  }&#13;
&#13;
  /**&#13;
   * Set new owner for the smart contract.&#13;
   * May only be called by smart contract owner.&#13;
   *&#13;
   * @param _newOwner address of new owner of the smart contract&#13;
   */&#13;
  function setOwner (address _newOwner) public {&#13;
    require (msg.sender == owner);&#13;
&#13;
    owner = _newOwner;&#13;
  }&#13;
&#13;
  /**&#13;
   * Freeze token transfers.&#13;
   * May only be called by smart contract owner.&#13;
   */&#13;
  function freezeTransfers () public {&#13;
    require (msg.sender == owner);&#13;
&#13;
    if (!frozen) {&#13;
      frozen = true;&#13;
      Freeze ();&#13;
    }&#13;
  }&#13;
&#13;
  /**&#13;
   * Unfreeze token transfers.&#13;
   * May only be called by smart contract owner.&#13;
   */&#13;
  function unfreezeTransfers () public {&#13;
    require (msg.sender == owner);&#13;
&#13;
    if (frozen) {&#13;
      frozen = false;&#13;
      Unfreeze ();&#13;
    }&#13;
  }&#13;
&#13;
  /**&#13;
   * Logged when token transfers were frozen.&#13;
   */&#13;
  event Freeze ();&#13;
&#13;
  /**&#13;
   * Logged when token transfers were unfrozen.&#13;
   */&#13;
  event Unfreeze ();&#13;
}