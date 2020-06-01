pragma solidity ^0.4.24;
// produced by the Solididy File Flattener (c) David Appleton 2018
// contact : <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="f094918695b0919b9f9d9291de939f9d">[email protected]</a>&#13;
// released under Apache 2.0 licence&#13;
// input  /home/henry/learning/git/smartContract/truffle/022-sht/contracts-bak/SibbayHealthToken.sol&#13;
// flattened :  Saturday, 17-Nov-18 06:24:45 UTC&#13;
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
contract ERC20Basic {&#13;
  function totalSupply() public view returns (uint256);&#13;
  function balanceOf(address who) public view returns (uint256);&#13;
  function transfer(address to, uint256 value) public returns (bool);&#13;
  event Transfer(address indexed from, address indexed to, uint256 value);&#13;
}&#13;
&#13;
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
contract Management is Ownable {&#13;
&#13;
  /**&#13;
   * 暂停和取消暂停事件&#13;
   * */&#13;
  event Pause();&#13;
  event Unpause();&#13;
&#13;
  /**&#13;
   * 打开锁定期自动释放事件&#13;
   * 关闭锁定期自动释放事件&#13;
   * 打开强制锁定期自动释放事件&#13;
   * */&#13;
  event OpenAutoFree(address indexed admin, address indexed who);&#13;
  event CloseAutoFree(address indexed admin, address indexed who);&#13;
  event OpenForceAutoFree(address indexed admin, address indexed who);&#13;
&#13;
  /**&#13;
   * 增加和删除管理员事件&#13;
   * */&#13;
  event AddAdministrator(address indexed admin);&#13;
  event DelAdministrator(address indexed admin);&#13;
&#13;
  /**&#13;
   * 合约暂停标志, True 暂停，false 未暂停&#13;
   * 锁定余额自动释放开关&#13;
   * 强制锁定余额自动释放开关&#13;
   * 合约管理员&#13;
   * */&#13;
  bool public paused = false;&#13;
  mapping(address =&gt; bool) public autoFreeLockBalance;          // false(default) for auto frce, true for not free&#13;
  mapping(address =&gt; bool) public forceAutoFreeLockBalance;     // false(default) for not force free, true for froce free&#13;
  mapping(address =&gt; bool) public adminList;&#13;
&#13;
  /**&#13;
   * 构造函数&#13;
   * */&#13;
  constructor() public {&#13;
  }&#13;
&#13;
  /**&#13;
   * modifier 要求合约正在运行状态&#13;
   */&#13;
  modifier whenNotPaused() {&#13;
    require(!paused);&#13;
    _;&#13;
  }&#13;
&#13;
  /**&#13;
   * modifier 要求合约暂停状态&#13;
   */&#13;
  modifier whenPaused() {&#13;
    require(paused);&#13;
    _;&#13;
  }&#13;
&#13;
  /**&#13;
   * 要求是管理员&#13;
   * */&#13;
  modifier whenAdministrator(address who) {&#13;
    require(adminList[who]);&#13;
    _;&#13;
  }&#13;
&#13;
  /**&#13;
   * 要求不是管理员&#13;
   * */&#13;
  modifier whenNotAdministrator(address who) {&#13;
    require(!adminList[who]);&#13;
    _;&#13;
  }&#13;
&#13;
  /**&#13;
   * * 暂停合约&#13;
   */&#13;
  function pause() onlyOwner whenNotPaused public {&#13;
    paused = true;&#13;
    emit Pause();&#13;
  }&#13;
&#13;
  /**&#13;
   * 取消暂停合约&#13;
   */&#13;
  function unpause() onlyOwner whenPaused public {&#13;
    paused = false;&#13;
    emit Unpause();&#13;
  }&#13;
&#13;
  /**&#13;
   * 打开锁定期自动释放开关&#13;
   * */&#13;
  function openAutoFree(address who) whenAdministrator(msg.sender) public {&#13;
    delete autoFreeLockBalance[who];&#13;
    emit OpenAutoFree(msg.sender, who);&#13;
  }&#13;
&#13;
  /**&#13;
   * 关闭锁定期自动释放开关&#13;
   * */&#13;
  function closeAutoFree(address who) whenAdministrator(msg.sender) public {&#13;
    autoFreeLockBalance[who] = true;&#13;
    emit CloseAutoFree(msg.sender, who);&#13;
  }&#13;
&#13;
  /**&#13;
   * 打开强制锁定期自动释放开关&#13;
   * 该开关只能打开，不能关闭&#13;
   * */&#13;
  function openForceAutoFree(address who) onlyOwner public {&#13;
    forceAutoFreeLockBalance[who] = true;&#13;
    emit OpenForceAutoFree(msg.sender, who);&#13;
  }&#13;
&#13;
  /**&#13;
   * 添加管理员&#13;
   * */&#13;
  function addAdministrator(address who) onlyOwner public {&#13;
    adminList[who] = true;&#13;
    emit AddAdministrator(who);&#13;
  }&#13;
&#13;
  /**&#13;
   * 删除管理员&#13;
   * */&#13;
  function delAdministrator(address who) onlyOwner public {&#13;
    delete adminList[who];&#13;
    emit DelAdministrator(who);&#13;
  }&#13;
}&#13;
&#13;
contract BasicToken is ERC20Basic {&#13;
  using SafeMath for uint256;&#13;
&#13;
  /**&#13;
   * 账户总余额&#13;
   * */&#13;
  mapping(address =&gt; uint256) balances;&#13;
&#13;
  /**&#13;
   * 总供应量&#13;
   * */&#13;
  uint256 totalSupply_;&#13;
&#13;
  /**&#13;
   * 获取总供应量&#13;
   * */&#13;
  function totalSupply() public view returns (uint256) {&#13;
    return totalSupply_;&#13;
  }&#13;
&#13;
}&#13;
&#13;
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
contract StandardToken is ERC20, BasicToken {&#13;
&#13;
  // 记录代理账户&#13;
  // 第一个address是token的所有者，即被代理账户&#13;
  // 第二个address是token的使用者，即代理账户&#13;
  mapping (address =&gt; mapping (address =&gt; uint256)) internal allowed;&#13;
&#13;
  // 代理转账事件&#13;
  // spender: 代理&#13;
  // from: token所有者&#13;
  // to: token接收账户&#13;
  // value: token的转账数量&#13;
  event TransferFrom(address indexed spender,&#13;
                     address indexed from,&#13;
                     address indexed to,&#13;
                     uint256 value);&#13;
&#13;
&#13;
  /**&#13;
   * 设置代理&#13;
   * _spender 代理账户&#13;
   * _value 代理额度&#13;
   */&#13;
  function approve(address _spender, uint256 _value) public returns (bool) {&#13;
    allowed[msg.sender][_spender] = _value;&#13;
    emit Approval(msg.sender, _spender, _value);&#13;
    return true;&#13;
  }&#13;
&#13;
  /**&#13;
   * 查询代理额度&#13;
   * _owner token拥有者账户&#13;
   * _spender 代理账户&#13;
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
   * 提高代理额度&#13;
   * _spender 代理账户&#13;
   * _addValue 需要提高的代理额度&#13;
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
   * 降低代理额度&#13;
   * _spender 代理账户&#13;
   * _subtractedValue 降低的代理额度&#13;
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
contract SibbayHealthToken is StandardToken, Management {&#13;
&#13;
  string public constant name = "Sibbay Health Token"; // solium-disable-line uppercase&#13;
  string public constant symbol = "SHT"; // solium-disable-line uppercase&#13;
  uint8 public constant decimals = 18; // solium-disable-line uppercase&#13;
&#13;
  /**&#13;
   * 常量&#13;
   * 单位量, 即1个token有多少wei(假定token的最小单位为wei)&#13;
   * */&#13;
  uint256 constant internal MAGNITUDE = 10 ** uint256(decimals);&#13;
&#13;
  uint256 public constant INITIAL_SUPPLY = 1000000000 * MAGNITUDE;&#13;
&#13;
  // 设置赎回价格事件&#13;
  event SetSellPrice(address indexed admin, uint256 price);&#13;
  // 锁定期转账事件&#13;
  event TransferByDate(address indexed from, address indexed to, uint256[] values, uint256[] dates);&#13;
  event TransferFromByDate(address indexed spender, address indexed from, address indexed to, uint256[] values, uint256[] dates);&#13;
  // 关闭赎回事件&#13;
  event CloseSell(address indexed who);&#13;
  // 赎回事件&#13;
  event Sell(address indexed from, address indexed to, uint256 tokenValue, uint256 etherValue);&#13;
  // withdraw 事件&#13;
  event Withdraw(address indexed who, uint256 etherValue);&#13;
  // 添加token到fundAccount账户&#13;
  event AddTokenToFund(address indexed who, address indexed from, uint256 value);&#13;
  // refresh 事件&#13;
  event Refresh(address indexed from, address indexed who);&#13;
&#13;
  /**&#13;
   * 将锁定期的map做成一个list&#13;
   * value 锁定的余额&#13;
   * _next 下个锁定期的到期时间&#13;
   * */&#13;
  struct Element {&#13;
    uint256 value;&#13;
    uint256 next;&#13;
  }&#13;
&#13;
  /**&#13;
   * 账户&#13;
   * lockedBalances 锁定余额&#13;
   * lockedElement 锁定期余额&#13;
   * start_date 锁定期最早到期时间&#13;
   * end_date 锁定期最晚到期时间&#13;
   * */&#13;
  struct Account {&#13;
    uint256 lockedBalances;&#13;
    mapping(uint256 =&gt; Element) lockedElement;&#13;
    uint256 start_date;&#13;
    uint256 end_date;&#13;
  }&#13;
&#13;
  /**&#13;
   * 所有账户&#13;
   * */&#13;
  mapping(address =&gt; Account) public accounts;&#13;
&#13;
  /**&#13;
   * sellPrice: token 赎回价格, 即1 token的赎回价格是多少wei(wei为以太币最小单位)&#13;
   * fundAccount: 特殊资金账户，赎回token，接收购买token资金&#13;
   * sellFlag: 赎回标记&#13;
   * */&#13;
  uint256 public sellPrice;&#13;
  address public fundAccount;&#13;
  bool public sellFlag;&#13;
&#13;
  /**&#13;
   * 需求：owner 每年释放的金额不得超过年初余额的10%&#13;
   * curYear:  当前年初时间&#13;
   * YEAR:  一年365天的时间&#13;
   * vault: owner限制额度&#13;
   * VAULT_FLOOR_VALUE: vault 最低限值&#13;
   * */&#13;
  uint256 public curYear;&#13;
  uint256 constant internal YEAR = 365 * 24 * 3600;&#13;
  uint256 public vault;&#13;
  uint256 constant internal VAULT_FLOOR_VALUE = 10000000 * MAGNITUDE;&#13;
&#13;
  /**&#13;
   * 合约构造函数&#13;
   * 初始化合约的总供应量&#13;
   */&#13;
  constructor(address _owner, address _fund) public {&#13;
    // 要求_owner, _fund不为0&#13;
    require(_owner != address(0));&#13;
    require(_fund != address(0));&#13;
&#13;
    // 设置owner, fund&#13;
    owner = _owner;&#13;
    fundAccount = _fund;&#13;
&#13;
    // 初始化owner是管理员&#13;
    adminList[owner] = true;&#13;
&#13;
    // 初始化发行量&#13;
    totalSupply_ = INITIAL_SUPPLY;&#13;
    balances[owner] = INITIAL_SUPPLY;&#13;
    emit Transfer(0x0, owner, INITIAL_SUPPLY);&#13;
&#13;
    /**&#13;
     * 初始化合约属性&#13;
     * 赎回价格&#13;
     * 赎回标记为false&#13;
     * */&#13;
    sellPrice = 0;&#13;
    sellFlag = true;&#13;
&#13;
    /**&#13;
     * 初始化owner限制额度&#13;
     * 2018/01/01 00:00:00&#13;
     * */&#13;
    vault = totalSupply_.mul(10).div(100);&#13;
    curYear = 1514736000;&#13;
  }&#13;
&#13;
  /**&#13;
   * fallback函数&#13;
   * */&#13;
  function () external payable {&#13;
  }&#13;
&#13;
  /**&#13;
   * modifier 要求开启赎回token&#13;
   * */&#13;
  modifier whenOpenSell()&#13;
  {&#13;
    require(sellFlag);&#13;
    _;&#13;
  }&#13;
&#13;
  /**&#13;
   * modifier 要求关闭赎回token&#13;
   * */&#13;
  modifier whenCloseSell()&#13;
  {&#13;
    require(!sellFlag);&#13;
    _;&#13;
  }&#13;
&#13;
  /**&#13;
   * 刷新owner限制余额vault&#13;
   * */&#13;
  function refreshVault(address _who, uint256 _value) internal&#13;
  {&#13;
    uint256 balance;&#13;
&#13;
    // 只对owner操作&#13;
    if (_who != owner)&#13;
      return ;&#13;
    // 记录balance of owner&#13;
    balance = balances[owner];&#13;
    // 如果是新的一年, 则计算vault为当前余额的10%&#13;
    if (now &gt;= (curYear + YEAR))&#13;
    {&#13;
      if (balance &lt;= VAULT_FLOOR_VALUE)&#13;
        vault = balance;&#13;
      else&#13;
        vault = balance.mul(10).div(100);&#13;
      curYear = curYear.add(YEAR);&#13;
    }&#13;
&#13;
    // vault 必须大于等于 _value&#13;
    require(vault &gt;= _value);&#13;
    vault = vault.sub(_value);&#13;
    return ;&#13;
  }&#13;
&#13;
  /**&#13;
   * 重新计算到期的锁定期余额, 内部接口&#13;
   * _who: 账户地址&#13;
   * */&#13;
  function refreshlockedBalances(address _who, bool _update) internal returns (uint256)&#13;
  {&#13;
    uint256 tmp_date = accounts[_who].start_date;&#13;
    uint256 tmp_value = accounts[_who].lockedElement[tmp_date].value;&#13;
    uint256 tmp_balances = 0;&#13;
    uint256 tmp_var;&#13;
&#13;
    // 强制自动释放打开则跳过判断，直接释放锁定期余额&#13;
    if (!forceAutoFreeLockBalance[_who])&#13;
    {&#13;
      // 强制自动释放未打开，则判断自动释放开关&#13;
      if(autoFreeLockBalance[_who])&#13;
      {&#13;
        // 自动释放开关未打开(true), 直接返回0&#13;
        return 0;&#13;
      }&#13;
    }&#13;
&#13;
    // 锁定期到期&#13;
    while(tmp_date != 0 &amp;&amp;&#13;
          tmp_date &lt;= now)&#13;
    {&#13;
      // 记录到期余额&#13;
      tmp_balances = tmp_balances.add(tmp_value);&#13;
&#13;
      // 记录 tmp_date&#13;
      tmp_var = tmp_date;&#13;
&#13;
      // 跳到下一个锁定期&#13;
      tmp_date = accounts[_who].lockedElement[tmp_date].next;&#13;
      tmp_value = accounts[_who].lockedElement[tmp_date].value;&#13;
&#13;
      // delete 锁定期余额&#13;
      if (_update)&#13;
        delete accounts[_who].lockedElement[tmp_var];&#13;
    }&#13;
&#13;
    // return expired balance&#13;
    if(!_update)&#13;
      return tmp_balances;&#13;
&#13;
    // 修改锁定期数据&#13;
    accounts[_who].start_date = tmp_date;&#13;
    accounts[_who].lockedBalances = accounts[_who].lockedBalances.sub(tmp_balances);&#13;
    balances[_who] = balances[_who].add(tmp_balances);&#13;
&#13;
    // 将最早和最晚时间的标志，都置0，即最初状态&#13;
    if (accounts[_who].start_date == 0)&#13;
        accounts[_who].end_date = 0;&#13;
&#13;
    return tmp_balances;&#13;
  }&#13;
&#13;
  /**&#13;
   * 可用余额转账，内部接口&#13;
   * _from token的拥有者&#13;
   * _to token的接收者&#13;
   * _value token的数量&#13;
   * */&#13;
  function transferAvailableBalances(&#13;
    address _from,&#13;
    address _to,&#13;
    uint256 _value&#13;
  )&#13;
    internal&#13;
  {&#13;
    // 检查可用余额&#13;
    require(_value &lt;= balances[_from]);&#13;
&#13;
    // 修改可用余额&#13;
    balances[_from] = balances[_from].sub(_value);&#13;
    balances[_to] = balances[_to].add(_value);&#13;
&#13;
    // 触发转账事件&#13;
    if(_from == msg.sender)&#13;
      emit Transfer(_from, _to, _value);&#13;
    else&#13;
      emit TransferFrom(msg.sender, _from, _to, _value);&#13;
  }&#13;
&#13;
  /**&#13;
   * 锁定余额转账，内部接口&#13;
   * _from token的拥有者&#13;
   * _to token的接收者&#13;
   * _value token的数量&#13;
   * */&#13;
  function transferLockedBalances(&#13;
    address _from,&#13;
    address _to,&#13;
    uint256 _value&#13;
  )&#13;
    internal&#13;
  {&#13;
    // 检查可用余额&#13;
    require(_value &lt;= balances[_from]);&#13;
&#13;
    // 修改可用余额和锁定余额&#13;
    balances[_from] = balances[_from].sub(_value);&#13;
    accounts[_to].lockedBalances = accounts[_to].lockedBalances.add(_value);&#13;
  }&#13;
&#13;
  /**&#13;
   * 回传以太币, 内部接口&#13;
   * _from token来源账户&#13;
   * _to token目标账户&#13;
   * _value 为token数目&#13;
   * */&#13;
  function transferEther(&#13;
    address _from,&#13;
    address _to,&#13;
    uint256 _value&#13;
  )&#13;
    internal&#13;
  {&#13;
    /**&#13;
     * 要求 _to 账户接收地址为特殊账户地址&#13;
     * 这里只能为return，不能为revert&#13;
     * 普通转账在这里返回, 不赎回ether&#13;
     * */&#13;
    if (_to != fundAccount)&#13;
        return ;&#13;
&#13;
    /**&#13;
     * 没有打开赎回功能，不能向fundAccount转账&#13;
     * */&#13;
    require(sellFlag);&#13;
&#13;
    /**&#13;
     * 赎回价格必须大于0&#13;
     * 赎回的token必须大于0&#13;
     * */&#13;
    require(_value &gt; 0);&#13;
&#13;
    // 赎回的以太币必须小于账户余额, evalue 单位是wei，即以太币的最小单位&#13;
    uint256 evalue = _value.mul(sellPrice).div(MAGNITUDE);&#13;
    require(evalue &lt;= address(this).balance);&#13;
&#13;
    // 回传以太币&#13;
    if (evalue &gt; 0)&#13;
    {&#13;
      _from.transfer(evalue);&#13;
      emit Sell(_from, _to, _value, evalue);&#13;
    }&#13;
  }&#13;
&#13;
  /**&#13;
   * 取回合约上所有的以太币&#13;
   * 只有owner才能取回&#13;
   * */&#13;
  function withdraw() public onlyOwner {&#13;
    uint256 value = address(this).balance;&#13;
    owner.transfer(value);&#13;
    emit Withdraw(msg.sender, value);&#13;
  }&#13;
&#13;
  /**&#13;
   * 从from账户向fundAccount添加token&#13;
   * */&#13;
  function addTokenToFund(address _from, uint256 _value) &#13;
    whenNotPaused&#13;
    public&#13;
  {&#13;
    if (_from != msg.sender)&#13;
    {&#13;
      // 检查代理额度&#13;
      require(_value &lt;= allowed[_from][msg.sender]);&#13;
&#13;
      // 修改代理额度&#13;
      allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);&#13;
    }&#13;
&#13;
    // 刷新vault余额&#13;
    refreshVault(_from, _value);&#13;
&#13;
    // 修改可用账户余额&#13;
    transferAvailableBalances(_from, fundAccount, _value);&#13;
    emit AddTokenToFund(msg.sender, _from, _value);&#13;
  }&#13;
&#13;
  /**&#13;
   * 转账&#13;
   * */&#13;
  function transfer(&#13;
    address _to,&#13;
    uint256 _value&#13;
  )&#13;
    public&#13;
    whenNotPaused&#13;
    returns (bool)&#13;
  {&#13;
    // 不能给地址0转账&#13;
    require(_to != address(0));&#13;
&#13;
    /**&#13;
     * 获取到期的锁定期余额&#13;
     * */&#13;
    refreshlockedBalances(msg.sender, true);&#13;
    refreshlockedBalances(_to, true);&#13;
&#13;
    // 刷新vault余额&#13;
    refreshVault(msg.sender, _value);&#13;
&#13;
    // 修改可用账户余额&#13;
    transferAvailableBalances(msg.sender, _to, _value);&#13;
&#13;
    // 回传以太币&#13;
    transferEther(msg.sender, _to, _value);&#13;
&#13;
    return true;&#13;
  }&#13;
&#13;
  /**&#13;
   * 代理转账&#13;
   * 代理从 _from 转账 _value 到 _to&#13;
   * */&#13;
  function transferFrom(&#13;
    address _from,&#13;
    address _to,&#13;
    uint256 _value&#13;
  )&#13;
    public&#13;
    whenNotPaused&#13;
    returns (bool)&#13;
  {&#13;
    // 不能向赎回地址发送token&#13;
    require(_to != fundAccount);&#13;
&#13;
    // 不能向0地址转账&#13;
    require(_to != address(0));&#13;
&#13;
    /**&#13;
     * 获取到期的锁定期余额&#13;
     * */&#13;
    refreshlockedBalances(_from, true);&#13;
    refreshlockedBalances(_to, true);&#13;
&#13;
    // 检查代理额度&#13;
    require(_value &lt;= allowed[_from][msg.sender]);&#13;
&#13;
    // 修改代理额度&#13;
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);&#13;
&#13;
    // 刷新vault余额&#13;
    refreshVault(_from, _value);&#13;
&#13;
    // 修改可用账户余额&#13;
    transferAvailableBalances(_from, _to, _value);&#13;
&#13;
    return true;&#13;
  }&#13;
&#13;
  /**&#13;
   * 设定代理和代理额度&#13;
   * 设定代理为 _spender 额度为 _value&#13;
   * */&#13;
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
  /**&#13;
   * 提高代理的代理额度&#13;
   * 提高代理 _spender 的代理额度 _addedValue&#13;
   * */&#13;
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
  /**&#13;
   * 降低代理的代理额度&#13;
   * 降低代理 _spender 的代理额度 _subtractedValue&#13;
   * */&#13;
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
&#13;
  /**&#13;
   * 批量转账 token&#13;
   * 批量用户 _receivers&#13;
   * 对应的转账数量 _values&#13;
   * */&#13;
  function batchTransfer(&#13;
    address[] _receivers,&#13;
    uint256[] _values&#13;
  )&#13;
    public&#13;
    whenNotPaused&#13;
  {&#13;
    // 判断接收账号和token数量为一一对应&#13;
    require(_receivers.length &gt; 0 &amp;&amp; _receivers.length == _values.length);&#13;
&#13;
    /**&#13;
     * 获取到期的锁定期余额&#13;
     * */&#13;
    refreshlockedBalances(msg.sender, true);&#13;
&#13;
    // 判断可用余额足够&#13;
    uint32 i = 0;&#13;
    uint256 total = 0;&#13;
    for (i = 0; i &lt; _values.length; i ++)&#13;
    {&#13;
      total = total.add(_values[i]);&#13;
    }&#13;
    require(total &lt;= balances[msg.sender]);&#13;
&#13;
    // 刷新vault余额&#13;
    refreshVault(msg.sender, total);&#13;
&#13;
    // 一一 转账&#13;
    for (i = 0; i &lt; _receivers.length; i ++)&#13;
    {&#13;
      // 不能向赎回地址发送token&#13;
      require(_receivers[i] != fundAccount);&#13;
&#13;
      // 不能向0地址转账&#13;
      require(_receivers[i] != address(0));&#13;
&#13;
      refreshlockedBalances(_receivers[i], true);&#13;
      // 修改可用账户余额&#13;
      transferAvailableBalances(msg.sender, _receivers[i], _values[i]);&#13;
    }&#13;
  }&#13;
&#13;
  /**&#13;
   * 代理批量转账 token&#13;
   * 被代理人 _from&#13;
   * 批量用户 _receivers&#13;
   * 对应的转账数量 _values&#13;
   * */&#13;
  function batchTransferFrom(&#13;
    address _from,&#13;
    address[] _receivers,&#13;
    uint256[] _values&#13;
  )&#13;
    public&#13;
    whenNotPaused&#13;
  {&#13;
    // 判断接收账号和token数量为一一对应&#13;
    require(_receivers.length &gt; 0 &amp;&amp; _receivers.length == _values.length);&#13;
&#13;
    /**&#13;
     * 获取到期的锁定期余额&#13;
     * */&#13;
    refreshlockedBalances(_from, true);&#13;
&#13;
    // 判断可用余额足够&#13;
    uint32 i = 0;&#13;
    uint256 total = 0;&#13;
    for (i = 0; i &lt; _values.length; i ++)&#13;
    {&#13;
      total = total.add(_values[i]);&#13;
    }&#13;
    require(total &lt;= balances[_from]);&#13;
&#13;
    // 判断代理额度足够&#13;
    require(total &lt;= allowed[_from][msg.sender]);&#13;
&#13;
    // 修改代理额度&#13;
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(total);&#13;
&#13;
    // 刷新vault余额&#13;
    refreshVault(_from, total);&#13;
&#13;
    // 一一 转账&#13;
    for (i = 0; i &lt; _receivers.length; i ++)&#13;
    {&#13;
      // 不能向赎回地址发送token&#13;
      require(_receivers[i] != fundAccount);&#13;
&#13;
      // 不能向0地址转账&#13;
      require(_receivers[i] != address(0));&#13;
&#13;
      refreshlockedBalances(_receivers[i], true);&#13;
      // 修改可用账户余额&#13;
      transferAvailableBalances(_from, _receivers[i], _values[i]);&#13;
    }&#13;
  }&#13;
&#13;
  /**&#13;
   * 带有锁定期的转账, 当锁定期到期之后，锁定token数量将转入可用余额&#13;
   * _receiver 转账接收账户&#13;
   * _values 转账数量&#13;
   * _dates 锁定期，即到期时间&#13;
   *        格式：UTC时间，单位秒，即从1970年1月1日开始到指定时间所经历的秒&#13;
   * */&#13;
  function transferByDate(&#13;
    address _receiver,&#13;
    uint256[] _values,&#13;
    uint256[] _dates&#13;
  )&#13;
    public&#13;
    whenNotPaused&#13;
  {&#13;
    // 判断接收账号和token数量为一一对应&#13;
    require(_values.length &gt; 0 &amp;&amp;&#13;
        _values.length == _dates.length);&#13;
&#13;
    // 不能向赎回地址发送token&#13;
    require(_receiver != fundAccount);&#13;
&#13;
    // 不能向0地址转账&#13;
    require(_receiver != address(0));&#13;
&#13;
    /**&#13;
     * 获取到期的锁定期余额&#13;
     * */&#13;
    refreshlockedBalances(msg.sender, true);&#13;
    refreshlockedBalances(_receiver, true);&#13;
&#13;
    // 判断可用余额足够&#13;
    uint32 i = 0;&#13;
    uint256 total = 0;&#13;
    for (i = 0; i &lt; _values.length; i ++)&#13;
    {&#13;
      total = total.add(_values[i]);&#13;
    }&#13;
    require(total &lt;= balances[msg.sender]);&#13;
&#13;
    // 刷新vault余额&#13;
    refreshVault(msg.sender, total);&#13;
&#13;
    // 转账&#13;
    for(i = 0; i &lt; _values.length; i ++)&#13;
    {&#13;
      transferByDateSingle(msg.sender, _receiver, _values[i], _dates[i]);&#13;
    }&#13;
&#13;
    emit TransferByDate(msg.sender, _receiver, _values, _dates);&#13;
  }&#13;
&#13;
  /**&#13;
   * 代理带有锁定期的转账, 当锁定期到期之后，锁定token数量将转入可用余额&#13;
   * _from 被代理账户&#13;
   * _receiver 转账接收账户&#13;
   * _values 转账数量&#13;
   * _dates 锁定期，即到期时间&#13;
   *        格式：UTC时间，单位秒，即从1970年1月1日开始到指定时间所经历的秒&#13;
   * */&#13;
  function transferFromByDate(&#13;
    address _from,&#13;
    address _receiver,&#13;
    uint256[] _values,&#13;
    uint256[] _dates&#13;
  )&#13;
    public&#13;
    whenNotPaused&#13;
  {&#13;
    // 判断接收账号和token数量为一一对应&#13;
    require(_values.length &gt; 0 &amp;&amp;&#13;
        _values.length == _dates.length);&#13;
&#13;
    // 不能向赎回地址发送token&#13;
    require(_receiver != fundAccount);&#13;
&#13;
    // 不能向0地址转账&#13;
    require(_receiver != address(0));&#13;
&#13;
    /**&#13;
     * 获取到期的锁定期余额&#13;
     * */&#13;
    refreshlockedBalances(_from, true);&#13;
    refreshlockedBalances(_receiver, true);&#13;
&#13;
    // 判断可用余额足够&#13;
    uint32 i = 0;&#13;
    uint256 total = 0;&#13;
    for (i = 0; i &lt; _values.length; i ++)&#13;
    {&#13;
      total = total.add(_values[i]);&#13;
    }&#13;
    require(total &lt;= balances[_from]);&#13;
&#13;
    // 判断代理额度足够&#13;
    require(total &lt;= allowed[_from][msg.sender]);&#13;
&#13;
    // 修改代理额度&#13;
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(total);&#13;
&#13;
    // 刷新vault余额&#13;
    refreshVault(_from, total);&#13;
&#13;
    // 转账&#13;
    for(i = 0; i &lt; _values.length; i ++)&#13;
    {&#13;
      transferByDateSingle(_from, _receiver, _values[i], _dates[i]);&#13;
    }&#13;
&#13;
    emit TransferFromByDate(msg.sender, _from, _receiver, _values, _dates);&#13;
  }&#13;
&#13;
  /**&#13;
   * _from token拥有者&#13;
   * _to 转账接收账户&#13;
   * _value 转账数量&#13;
   * _date 锁定期，即到期时间&#13;
   *       格式：UTC时间，单位秒，即从1970年1月1日开始到指定时间所经历的秒&#13;
   * */&#13;
  function transferByDateSingle(&#13;
    address _from,&#13;
    address _to,&#13;
    uint256 _value,&#13;
    uint256 _date&#13;
  )&#13;
    internal&#13;
  {&#13;
    uint256 start_date = accounts[_to].start_date;&#13;
    uint256 end_date = accounts[_to].end_date;&#13;
    uint256 tmp_var = accounts[_to].lockedElement[_date].value;&#13;
    uint256 tmp_date;&#13;
&#13;
    if (_value == 0)&#13;
    {&#13;
        // 不做任何处理&#13;
        return ;&#13;
    }&#13;
&#13;
    if (_date &lt;= now)&#13;
    {&#13;
      // 到期时间比当前早，直接转入可用余额&#13;
      // 修改可用账户余额&#13;
      transferAvailableBalances(_from, _to, _value);&#13;
&#13;
      return ;&#13;
    }&#13;
&#13;
    if (start_date == 0)&#13;
    {&#13;
      // 还没有收到过锁定期转账&#13;
      // 最早时间和最晚时间一样&#13;
      accounts[_to].start_date = _date;&#13;
      accounts[_to].end_date = _date;&#13;
      accounts[_to].lockedElement[_date].value = _value;&#13;
    }&#13;
    else if (tmp_var &gt; 0)&#13;
    {&#13;
      // 收到过相同的锁定期&#13;
      accounts[_to].lockedElement[_date].value = tmp_var.add(_value);&#13;
    }&#13;
    else if (_date &lt; start_date)&#13;
    {&#13;
      // 锁定期比最早到期的还早&#13;
      // 添加锁定期，并加入到锁定期列表&#13;
      accounts[_to].lockedElement[_date].value = _value;&#13;
      accounts[_to].lockedElement[_date].next = start_date;&#13;
      accounts[_to].start_date = _date;&#13;
    }&#13;
    else if (_date &gt; end_date)&#13;
    {&#13;
      // 锁定期比最晚到期还晚&#13;
      // 添加锁定期，并加入到锁定期列表&#13;
      accounts[_to].lockedElement[_date].value = _value;&#13;
      accounts[_to].lockedElement[end_date].next = _date;&#13;
      accounts[_to].end_date = _date;&#13;
    }&#13;
    else&#13;
    {&#13;
      /**&#13;
       * 锁定期在 最早和最晚之间&#13;
       * 首先找到插入的位置&#13;
       * 然后在插入的位置插入数据&#13;
       * tmp_var 即 tmp_next&#13;
       * */&#13;
      tmp_date = start_date;&#13;
      tmp_var = accounts[_to].lockedElement[tmp_date].next;&#13;
      while(tmp_var &lt; _date)&#13;
      {&#13;
        tmp_date = tmp_var;&#13;
        tmp_var = accounts[_to].lockedElement[tmp_date].next;&#13;
      }&#13;
&#13;
      // 记录锁定期并加入列表&#13;
      accounts[_to].lockedElement[_date].value = _value;&#13;
      accounts[_to].lockedElement[_date].next = tmp_var;&#13;
      accounts[_to].lockedElement[tmp_date].next = _date;&#13;
    }&#13;
&#13;
    // 锁定期转账&#13;
    transferLockedBalances(_from, _to, _value);&#13;
&#13;
    return ;&#13;
  }&#13;
&#13;
  /**&#13;
   * sell tokens&#13;
   * */&#13;
  function sell(uint256 _value) public whenOpenSell whenNotPaused {&#13;
    transfer(fundAccount, _value);&#13;
  }&#13;
&#13;
  /**&#13;
   * 设置token赎回价格&#13;
   * */&#13;
  function setSellPrice(uint256 price) public whenAdministrator(msg.sender) {&#13;
    require(price &gt; 0);&#13;
    sellPrice = price;&#13;
&#13;
    emit SetSellPrice(msg.sender, price);&#13;
  }&#13;
&#13;
  /**&#13;
   * 关闭购买赎回token&#13;
   * */&#13;
  function closeSell() public whenOpenSell onlyOwner {&#13;
    sellFlag = false;&#13;
    emit CloseSell(msg.sender);&#13;
  }&#13;
&#13;
  /**&#13;
   * 重新计算账号的lockbalance&#13;
   * */&#13;
  function refresh(address _who) public whenNotPaused {&#13;
    refreshlockedBalances(_who, true);&#13;
    emit Refresh(msg.sender, _who);&#13;
  }&#13;
&#13;
  /**&#13;
   * 查询账户可用余额&#13;
   * */&#13;
  function availableBalanceOf(address _owner) public view returns (uint256) {&#13;
    return (balances[_owner] + refreshlockedBalances(_owner, false));&#13;
  }&#13;
&#13;
  /**&#13;
   * 查询账户总余额&#13;
   * */&#13;
  function balanceOf(address _owner) public view returns (uint256) {&#13;
    return balances[_owner] + accounts[_owner].lockedBalances;&#13;
  }&#13;
&#13;
  /**&#13;
   * 获取锁定余额&#13;
   * */&#13;
  function lockedBalanceOf(address _who) public view returns (uint256) {&#13;
    return (accounts[_who].lockedBalances - refreshlockedBalances(_who, false));&#13;
  }&#13;
&#13;
  /**&#13;
   * 根据日期获取锁定余额&#13;
   * 返回：锁定余额，下一个锁定期&#13;
   * */&#13;
  function lockedBalanceOfByDate(address _who, uint256 date) public view returns (uint256, uint256) {&#13;
    return (accounts[_who].lockedElement[date].value, accounts[_who].lockedElement[date].next);&#13;
  }&#13;
&#13;
}