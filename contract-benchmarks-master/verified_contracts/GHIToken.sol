/*
 * Abstract Token Smart Contract.  Copyright © 2017 by ABDK Consulting.
 * Author: Mikhail Vladimirov <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="7815111310191114560e14191c1115110a170e381f15191114561b1715">[email protected]</a>&gt;&#13;
 */&#13;
pragma solidity ^0.4.20;&#13;
&#13;
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
  public payable returns (bool success);&#13;
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
  public payable returns (bool success);&#13;
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
  public payable returns (bool success);&#13;
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
  public payable returns (bool success) {&#13;
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
  public payable returns (bool success) {&#13;
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
  public payable returns (bool success) {&#13;
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
/*&#13;
 * Safe Math Smart Contract.  Copyright © 2016–2017 by ABDK Consulting.&#13;
 * Author: Mikhail Vladimirov &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="dbb6b2b0b3bab2b7f5adb7babfb2b6b2a9b4ad9bbcb6bab2b7f5b8b4b6">[email protected]</a>&gt;&#13;
 */&#13;
&#13;
/**&#13;
 * Provides methods to safely add, subtract and multiply uint256 numbers.&#13;
 */&#13;
/*&#13;
 * GHI Token Smart Contract.  Copyright © 2018 by ABDK Consulting.&#13;
 * Author: Mikhail Vladimirov &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="91fcf8faf9f0f8fdbfe7fdf0f5f8fcf8e3fee7d1f6fcf0f8fdbff2fefc">[email protected]</a>&gt;&#13;
 */&#13;
&#13;
/**&#13;
 * GHI Token Smart Contract: EIP-20 compatible token smart contract that manages&#13;
 * GHI tokens.&#13;
 */&#13;
contract GHIToken is AbstractToken {&#13;
  /**&#13;
   * Fee denominator (0.001%).&#13;
   */&#13;
  uint256 constant internal FEE_DENOMINATOR = 100000;&#13;
&#13;
  /**&#13;
   * Maximum fee numerator (100%).&#13;
   */&#13;
  uint256 constant internal MAX_FEE_NUMERATOR = FEE_DENOMINATOR;&#13;
&#13;
  /**&#13;
   * Minimum fee numerator (0%).&#13;
   */&#13;
  uint256 constant internal MIN_FEE_NUMERATIOR = 0;&#13;
&#13;
  /**&#13;
   * Maximum allowed number of tokens in circulation.&#13;
   */&#13;
  uint256 constant internal MAX_TOKENS_COUNT =&#13;
    0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff /&#13;
    MAX_FEE_NUMERATOR;&#13;
&#13;
  /**&#13;
   * Default transfer fee.&#13;
   */&#13;
  uint256 constant internal DEFAULT_FEE = 5e2;&#13;
&#13;
  /**&#13;
   * Address flag that marks black listed addresses.&#13;
   */&#13;
  uint256 constant internal BLACK_LIST_FLAG = 0x01;&#13;
&#13;
  /**&#13;
   * Address flag that marks zero fee addresses.&#13;
   */&#13;
  uint256 constant internal ZERO_FEE_FLAG = 0x02;&#13;
&#13;
  modifier delegatable {&#13;
    if (delegate == address (0)) {&#13;
      require (msg.value == 0); // Non payable if not delegated&#13;
      _;&#13;
    } else {&#13;
      assembly {&#13;
        // Save owner&#13;
        let oldOwner := sload (owner_slot)&#13;
&#13;
        // Save delegate&#13;
        let oldDelegate := sload (delegate_slot)&#13;
&#13;
        // Solidity stores address of the beginning of free memory at 0x40&#13;
        let buffer := mload (0x40)&#13;
&#13;
        // Copy message call data into buffer&#13;
        calldatacopy (buffer, 0, calldatasize)&#13;
&#13;
        // Lets call our delegate&#13;
        let result := delegatecall (gas, oldDelegate, buffer, calldatasize, buffer, 0)&#13;
&#13;
        // Check, whether owner was changed&#13;
        switch eq (oldOwner, sload (owner_slot))&#13;
        case 1 {} // Owner was not changed, fine&#13;
        default {revert (0, 0) } // Owner was changed, revert!&#13;
&#13;
        // Check, whether delegate was changed&#13;
        switch eq (oldDelegate, sload (delegate_slot))&#13;
        case 1 {} // Delegate was not changed, fine&#13;
        default {revert (0, 0) } // Delegate was changed, revert!&#13;
&#13;
        // Copy returned value into buffer&#13;
        returndatacopy (buffer, 0, returndatasize)&#13;
&#13;
        // Check call status&#13;
        switch result&#13;
        case 0 { revert (buffer, returndatasize) } // Call failed, revert!&#13;
        default { return (buffer, returndatasize) } // Call succeeded, return&#13;
      }&#13;
    }&#13;
  }&#13;
&#13;
  /**&#13;
   * Create GHI Token smart contract with message sender as an owner.&#13;
   *&#13;
   * @param _feeCollector address fees are sent to&#13;
   */&#13;
  function GHIToken (address _feeCollector) public {&#13;
    fixedFee = DEFAULT_FEE;&#13;
    minVariableFee = 0;&#13;
    maxVariableFee = 0;&#13;
    variableFeeNumerator = 0;&#13;
&#13;
    owner = msg.sender;&#13;
    feeCollector = _feeCollector;&#13;
  }&#13;
&#13;
  /**&#13;
   * Delegate unrecognized functions.&#13;
   */&#13;
  function () public delegatable payable {&#13;
    revert (); // Revert if not delegated&#13;
  }&#13;
&#13;
  /**&#13;
   * Get name of the token.&#13;
   *&#13;
   * @return name of the token&#13;
   */&#13;
  function name () public delegatable view returns (string) {&#13;
    return "GHI Token";&#13;
  }&#13;
&#13;
  /**&#13;
   * Get symbol of the token.&#13;
   *&#13;
   * @return symbol of the token&#13;
   */&#13;
  function symbol () public delegatable view returns (string) {&#13;
    return "GHI";&#13;
  }&#13;
&#13;
  /**&#13;
   * Get number of decimals for the token.&#13;
   *&#13;
   * @return number of decimals for the token&#13;
   */&#13;
  function decimals () public delegatable view returns (uint8) {&#13;
    return 2;&#13;
  }&#13;
&#13;
  /**&#13;
   * Get total number of tokens in circulation.&#13;
   *&#13;
   * @return total number of tokens in circulation&#13;
   */&#13;
  function totalSupply () public delegatable view returns (uint256) {&#13;
    return tokensCount;&#13;
  }&#13;
&#13;
  /**&#13;
   * Get number of tokens currently belonging to given owner.&#13;
   *&#13;
   * @param _owner address to get number of tokens currently belonging to the&#13;
   *        owner of&#13;
   * @return number of tokens currently belonging to the owner of given address&#13;
   */&#13;
  function balanceOf (address _owner)&#13;
    public delegatable view returns (uint256 balance) {&#13;
    return AbstractToken.balanceOf (_owner);&#13;
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
  public delegatable payable returns (bool) {&#13;
    if (frozen) return false;&#13;
    else if (&#13;
      (addressFlags [msg.sender] | addressFlags [_to]) &amp; BLACK_LIST_FLAG ==&#13;
      BLACK_LIST_FLAG)&#13;
      return false;&#13;
    else {&#13;
      uint256 fee =&#13;
        (addressFlags [msg.sender] | addressFlags [_to]) &amp; ZERO_FEE_FLAG == ZERO_FEE_FLAG ?&#13;
          0 :&#13;
          calculateFee (_value);&#13;
&#13;
      if (_value &lt;= accounts [msg.sender] &amp;&amp;&#13;
          fee &lt;= safeSub (accounts [msg.sender], _value)) {&#13;
        require (AbstractToken.transfer (_to, _value));&#13;
        require (AbstractToken.transfer (feeCollector, fee));&#13;
        return true;&#13;
      } else return false;&#13;
    }&#13;
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
  public delegatable payable returns (bool) {&#13;
    if (frozen) return false;&#13;
    else if (&#13;
      (addressFlags [_from] | addressFlags [_to]) &amp; BLACK_LIST_FLAG ==&#13;
      BLACK_LIST_FLAG)&#13;
      return false;&#13;
    else {&#13;
      uint256 fee =&#13;
        (addressFlags [_from] | addressFlags [_to]) &amp; ZERO_FEE_FLAG == ZERO_FEE_FLAG ?&#13;
          0 :&#13;
          calculateFee (_value);&#13;
&#13;
      if (_value &lt;= allowances [_from][msg.sender] &amp;&amp;&#13;
          fee &lt;= safeSub (allowances [_from][msg.sender], _value) &amp;&amp;&#13;
          _value &lt;= accounts [_from] &amp;&amp;&#13;
          fee &lt;= safeSub (accounts [_from], _value)) {&#13;
        require (AbstractToken.transferFrom (_from, _to, _value));&#13;
        require (AbstractToken.transferFrom (_from, feeCollector, fee));&#13;
        return true;&#13;
      } else return false;&#13;
    }&#13;
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
  public delegatable payable returns (bool success) {&#13;
    return AbstractToken.approve (_spender, _value);&#13;
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
  public delegatable view returns (uint256 remaining) {&#13;
    return AbstractToken.allowance (_owner, _spender);&#13;
  }&#13;
&#13;
  /**&#13;
   * Transfer given number of token from the signed defined by digital signature&#13;
   * to given recipient.&#13;
   *&#13;
   * @param _to address to transfer token to the owner of&#13;
   * @param _value number of tokens to transfer&#13;
   * @param _fee number of tokens to give to message sender&#13;
   * @param _nonce nonce of the transfer&#13;
   * @param _v parameter V of digital signature&#13;
   * @param _r parameter R of digital signature&#13;
   * @param _s parameter S of digital signature&#13;
   */&#13;
  function delegatedTransfer (&#13;
    address _to, uint256 _value, uint256 _fee,&#13;
    uint256 _nonce, uint8 _v, bytes32 _r, bytes32 _s)&#13;
  public delegatable payable returns (bool) {&#13;
    if (frozen) return false;&#13;
    else {&#13;
      address _from = ecrecover (&#13;
        keccak256 (&#13;
          thisAddress (), messageSenderAddress (), _to, _value, _fee, _nonce),&#13;
        _v, _r, _s);&#13;
&#13;
      if (_nonce != nonces [_from]) return false;&#13;
&#13;
      if (&#13;
        (addressFlags [_from] | addressFlags [_to]) &amp; BLACK_LIST_FLAG ==&#13;
        BLACK_LIST_FLAG)&#13;
        return false;&#13;
&#13;
      uint256 fee =&#13;
        (addressFlags [_from] | addressFlags [_to]) &amp; ZERO_FEE_FLAG == ZERO_FEE_FLAG ?&#13;
          0 :&#13;
          calculateFee (_value);&#13;
&#13;
      uint256 balance = accounts [_from];&#13;
      if (_value &gt; balance) return false;&#13;
      balance = safeSub (balance, _value);&#13;
      if (fee &gt; balance) return false;&#13;
      balance = safeSub (balance, fee);&#13;
      if (_fee &gt; balance) return false;&#13;
      balance = safeSub (balance, _fee);&#13;
&#13;
      nonces [_from] = _nonce + 1;&#13;
&#13;
      accounts [_from] = balance;&#13;
      accounts [_to] = safeAdd (accounts [_to], _value);&#13;
      accounts [feeCollector] = safeAdd (accounts [feeCollector], fee);&#13;
      accounts [msg.sender] = safeAdd (accounts [msg.sender], _fee);&#13;
&#13;
      Transfer (_from, _to, _value);&#13;
      Transfer (_from, feeCollector, fee);&#13;
      Transfer (_from, msg.sender, _fee);&#13;
&#13;
      return true;&#13;
    }&#13;
  }&#13;
&#13;
  /**&#13;
   * Create tokens.&#13;
   *&#13;
   * @param _value number of tokens to be created.&#13;
   */&#13;
  function createTokens (uint256 _value)&#13;
  public delegatable payable returns (bool) {&#13;
    require (msg.sender == owner);&#13;
&#13;
    if (_value &gt; 0) {&#13;
      if (_value &lt;= safeSub (MAX_TOKENS_COUNT, tokensCount)) {&#13;
        accounts [msg.sender] = safeAdd (accounts [msg.sender], _value);&#13;
        tokensCount = safeAdd (tokensCount, _value);&#13;
&#13;
        Transfer (address (0), msg.sender, _value);&#13;
&#13;
        return true;&#13;
      } else return false;&#13;
    } else return true;&#13;
  }&#13;
&#13;
  /**&#13;
   * Burn tokens.&#13;
   *&#13;
   * @param _value number of tokens to burn&#13;
   */&#13;
  function burnTokens (uint256 _value)&#13;
  public delegatable payable returns (bool) {&#13;
    require (msg.sender == owner);&#13;
&#13;
    if (_value &gt; 0) {&#13;
      if (_value &lt;= accounts [msg.sender]) {&#13;
        accounts [msg.sender] = safeSub (accounts [msg.sender], _value);&#13;
        tokensCount = safeSub (tokensCount, _value);&#13;
&#13;
        Transfer (msg.sender, address (0), _value);&#13;
&#13;
        return true;&#13;
      } else return false;&#13;
    } else return true;&#13;
  }&#13;
&#13;
  /**&#13;
   * Freeze token transfers.&#13;
   */&#13;
  function freezeTransfers () public delegatable payable {&#13;
    require (msg.sender == owner);&#13;
&#13;
    if (!frozen) {&#13;
      frozen = true;&#13;
&#13;
      Freeze ();&#13;
    }&#13;
  }&#13;
&#13;
  /**&#13;
   * Unfreeze token transfers.&#13;
   */&#13;
  function unfreezeTransfers () public delegatable payable {&#13;
    require (msg.sender == owner);&#13;
&#13;
    if (frozen) {&#13;
      frozen = false;&#13;
&#13;
      Unfreeze ();&#13;
    }&#13;
  }&#13;
&#13;
  /**&#13;
   * Set smart contract owner.&#13;
   *&#13;
   * @param _newOwner address of the new owner&#13;
   */&#13;
  function setOwner (address _newOwner) public {&#13;
    require (msg.sender == owner);&#13;
&#13;
    owner = _newOwner;&#13;
  }&#13;
&#13;
  /**&#13;
   * Set fee collector.&#13;
   *&#13;
   * @param _newFeeCollector address of the new fee collector&#13;
   */&#13;
  function setFeeCollector (address _newFeeCollector)&#13;
  public delegatable payable {&#13;
    require (msg.sender == owner);&#13;
&#13;
    feeCollector = _newFeeCollector;&#13;
  }&#13;
&#13;
  /**&#13;
   * Get current nonce for token holder with given address, i.e. nonce this&#13;
   * token holder should use for next delegated transfer.&#13;
   *&#13;
   * @param _owner address of the token holder to get nonce for&#13;
   * @return current nonce for token holder with give address&#13;
   */&#13;
  function nonce (address _owner) public view delegatable returns (uint256) {&#13;
    return nonces [_owner];&#13;
  }&#13;
&#13;
  /**&#13;
   * Set fee parameters.&#13;
   *&#13;
   * @param _fixedFee fixed fee in token units&#13;
   * @param _minVariableFee minimum variable fee in token units&#13;
   * @param _maxVariableFee maximum variable fee in token units&#13;
   * @param _variableFeeNumerator variable fee numerator&#13;
   */&#13;
  function setFeeParameters (&#13;
    uint256 _fixedFee,&#13;
    uint256 _minVariableFee,&#13;
    uint256 _maxVariableFee,&#13;
    uint256 _variableFeeNumerator) public delegatable payable {&#13;
    require (msg.sender == owner);&#13;
&#13;
    require (_minVariableFee &lt;= _maxVariableFee);&#13;
    require (_variableFeeNumerator &lt;= MAX_FEE_NUMERATOR);&#13;
&#13;
    fixedFee = _fixedFee;&#13;
    minVariableFee = _minVariableFee;&#13;
    maxVariableFee = _maxVariableFee;&#13;
    variableFeeNumerator = _variableFeeNumerator;&#13;
&#13;
    FeeChange (&#13;
      _fixedFee, _minVariableFee, _maxVariableFee, _variableFeeNumerator);&#13;
  }&#13;
&#13;
  /**&#13;
   * Get fee parameters.&#13;
   *&#13;
   * @return fee parameters&#13;
   */&#13;
  function getFeeParameters () public delegatable view returns (&#13;
    uint256 _fixedFee,&#13;
    uint256 _minVariableFee,&#13;
    uint256 _maxVariableFee,&#13;
    uint256 _variableFeeNumnerator) {&#13;
    _fixedFee = fixedFee;&#13;
    _minVariableFee = minVariableFee;&#13;
    _maxVariableFee = maxVariableFee;&#13;
    _variableFeeNumnerator = variableFeeNumerator;&#13;
  }&#13;
&#13;
  /**&#13;
   * Calculate fee for transfer of given number of tokens.&#13;
   *&#13;
   * @param _amount transfer amount to calculate fee for&#13;
   * @return fee for transfer of given amount&#13;
   */&#13;
  function calculateFee (uint256 _amount)&#13;
    public delegatable view returns (uint256 _fee) {&#13;
    require (_amount &lt;= MAX_TOKENS_COUNT);&#13;
&#13;
    _fee = safeMul (_amount, variableFeeNumerator) / FEE_DENOMINATOR;&#13;
    if (_fee &lt; minVariableFee) _fee = minVariableFee;&#13;
    if (_fee &gt; maxVariableFee) _fee = maxVariableFee;&#13;
    _fee = safeAdd (_fee, fixedFee);&#13;
  }&#13;
&#13;
  /**&#13;
   * Set flags for given address.&#13;
   *&#13;
   * @param _address address to set flags for&#13;
   * @param _flags flags to set&#13;
   */&#13;
  function setFlags (address _address, uint256 _flags)&#13;
  public delegatable payable {&#13;
    require (msg.sender == owner);&#13;
&#13;
    addressFlags [_address] = _flags;&#13;
  }&#13;
&#13;
  /**&#13;
   * Get flags for given address.&#13;
   *&#13;
   * @param _address address to get flags for&#13;
   * @return flags for given address&#13;
   */&#13;
  function flags (address _address) public delegatable view returns (uint256) {&#13;
    return addressFlags [_address];&#13;
  }&#13;
&#13;
  /**&#13;
   * Set address of smart contract to delegate execution of delegatable methods&#13;
   * to.&#13;
   *&#13;
   * @param _delegate address of smart contract to delegate execution of&#13;
   * delegatable methods to, or zero to not delegate delegatable methods&#13;
   * execution.&#13;
   */&#13;
  function setDelegate (address _delegate) public {&#13;
    require (msg.sender == owner);&#13;
&#13;
    if (delegate != _delegate) {&#13;
      delegate = _delegate;&#13;
      Delegation (delegate);&#13;
    }&#13;
  }&#13;
&#13;
  /**&#13;
   * Get address of this smart contract.&#13;
   *&#13;
   * @return address of this smart contract&#13;
   */&#13;
  function thisAddress () internal view returns (address) {&#13;
    return this;&#13;
  }&#13;
&#13;
  /**&#13;
   * Get address of message sender.&#13;
   *&#13;
   * @return address of this smart contract&#13;
   */&#13;
  function messageSenderAddress () internal view returns (address) {&#13;
    return msg.sender;&#13;
  }&#13;
&#13;
  /**&#13;
   * Owner of the smart contract.&#13;
   */&#13;
  address internal owner;&#13;
&#13;
  /**&#13;
   * Address where fees are sent to.&#13;
   */&#13;
  address internal feeCollector;&#13;
&#13;
  /**&#13;
   * Number of tokens in circulation.&#13;
   */&#13;
  uint256 internal tokensCount;&#13;
&#13;
  /**&#13;
   * Whether token transfers are currently frozen.&#13;
   */&#13;
  bool internal frozen;&#13;
&#13;
  /**&#13;
   * Mapping from sender's address to the next delegated transfer nonce.&#13;
   */&#13;
  mapping (address =&gt; uint256) internal nonces;&#13;
&#13;
  /**&#13;
   * Fixed fee amount in token units.&#13;
   */&#13;
  uint256 internal fixedFee;&#13;
&#13;
  /**&#13;
   * Minimum variable fee in token units.&#13;
   */&#13;
  uint256 internal minVariableFee;&#13;
&#13;
  /**&#13;
   * Maximum variable fee in token units.&#13;
   */&#13;
  uint256 internal maxVariableFee;&#13;
&#13;
  /**&#13;
   * Variable fee numerator.&#13;
   */&#13;
  uint256 internal variableFeeNumerator;&#13;
&#13;
  /**&#13;
   * Maps address to its flags.&#13;
   */&#13;
  mapping (address =&gt; uint256) internal addressFlags;&#13;
&#13;
  /**&#13;
   * Address of smart contract to delegate execution of delegatable methods to,&#13;
   * or zero to not delegate delegatable methods execution.&#13;
   */&#13;
  address internal delegate;&#13;
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
&#13;
  /**&#13;
   * Logged when fee parameters were changed.&#13;
   *&#13;
   * @param fixedFee fixed fee in token units&#13;
   * @param minVariableFee minimum variable fee in token units&#13;
   * @param maxVariableFee maximum variable fee in token units&#13;
   * @param variableFeeNumerator variable fee numerator&#13;
   */&#13;
  event FeeChange (&#13;
    uint256 fixedFee,&#13;
    uint256 minVariableFee,&#13;
    uint256 maxVariableFee,&#13;
    uint256 variableFeeNumerator);&#13;
&#13;
  /**&#13;
   * Logged when address of smart contract execution of delegatable methods is&#13;
   * delegated to was changed.&#13;
   *&#13;
   * @param delegate new address of smart contract execution of delegatable&#13;
   * methods is delegated to or zero if execution of delegatable methods is&#13;
   * oot delegated.&#13;
   */&#13;
  event Delegation (address delegate);&#13;
}&#13;
/*&#13;
 * EIP-20 Standard Token Smart Contract Interface.&#13;
 * Copyright © 2016–2018 by ABDK Consulting.&#13;
 * Author: Mikhail Vladimirov &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="6805010300090104461e04090c0105011a071e280f05090104460b0705">[email protected]</a>&gt;&#13;
 */&#13;
&#13;
/**&#13;
 * ERC-20 standard token interface, as defined&#13;
 * &lt;a href="https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md"&gt;here&lt;/a&gt;.&#13;
 */