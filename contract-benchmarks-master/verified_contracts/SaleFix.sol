pragma solidity ^0.4.24;

// File: node_modules/openzeppelin-solidity/contracts/ownership/Ownable.sol

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address private _owner;

  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );

  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  constructor() internal {
    _owner = msg.sender;
    emit OwnershipTransferred(address(0), _owner);
  }

  /**
   * @return the address of the owner.
   */
  function owner() public view returns(address) {
    return _owner;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(isOwner());
    _;
  }

  /**
   * @return true if `msg.sender` is the owner of the contract.
   */
  function isOwner() public view returns(bool) {
    return msg.sender == _owner;
  }

  /**
   * @dev Allows the current owner to relinquish control of the contract.
   * @notice Renouncing to ownership will leave the contract without an owner.
   * It will not be possible to call the functions with the `onlyOwner`
   * modifier anymore.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  /**
   * @dev Transfers control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0));
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

// File: node_modules/openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol

/**
 * @title Helps contracts guard against reentrancy attacks.
 * @author Remco Bloemen <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="f785929a9498b7c5">[email protected]</a>π.com&gt;, Eenae &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="51303d34293428113c382933282534227f383e">[email protected]</a>&gt;&#13;
 * @dev If you mark a function `nonReentrant`, you should also&#13;
 * mark it `external`.&#13;
 */&#13;
contract ReentrancyGuard {&#13;
&#13;
  /// @dev counter to allow mutex lock with only one SSTORE operation&#13;
  uint256 private _guardCounter;&#13;
&#13;
  constructor() internal {&#13;
    // The counter starts at one to prevent changing it from zero to a non-zero&#13;
    // value, which is a more expensive operation.&#13;
    _guardCounter = 1;&#13;
  }&#13;
&#13;
  /**&#13;
   * @dev Prevents a contract from calling itself, directly or indirectly.&#13;
   * Calling a `nonReentrant` function from another `nonReentrant`&#13;
   * function is not supported. It is possible to prevent this from happening&#13;
   * by making the `nonReentrant` function external, and make it call a&#13;
   * `private` function that does the actual work.&#13;
   */&#13;
  modifier nonReentrant() {&#13;
    _guardCounter += 1;&#13;
    uint256 localCounter = _guardCounter;&#13;
    _;&#13;
    require(localCounter == _guardCounter);&#13;
  }&#13;
&#13;
}&#13;
&#13;
// File: node_modules/openzeppelin-solidity/contracts/math/Safemath.sol&#13;
&#13;
/**&#13;
 * @title SafeMath&#13;
 * @dev Math operations with safety checks that revert on error&#13;
 */&#13;
library SafeMath {&#13;
&#13;
  /**&#13;
  * @dev Multiplies two numbers, reverts on overflow.&#13;
  */&#13;
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {&#13;
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the&#13;
    // benefit is lost if 'b' is also tested.&#13;
    // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522&#13;
    if (a == 0) {&#13;
      return 0;&#13;
    }&#13;
&#13;
    uint256 c = a * b;&#13;
    require(c / a == b);&#13;
&#13;
    return c;&#13;
  }&#13;
&#13;
  /**&#13;
  * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.&#13;
  */&#13;
  function div(uint256 a, uint256 b) internal pure returns (uint256) {&#13;
    require(b &gt; 0); // Solidity only automatically asserts when dividing by 0&#13;
    uint256 c = a / b;&#13;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold&#13;
&#13;
    return c;&#13;
  }&#13;
&#13;
  /**&#13;
  * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).&#13;
  */&#13;
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {&#13;
    require(b &lt;= a);&#13;
    uint256 c = a - b;&#13;
&#13;
    return c;&#13;
  }&#13;
&#13;
  /**&#13;
  * @dev Adds two numbers, reverts on overflow.&#13;
  */&#13;
  function add(uint256 a, uint256 b) internal pure returns (uint256) {&#13;
    uint256 c = a + b;&#13;
    require(c &gt;= a);&#13;
&#13;
    return c;&#13;
  }&#13;
&#13;
  /**&#13;
  * @dev Divides two numbers and returns the remainder (unsigned integer modulo),&#13;
  * reverts when dividing by zero.&#13;
  */&#13;
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {&#13;
    require(b != 0);&#13;
    return a % b;&#13;
  }&#13;
}&#13;
&#13;
// File: node_modules/openzeppelin-solidity/contracts/token/ERC20/IERC20.sol&#13;
&#13;
/**&#13;
 * @title ERC20 interface&#13;
 * @dev see https://github.com/ethereum/EIPs/issues/20&#13;
 */&#13;
interface IERC20 {&#13;
  function totalSupply() external view returns (uint256);&#13;
&#13;
  function balanceOf(address who) external view returns (uint256);&#13;
&#13;
  function allowance(address owner, address spender)&#13;
    external view returns (uint256);&#13;
&#13;
  function transfer(address to, uint256 value) external returns (bool);&#13;
&#13;
  function approve(address spender, uint256 value)&#13;
    external returns (bool);&#13;
&#13;
  function transferFrom(address from, address to, uint256 value)&#13;
    external returns (bool);&#13;
&#13;
  event Transfer(&#13;
    address indexed from,&#13;
    address indexed to,&#13;
    uint256 value&#13;
  );&#13;
&#13;
  event Approval(&#13;
    address indexed owner,&#13;
    address indexed spender,&#13;
    uint256 value&#13;
  );&#13;
}&#13;
&#13;
// File: lib/CanReclaimToken.sol&#13;
&#13;
/**&#13;
 * @title Contracts that should be able to recover tokens&#13;
 * @author SylTi&#13;
 * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.&#13;
 * This will prevent any accidental loss of tokens.&#13;
 */&#13;
contract CanReclaimToken is Ownable {&#13;
&#13;
  /**&#13;
   * @dev Reclaim all ERC20 compatible tokens&#13;
   * @param token ERC20 The address of the token contract&#13;
   */&#13;
  function reclaimToken(IERC20 token) external onlyOwner {&#13;
    if (address(token) == address(0)) {&#13;
      owner().transfer(address(this).balance);&#13;
      return;&#13;
    }&#13;
    uint256 balance = token.balanceOf(this);&#13;
    token.transfer(owner(), balance);&#13;
  }&#13;
&#13;
}&#13;
&#13;
// File: openzeppelin-solidity/contracts/access/Roles.sol&#13;
&#13;
/**&#13;
 * @title Roles&#13;
 * @dev Library for managing addresses assigned to a Role.&#13;
 */&#13;
library Roles {&#13;
  struct Role {&#13;
    mapping (address =&gt; bool) bearer;&#13;
  }&#13;
&#13;
  /**&#13;
   * @dev give an account access to this role&#13;
   */&#13;
  function add(Role storage role, address account) internal {&#13;
    require(account != address(0));&#13;
    require(!has(role, account));&#13;
&#13;
    role.bearer[account] = true;&#13;
  }&#13;
&#13;
  /**&#13;
   * @dev remove an account's access to this role&#13;
   */&#13;
  function remove(Role storage role, address account) internal {&#13;
    require(account != address(0));&#13;
    require(has(role, account));&#13;
&#13;
    role.bearer[account] = false;&#13;
  }&#13;
&#13;
  /**&#13;
   * @dev check if an account has this role&#13;
   * @return bool&#13;
   */&#13;
  function has(Role storage role, address account)&#13;
    internal&#13;
    view&#13;
    returns (bool)&#13;
  {&#13;
    require(account != address(0));&#13;
    return role.bearer[account];&#13;
  }&#13;
}&#13;
&#13;
// File: lib/ServiceRole.sol&#13;
&#13;
contract ServiceRole {&#13;
  using Roles for Roles.Role;&#13;
&#13;
  event ServiceAdded(address indexed account);&#13;
  event ServiceRemoved(address indexed account);&#13;
&#13;
  Roles.Role private services;&#13;
&#13;
  constructor() internal {&#13;
    _addService(msg.sender);&#13;
  }&#13;
&#13;
  modifier onlyService() {&#13;
    require(isService(msg.sender));&#13;
    _;&#13;
  }&#13;
&#13;
  function isService(address account) public view returns (bool) {&#13;
    return services.has(account);&#13;
  }&#13;
&#13;
  function renounceService() public {&#13;
    _removeService(msg.sender);&#13;
  }&#13;
&#13;
  function _addService(address account) internal {&#13;
    services.add(account);&#13;
    emit ServiceAdded(account);&#13;
  }&#13;
&#13;
  function _removeService(address account) internal {&#13;
    services.remove(account);&#13;
    emit ServiceRemoved(account);&#13;
  }&#13;
}&#13;
&#13;
// File: contracts/SaleFix.sol&#13;
&#13;
interface HEROES {&#13;
  function mint(address to, uint256 genes, uint256 level)  external returns (uint);&#13;
}&#13;
&#13;
//Crypto Hero Rocket coin&#13;
interface CHR {&#13;
  function mint(address _to, uint256 _amount) external returns (bool);&#13;
}&#13;
&#13;
contract SaleFix is Ownable, ServiceRole, ReentrancyGuard, CanReclaimToken {&#13;
  using SafeMath for uint256;&#13;
&#13;
  event ItemUpdate(uint256 indexed itemId, uint256 genes, uint256 level, uint256 price, uint256 count);&#13;
  event Sold(address indexed to, uint256 indexed tokenId, uint256 indexed itemId, uint256 genes, uint256 level, uint256 price);&#13;
  event CoinReward(uint256 code, uint256 coins);&#13;
  event EthReward(uint256 code, uint256 eth);&#13;
  event CoinRewardGet(uint256 code, uint256 coins);&#13;
  event EthRewardGet(uint256 code, uint256 eth);&#13;
  event Income(address source, uint256 amount);&#13;
&#13;
  HEROES public heroes;&#13;
  CHR public coin;&#13;
&#13;
  //MARKET&#13;
  struct Item {&#13;
    bool exists;&#13;
    uint256 index;&#13;
    uint256 genes;&#13;
    uint256 level;&#13;
    uint256 price;&#13;
    uint256 count;&#13;
  }&#13;
&#13;
  // item id =&gt; Item&#13;
  mapping(uint256 =&gt; Item) items;&#13;
  // market index =&gt; item id&#13;
  mapping(uint256 =&gt; uint) public market;&#13;
  uint256 public marketSize;&#13;
&#13;
  uint256 public lastItemId;&#13;
&#13;
&#13;
  //REFERRALS&#13;
  struct Affiliate {&#13;
    uint256 affCode;&#13;
    uint256 coinsToMint;&#13;
    uint256 ethToSend;&#13;
    uint256 coinsMinted;&#13;
    uint256 ethSent;&#13;
    bool active;&#13;
  }&#13;
&#13;
  struct AffiliateReward {&#13;
    uint256 coins;&#13;
    //1% - 100, 10% - 1000 50% - 5000&#13;
    uint256 percent;&#13;
  }&#13;
&#13;
  //personal reward struct&#13;
  struct StaffReward {&#13;
    //1% - 100, 10% - 1000 50% - 5000&#13;
    uint256 coins;&#13;
    uint256 percent;&#13;
    uint256 index;&#13;
    bool exists;&#13;
  }&#13;
&#13;
  //personal reward mapping&#13;
  //staff affCode =&gt; StaffReward&#13;
  mapping (uint256 =&gt; StaffReward) public staffReward;&#13;
  //staff index =&gt; staff affCode&#13;
  mapping (uint256 =&gt; uint) public staffList;&#13;
  uint256 public staffCount;&#13;
&#13;
  //refCode =&gt; Affiliate&#13;
  mapping(uint256 =&gt; Affiliate) public affiliates;&#13;
  mapping(uint256 =&gt; bool) public vipAffiliates;&#13;
  AffiliateReward[] public affLevelReward;&#13;
  AffiliateReward[] public vipAffLevelReward;&#13;
&#13;
  //total reserved eth amount for affiliates&#13;
  uint256 public totalReserved;&#13;
&#13;
  constructor(HEROES _heroes, CHR _coin) public {&#13;
    require(address(_heroes) != address(0));&#13;
    require(address(_coin) != address(0));&#13;
    heroes = _heroes;&#13;
    coin = _coin;&#13;
&#13;
    affLevelReward.push(AffiliateReward({coins : 2, percent : 0})); // level 0 - player self, 2CHR&#13;
    affLevelReward.push(AffiliateReward({coins : 1, percent : 1000})); // level 1, 1CHR, 10%&#13;
    affLevelReward.push(AffiliateReward({coins : 0, percent : 500})); // level 2, 0CHR, 5%&#13;
  &#13;
    vipAffLevelReward.push(AffiliateReward({coins : 2, percent : 0})); // level 0 - player self, 2CHR&#13;
    vipAffLevelReward.push(AffiliateReward({coins : 1, percent : 2000})); // level 1, 1CHR, 20%&#13;
    vipAffLevelReward.push(AffiliateReward({coins : 0, percent : 1000})); // level 2, 0CHR, 10%&#13;
  }&#13;
&#13;
  /// @notice The fallback function payable&#13;
  function() external payable {&#13;
    require(msg.value &gt; 0);&#13;
    _flushBalance();&#13;
  }&#13;
&#13;
  function _flushBalance() private {&#13;
    uint256 balance = address(this).balance.sub(totalReserved);&#13;
    if (balance &gt; 0) {&#13;
      address(heroes).transfer(balance);&#13;
      emit Income(address(this), balance);&#13;
    }&#13;
  }&#13;
&#13;
  function addService(address account) public onlyOwner {&#13;
    _addService(account);&#13;
  }&#13;
&#13;
  function removeService(address account) public onlyOwner {&#13;
    _removeService(account);&#13;
  }&#13;
&#13;
//  function setCoin(CHR _coin) external onlyOwner {&#13;
//    require(address(_coin) != address(0));&#13;
//    coin = _coin;&#13;
//  }&#13;
&#13;
&#13;
  function setAffiliateLevel(uint256 _level, uint256 _rewardCoins, uint256 _rewardPercent) external onlyOwner {&#13;
    require(_level &lt; affLevelReward.length);&#13;
    AffiliateReward storage rew = affLevelReward[_level];&#13;
    rew.coins = _rewardCoins;&#13;
    rew.percent = _rewardPercent;&#13;
  }&#13;
&#13;
&#13;
  function incAffiliateLevel(uint256 _rewardCoins, uint256 _rewardPercent) external onlyOwner {&#13;
    affLevelReward.push(AffiliateReward({coins : _rewardCoins, percent : _rewardPercent}));&#13;
  }&#13;
&#13;
  function decAffiliateLevel() external onlyOwner {&#13;
    delete affLevelReward[affLevelReward.length--];&#13;
  }&#13;
&#13;
  function affLevelsCount() external view returns (uint) {&#13;
    return affLevelReward.length;&#13;
  }&#13;
&#13;
  function setVipAffiliateLevel(uint256 _level, uint256 _rewardCoins, uint256 _rewardPercent) external onlyOwner {&#13;
    require(_level &lt; vipAffLevelReward.length);&#13;
    AffiliateReward storage rew = vipAffLevelReward[_level];&#13;
    rew.coins = _rewardCoins;&#13;
    rew.percent = _rewardPercent;&#13;
  }&#13;
&#13;
  function incVipAffiliateLevel(uint256 _rewardCoins, uint256 _rewardPercent) external onlyOwner {&#13;
    vipAffLevelReward.push(AffiliateReward({coins : _rewardCoins, percent : _rewardPercent}));&#13;
  }&#13;
&#13;
  function decVipAffiliateLevel() external onlyOwner {&#13;
    delete vipAffLevelReward[vipAffLevelReward.length--];&#13;
  }&#13;
&#13;
  function vipAffLevelsCount() external view returns (uint) {&#13;
    return vipAffLevelReward.length;&#13;
  }&#13;
&#13;
  function addVipAffiliates(address[] _affiliates) external onlyOwner {&#13;
    require(_affiliates.length &gt; 0);&#13;
    for(uint256 i = 0; i &lt; _affiliates.length; i++) {&#13;
      vipAffiliates[_getAffCode(uint(_affiliates[i]))] = true;&#13;
    }&#13;
  }&#13;
&#13;
  function delVipAffiliates(address[] _affiliates) external onlyOwner {&#13;
    require(_affiliates.length &gt; 0);&#13;
    for(uint256 i = 0; i &lt; _affiliates.length; i++) {&#13;
      delete vipAffiliates[_getAffCode(uint(_affiliates[i]))];&#13;
    }&#13;
  }&#13;
&#13;
  function addStaff(address _staff, uint256 _percent) external onlyOwner {&#13;
    require(_staff != address(0) &amp;&amp; _percent &gt; 0);&#13;
    uint256 affCode = _getAffCode(uint(_staff));&#13;
    StaffReward storage sr = staffReward[affCode];&#13;
    if (!sr.exists) {&#13;
      sr.exists = true;&#13;
      sr.index = staffCount;&#13;
      staffList[staffCount++] = affCode;&#13;
    }&#13;
    sr.percent = _percent;&#13;
  }&#13;
&#13;
  function delStaff(address _staff) external onlyOwner {&#13;
    require(_staff != address(0));&#13;
    uint256 affCode = _getAffCode(uint(_staff));&#13;
    StaffReward storage sr = staffReward[affCode];&#13;
    require(sr.exists);&#13;
&#13;
    staffReward[staffList[--staffCount]].index = staffReward[affCode].index;&#13;
    staffList[staffReward[affCode].index] = staffList[staffCount];&#13;
    delete staffList[staffCount];&#13;
    delete staffReward[affCode];&#13;
  }&#13;
&#13;
  //// MARKETPLACE&#13;
&#13;
  function addItem(uint256 genes, uint256 level, uint256 price, uint256 count) external onlyService {&#13;
    items[++lastItemId] = Item({&#13;
      exists : true,&#13;
      index : marketSize,&#13;
      genes : genes,&#13;
      level : level,&#13;
      price : price,&#13;
      count : count&#13;
      });&#13;
    market[marketSize++] = lastItemId;&#13;
    emit ItemUpdate(lastItemId, genes, level,  price, count);&#13;
  }&#13;
&#13;
  function delItem(uint256 itemId) external onlyService {&#13;
    require(items[itemId].exists);&#13;
    items[market[--marketSize]].index = items[itemId].index;&#13;
    market[items[itemId].index] = market[marketSize];&#13;
    delete market[marketSize];&#13;
    delete items[itemId];&#13;
    emit ItemUpdate(itemId, 0, 0, 0, 0);&#13;
  }&#13;
&#13;
  function setPrice(uint256 itemId, uint256 price) external onlyService {&#13;
    Item memory i = items[itemId];&#13;
    require(i.exists);&#13;
    require(i.price != price);&#13;
    i.price = price;&#13;
    emit ItemUpdate(itemId, i.genes, i.level, i.price, i.count);&#13;
  }&#13;
&#13;
  function setCount(uint256 itemId, uint256 count) external onlyService {&#13;
    Item storage i = items[itemId];&#13;
    require(i.exists);&#13;
    require(i.count != count);&#13;
    i.count = count;&#13;
    emit ItemUpdate(itemId, i.genes, i.level, i.price, i.count);&#13;
  }&#13;
&#13;
  function getItem(uint256 itemId) external view returns (uint256 genes, uint256 level, uint256 price, uint256 count) {&#13;
    Item memory i = items[itemId];&#13;
    require(i.exists);&#13;
    return (i.genes, i.level, i.price, i.count);&#13;
  }&#13;
&#13;
&#13;
  //// AFFILIATE&#13;
&#13;
  function myAffiliateCode() public view returns (uint) {&#13;
    return _getAffCode(uint(msg.sender));&#13;
  }&#13;
&#13;
  function _getAffCode(uint256 _a) internal pure returns (uint) {&#13;
    return (_a ^ (_a &gt;&gt; 80)) &amp; 0xFFFFFFFFFFFFFFFFFFFF;&#13;
  }&#13;
&#13;
  function buyItem(uint256 itemId, uint256 _affCode) public payable returns (uint256 tokenId) {&#13;
    Item memory i = items[itemId];&#13;
    require(i.exists);&#13;
    require(i.count &gt; 0);&#13;
    require(msg.value == i.price);&#13;
&#13;
    //minting character&#13;
    i.count--;&#13;
    tokenId = heroes.mint(msg.sender, i.genes, i.level);&#13;
&#13;
    emit ItemUpdate(itemId, i.genes, i.level, i.price, i.count);&#13;
    emit Sold(msg.sender, tokenId, itemId, i.genes, i.level, i.price);&#13;
&#13;
    // fetch player code&#13;
    uint256 _pCode = _getAffCode(uint(msg.sender));&#13;
    Affiliate storage p = affiliates[_pCode];&#13;
&#13;
    //check if it was 1st buy&#13;
    if (!p.active) {&#13;
      p.active = true;&#13;
    }&#13;
&#13;
    // manage affiliate residuals&#13;
&#13;
    // if affiliate code was given and player not tried to use their own, lolz&#13;
    // and its not the same as previously stored&#13;
    if (_affCode != 0 &amp;&amp; _affCode != _pCode &amp;&amp; _affCode != p.affCode) {&#13;
        // update last affiliate&#13;
        p.affCode = _affCode;&#13;
    }&#13;
&#13;
    //referral reward&#13;
    _distributeAffiliateReward(i.price, _pCode, 0);&#13;
&#13;
    //staff reward&#13;
    _distributeStaffReward(i.price, _pCode);&#13;
&#13;
    _flushBalance();&#13;
  }&#13;
&#13;
  function _distributeAffiliateReward(uint256 _sum, uint256 _affCode, uint256 _level) internal {&#13;
    Affiliate storage aff = affiliates[_affCode];&#13;
    AffiliateReward storage ar = vipAffiliates[_affCode] ? vipAffLevelReward[_level] : affLevelReward[_level];&#13;
    if (ar.coins &gt; 0) {&#13;
      aff.coinsToMint = aff.coinsToMint.add(ar.coins);&#13;
      emit CoinReward(_affCode, ar.coins);&#13;
    }&#13;
    if (ar.percent &gt; 0) {&#13;
      uint256 pcnt = _getPercent(_sum, ar.percent);&#13;
      aff.ethToSend = aff.ethToSend.add(pcnt);&#13;
      totalReserved = totalReserved.add(pcnt);&#13;
      emit EthReward(_affCode, pcnt);&#13;
    }&#13;
    if (++_level &lt; affLevelReward.length &amp;&amp; aff.affCode != 0) {&#13;
      _distributeAffiliateReward(_sum, aff.affCode, _level);&#13;
    }&#13;
  }&#13;
&#13;
  //be aware of big number of staff - huge gas!&#13;
  function _distributeStaffReward(uint256 _sum, uint256 _affCode) internal {&#13;
    for (uint256 i = 0; i &lt; staffCount; i++) {&#13;
      if (_affCode != staffList[i]) {&#13;
        Affiliate storage aff = affiliates[staffList[i]];&#13;
        StaffReward memory sr = staffReward[staffList[i]];&#13;
        if (sr.coins &gt; 0) {&#13;
          aff.coinsToMint = aff.coinsToMint.add(sr.coins);&#13;
          emit CoinReward(_affCode, sr.coins);&#13;
        }&#13;
        if (sr.percent &gt; 0) {&#13;
          uint256 pcnt = _getPercent(_sum, sr.percent);&#13;
          aff.ethToSend = aff.ethToSend.add(pcnt);&#13;
          totalReserved = totalReserved.add(pcnt);&#13;
          emit EthReward(_affCode, pcnt);&#13;
        }&#13;
      }&#13;
    }&#13;
  }&#13;
&#13;
  //player can take all rewards after 1st buy of item when he became active&#13;
  function getReward() external nonReentrant {&#13;
    // fetch player code&#13;
    uint256 _pCode = _getAffCode(uint(msg.sender));&#13;
    Affiliate storage p = affiliates[_pCode];&#13;
    require(p.active);&#13;
&#13;
    //minting coins&#13;
    if (p.coinsToMint &gt; 0) {&#13;
      require(coin.mint(msg.sender, p.coinsToMint));&#13;
      p.coinsMinted = p.coinsMinted.add(p.coinsToMint);&#13;
      emit CoinRewardGet(_pCode, p.coinsToMint);&#13;
      p.coinsToMint = 0;&#13;
    }&#13;
    //sending eth&#13;
    if (p.ethToSend &gt; 0) {&#13;
      msg.sender.transfer(p.ethToSend);&#13;
      p.ethSent = p.ethSent.add(p.ethToSend);&#13;
      totalReserved = totalReserved.sub(p.ethToSend);&#13;
      emit EthRewardGet(_pCode, p.ethToSend);&#13;
      p.ethToSend = 0;&#13;
    }&#13;
  }&#13;
&#13;
  //// SERVICE&#13;
  //1% - 100, 10% - 1000 50% - 5000&#13;
  function _getPercent(uint256 _v, uint256 _p) internal pure returns (uint)    {&#13;
    return _v.mul(_p).div(10000);&#13;
  }&#13;
}