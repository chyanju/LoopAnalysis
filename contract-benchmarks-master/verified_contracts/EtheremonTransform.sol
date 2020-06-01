pragma solidity ^0.4.16;

// copyright <a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="187b77766c797b6c585d6c707d6a7d757776367b7775">[email protected]</a>&#13;
&#13;
contract SafeMath {&#13;
&#13;
    /* function assert(bool assertion) internal { */&#13;
    /*   if (!assertion) { */&#13;
    /*     throw; */&#13;
    /*   } */&#13;
    /* }      // assert no longer needed once solidity is on 0.4.10 */&#13;
&#13;
    function safeAdd(uint256 x, uint256 y) pure internal returns(uint256) {&#13;
      uint256 z = x + y;&#13;
      assert((z &gt;= x) &amp;&amp; (z &gt;= y));&#13;
      return z;&#13;
    }&#13;
&#13;
    function safeSubtract(uint256 x, uint256 y) pure internal returns(uint256) {&#13;
      assert(x &gt;= y);&#13;
      uint256 z = x - y;&#13;
      return z;&#13;
    }&#13;
&#13;
    function safeMult(uint256 x, uint256 y) pure internal returns(uint256) {&#13;
      uint256 z = x * y;&#13;
      assert((x == 0)||(z/x == y));&#13;
      return z;&#13;
    }&#13;
&#13;
}&#13;
&#13;
contract BasicAccessControl {&#13;
    address public owner;&#13;
    // address[] public moderators;&#13;
    uint16 public totalModerators = 0;&#13;
    mapping (address =&gt; bool) public moderators;&#13;
    bool public isMaintaining = true;&#13;
&#13;
    function BasicAccessControl() public {&#13;
        owner = msg.sender;&#13;
    }&#13;
&#13;
    modifier onlyOwner {&#13;
        require(msg.sender == owner);&#13;
        _;&#13;
    }&#13;
&#13;
    modifier onlyModerators() {&#13;
        require(msg.sender == owner || moderators[msg.sender] == true);&#13;
        _;&#13;
    }&#13;
&#13;
    modifier isActive {&#13;
        require(!isMaintaining);&#13;
        _;&#13;
    }&#13;
&#13;
    function ChangeOwner(address _newOwner) onlyOwner public {&#13;
        if (_newOwner != address(0)) {&#13;
            owner = _newOwner;&#13;
        }&#13;
    }&#13;
&#13;
&#13;
    function AddModerator(address _newModerator) onlyOwner public {&#13;
        if (moderators[_newModerator] == false) {&#13;
            moderators[_newModerator] = true;&#13;
            totalModerators += 1;&#13;
        }&#13;
    }&#13;
    &#13;
    function RemoveModerator(address _oldModerator) onlyOwner public {&#13;
        if (moderators[_oldModerator] == true) {&#13;
            moderators[_oldModerator] = false;&#13;
            totalModerators -= 1;&#13;
        }&#13;
    }&#13;
&#13;
    function UpdateMaintaining(bool _isMaintaining) onlyOwner public {&#13;
        isMaintaining = _isMaintaining;&#13;
    }&#13;
}&#13;
&#13;
contract EtheremonEnum {&#13;
&#13;
    enum ResultCode {&#13;
        SUCCESS,&#13;
        ERROR_CLASS_NOT_FOUND,&#13;
        ERROR_LOW_BALANCE,&#13;
        ERROR_SEND_FAIL,&#13;
        ERROR_NOT_TRAINER,&#13;
        ERROR_NOT_ENOUGH_MONEY,&#13;
        ERROR_INVALID_AMOUNT,&#13;
        ERROR_OBJ_NOT_FOUND,&#13;
        ERROR_OBJ_INVALID_OWNERSHIP&#13;
    }&#13;
    &#13;
    enum ArrayType {&#13;
        CLASS_TYPE,&#13;
        STAT_STEP,&#13;
        STAT_START,&#13;
        STAT_BASE,&#13;
        OBJ_SKILL&#13;
    }&#13;
    &#13;
    enum PropertyType {&#13;
        ANCESTOR,&#13;
        XFACTOR&#13;
    }&#13;
}&#13;
&#13;
contract EtheremonDataBase is EtheremonEnum, BasicAccessControl, SafeMath {&#13;
    &#13;
    uint64 public totalMonster;&#13;
    uint32 public totalClass;&#13;
    &#13;
    // write&#13;
    function addElementToArrayType(ArrayType _type, uint64 _id, uint8 _value) onlyModerators public returns(uint);&#13;
    function removeElementOfArrayType(ArrayType _type, uint64 _id, uint8 _value) onlyModerators public returns(uint);&#13;
    function setMonsterClass(uint32 _classId, uint256 _price, uint256 _returnPrice, bool _catchable) onlyModerators public returns(uint32);&#13;
    function addMonsterObj(uint32 _classId, address _trainer, string _name) onlyModerators public returns(uint64);&#13;
    function setMonsterObj(uint64 _objId, string _name, uint32 _exp, uint32 _createIndex, uint32 _lastClaimIndex) onlyModerators public;&#13;
    function increaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;&#13;
    function decreaseMonsterExp(uint64 _objId, uint32 amount) onlyModerators public;&#13;
    function removeMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public;&#13;
    function addMonsterIdMapping(address _trainer, uint64 _monsterId) onlyModerators public;&#13;
    function clearMonsterReturnBalance(uint64 _monsterId) onlyModerators public returns(uint256 amount);&#13;
    function collectAllReturnBalance(address _trainer) onlyModerators public returns(uint256 amount);&#13;
    function transferMonster(address _from, address _to, uint64 _monsterId) onlyModerators public returns(ResultCode);&#13;
    function addExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256);&#13;
    function deductExtraBalance(address _trainer, uint256 _amount) onlyModerators public returns(uint256);&#13;
    function setExtraBalance(address _trainer, uint256 _amount) onlyModerators public;&#13;
    &#13;
    // read&#13;
    function getSizeArrayType(ArrayType _type, uint64 _id) constant public returns(uint);&#13;
    function getElementInArrayType(ArrayType _type, uint64 _id, uint _index) constant public returns(uint8);&#13;
    function getMonsterClass(uint32 _classId) constant public returns(uint32 classId, uint256 price, uint256 returnPrice, uint32 total, bool catchable);&#13;
    function getMonsterObj(uint64 _objId) constant public returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime);&#13;
    function getMonsterName(uint64 _objId) constant public returns(string name);&#13;
    function getExtraBalance(address _trainer) constant public returns(uint256);&#13;
    function getMonsterDexSize(address _trainer) constant public returns(uint);&#13;
    function getMonsterObjId(address _trainer, uint index) constant public returns(uint64);&#13;
    function getExpectedBalance(address _trainer) constant public returns(uint256);&#13;
    function getMonsterReturn(uint64 _objId) constant public returns(uint256 current, uint256 total);&#13;
}&#13;
&#13;
contract EtheremonTransformData {&#13;
    uint64 public totalEgg = 0;&#13;
    function getHatchingEggId(address _trainer) constant external returns(uint64);&#13;
    function getHatchingEggData(address _trainer) constant external returns(uint64, uint64, uint32, address, uint, uint64);&#13;
    function getTranformedId(uint64 _objId) constant external returns(uint64);&#13;
    function countEgg(uint64 _objId) constant external returns(uint);&#13;
    &#13;
    function setHatchTime(uint64 _eggId, uint _hatchTime) external;&#13;
    function setHatchedEgg(uint64 _eggId, uint64 _newObjId) external;&#13;
    function addEgg(uint64 _objId, uint32 _classId, address _trainer, uint _hatchTime) external returns(uint64);&#13;
    function setTranformed(uint64 _objId, uint64 _newObjId) external;&#13;
}&#13;
&#13;
contract EtheremonWorld is EtheremonEnum {&#13;
    &#13;
    function getGen0COnfig(uint32 _classId) constant public returns(uint32, uint256, uint32);&#13;
    function getTrainerEarn(address _trainer) constant public returns(uint256);&#13;
    function getReturnFromMonster(uint64 _objId) constant public returns(uint256 current, uint256 total);&#13;
    function getClassPropertyValue(uint32 _classId, PropertyType _type, uint index) constant external returns(uint32);&#13;
    function getClassPropertySize(uint32 _classId, PropertyType _type) constant external returns(uint);&#13;
}&#13;
&#13;
interface EtheremonBattle {&#13;
    function isOnBattle(uint64 _objId) constant external returns(bool);&#13;
    function getMonsterLevel(uint64 _objId) constant public returns(uint8);&#13;
}&#13;
&#13;
interface EtheremonTradeInterface {&#13;
    function isOnTrading(uint64 _objId) constant external returns(bool);&#13;
}&#13;
&#13;
contract EtheremonTransform is EtheremonEnum, BasicAccessControl, SafeMath {&#13;
    uint8 constant public STAT_COUNT = 6;&#13;
    uint8 constant public STAT_MAX = 32;&#13;
    uint8 constant public GEN0_NO = 24;&#13;
    &#13;
    struct MonsterClassAcc {&#13;
        uint32 classId;&#13;
        uint256 price;&#13;
        uint256 returnPrice;&#13;
        uint32 total;&#13;
        bool catchable;&#13;
    }&#13;
&#13;
    struct MonsterObjAcc {&#13;
        uint64 monsterId;&#13;
        uint32 classId;&#13;
        address trainer;&#13;
        string name;&#13;
        uint32 exp;&#13;
        uint32 createIndex;&#13;
        uint32 lastClaimIndex;&#13;
        uint createTime;&#13;
    }&#13;
    &#13;
    struct MonsterEgg {&#13;
        uint64 eggId;&#13;
        uint64 objId;&#13;
        uint32 classId;&#13;
        address trainer;&#13;
        uint hatchTime;&#13;
        uint64 newObjId;&#13;
    }&#13;
    &#13;
    struct BasicObjInfo {&#13;
        uint32 classId;&#13;
        address owner;&#13;
        uint8 level;&#13;
    }&#13;
    &#13;
    // Gen0 has return price &amp; no longer can be caught when this contract is deployed&#13;
    struct Gen0Config {&#13;
        uint32 classId;&#13;
        uint256 originalPrice;&#13;
        uint256 returnPrice;&#13;
        uint32 total; // total caught (not count those from eggs)&#13;
    }&#13;
    &#13;
    // hatching range&#13;
    uint16 public hatchStartTime = 2; // hour&#13;
    uint16 public hatchMaxTime = 46; // hour&#13;
    uint public removeHatchingTimeFee = 0.05 ether; // ETH&#13;
    uint public buyEggFee = 0.06 ether; // ETH&#13;
    &#13;
    uint32[] public randomClassIds;&#13;
    mapping(uint32 =&gt; uint8) public layingEggLevels;&#13;
    mapping(uint32 =&gt; uint8) public layingEggDeductions;&#13;
    mapping(uint32 =&gt; uint8) public transformLevels;&#13;
    mapping(uint32 =&gt; uint32) public transformClasses;&#13;
&#13;
    mapping(uint8 =&gt; uint32) public levelExps;&#13;
    address private lastHatchingAddress;&#13;
    &#13;
    mapping(uint32 =&gt; Gen0Config) public gen0Config;&#13;
    &#13;
    // linked smart contract&#13;
    address public dataContract;&#13;
    address public worldContract;&#13;
    address public transformDataContract;&#13;
    address public battleContract;&#13;
    address public tradeContract;&#13;
    &#13;
    // events&#13;
    event EventLayEgg(address indexed trainer, uint64 objId, uint64 eggId);&#13;
    event EventHatchEgg(address indexed trainer, uint64 eggId, uint64 objId);&#13;
    event EventTransform(address indexed trainer, uint64 oldObjId, uint64 newObjId);&#13;
    event EventRelease(address indexed trainer, uint64 objId);&#13;
    &#13;
    // modifier&#13;
    &#13;
    modifier requireDataContract {&#13;
        require(dataContract != address(0));&#13;
        _;&#13;
    }&#13;
    &#13;
    modifier requireTransformDataContract {&#13;
        require(transformDataContract != address(0));&#13;
        _;&#13;
    }&#13;
    &#13;
    modifier requireBattleContract {&#13;
        require(battleContract != address(0));&#13;
        _;&#13;
    }&#13;
    &#13;
    modifier requireTradeContract {&#13;
        require(tradeContract != address(0));&#13;
        _;        &#13;
    }&#13;
    &#13;
    &#13;
    // constructor&#13;
    function EtheremonTransform(address _dataContract, address _worldContract, address _transformDataContract, address _battleContract, address _tradeContract) public {&#13;
        dataContract = _dataContract;&#13;
        worldContract = _worldContract;&#13;
        transformDataContract = _transformDataContract;&#13;
        battleContract = _battleContract;&#13;
        tradeContract = _tradeContract;&#13;
    }&#13;
    &#13;
    // helper&#13;
    function getRandom(uint16 maxRan, uint8 index, address priAddress) constant public returns(uint8) {&#13;
        uint256 genNum = uint256(block.blockhash(block.number-1)) + uint256(priAddress);&#13;
        for (uint8 i = 0; i &lt; index &amp;&amp; i &lt; 6; i ++) {&#13;
            genNum /= 256;&#13;
        }&#13;
        return uint8(genNum % maxRan);&#13;
    }&#13;
    &#13;
    function addNewObj(address _trainer, uint32 _classId) private returns(uint64) {&#13;
        EtheremonDataBase data = EtheremonDataBase(dataContract);&#13;
        uint64 objId = data.addMonsterObj(_classId, _trainer, "..name me...");&#13;
        for (uint i=0; i &lt; STAT_COUNT; i+= 1) {&#13;
            uint8 value = getRandom(STAT_MAX, uint8(i), lastHatchingAddress) + data.getElementInArrayType(ArrayType.STAT_START, uint64(_classId), i);&#13;
            data.addElementToArrayType(ArrayType.STAT_BASE, objId, value);&#13;
        }&#13;
        return objId;&#13;
    }&#13;
    &#13;
    // admin &amp; moderators&#13;
    function setContract(address _dataContract, address _worldContract, address _transformDataContract, address _battleContract, address _tradeContract) onlyModerators external {&#13;
        dataContract = _dataContract;&#13;
        worldContract = _worldContract;&#13;
        transformDataContract = _transformDataContract;&#13;
        battleContract = _battleContract;&#13;
        tradeContract = _tradeContract;&#13;
    }&#13;
&#13;
    function setOriginalPriceGen0() onlyModerators external {&#13;
        gen0Config[1] = Gen0Config(1, 0.3 ether, 0.003 ether, 374);&#13;
        gen0Config[2] = Gen0Config(2, 0.3 ether, 0.003 ether, 408);&#13;
        gen0Config[3] = Gen0Config(3, 0.3 ether, 0.003 ether, 373);&#13;
        gen0Config[4] = Gen0Config(4, 0.2 ether, 0.002 ether, 437);&#13;
        gen0Config[5] = Gen0Config(5, 0.1 ether, 0.001 ether, 497);&#13;
        gen0Config[6] = Gen0Config(6, 0.3 ether, 0.003 ether, 380); &#13;
        gen0Config[7] = Gen0Config(7, 0.2 ether, 0.002 ether, 345);&#13;
        gen0Config[8] = Gen0Config(8, 0.1 ether, 0.001 ether, 518); &#13;
        gen0Config[9] = Gen0Config(9, 0.1 ether, 0.001 ether, 447);&#13;
        gen0Config[10] = Gen0Config(10, 0.2 ether, 0.002 ether, 380); &#13;
        gen0Config[11] = Gen0Config(11, 0.2 ether, 0.002 ether, 354);&#13;
        gen0Config[12] = Gen0Config(12, 0.2 ether, 0.002 ether, 346);&#13;
        gen0Config[13] = Gen0Config(13, 0.2 ether, 0.002 ether, 351); &#13;
        gen0Config[14] = Gen0Config(14, 0.2 ether, 0.002 ether, 338);&#13;
        gen0Config[15] = Gen0Config(15, 0.2 ether, 0.002 ether, 341);&#13;
        gen0Config[16] = Gen0Config(16, 0.35 ether, 0.0035 ether, 384);&#13;
        gen0Config[17] = Gen0Config(17, 1 ether, 0.01 ether, 305); &#13;
        gen0Config[18] = Gen0Config(18, 0.1 ether, 0.001 ether, 427);&#13;
        gen0Config[19] = Gen0Config(19, 1 ether, 0.01 ether, 304);&#13;
        gen0Config[20] = Gen0Config(20, 0.4 ether, 0.05 ether, 82);&#13;
        gen0Config[21] = Gen0Config(21, 1, 1, 123);&#13;
        gen0Config[22] = Gen0Config(22, 0.2 ether, 0.001 ether, 468);&#13;
        gen0Config[23] = Gen0Config(23, 0.5 ether, 0.0025 ether, 302);&#13;
        gen0Config[24] = Gen0Config(24, 1 ether, 0.005 ether, 195);&#13;
    }    &#13;
&#13;
    function updateHatchingRange(uint16 _start, uint16 _max) onlyModerators external {&#13;
        hatchStartTime = _start;&#13;
        hatchMaxTime = _max;&#13;
    }&#13;
&#13;
    function withdrawEther(address _sendTo, uint _amount) onlyModerators external {&#13;
        // no user money is kept in this contract, only trasaction fee&#13;
        if (_amount &gt; this.balance) {&#13;
            revert();&#13;
        }&#13;
        _sendTo.transfer(_amount);&#13;
    }&#13;
&#13;
    function setConfigClass(uint32 _classId, uint8 _layingLevel, uint8 _layingCost, uint8 _transformLevel, uint32 _tranformClass) onlyModerators external {&#13;
        layingEggLevels[_classId] = _layingLevel;&#13;
        layingEggDeductions[_classId] = _layingCost;&#13;
        transformLevels[_classId] = _transformLevel;&#13;
        transformClasses[_classId] = _tranformClass;&#13;
    }&#13;
    &#13;
    function setConfig(uint _removeHatchingTimeFee, uint _buyEggFee) onlyModerators external {&#13;
        removeHatchingTimeFee = _removeHatchingTimeFee;&#13;
        buyEggFee = _buyEggFee;&#13;
    }&#13;
&#13;
    function genLevelExp() onlyModerators external {&#13;
        uint8 level = 1;&#13;
        uint32 requirement = 100;&#13;
        uint32 sum = requirement;&#13;
        while(level &lt;= 100) {&#13;
            levelExps[level] = sum;&#13;
            level += 1;&#13;
            requirement = (requirement * 11) / 10 + 5;&#13;
            sum += requirement;&#13;
        }&#13;
    }&#13;
    &#13;
    function addRandomClass(uint32 _newClassId) onlyModerators public {&#13;
        if (_newClassId &gt; 0) {&#13;
            for (uint index = 0; index &lt; randomClassIds.length; index++) {&#13;
                if (randomClassIds[index] == _newClassId) {&#13;
                    return;&#13;
                }&#13;
            }&#13;
            randomClassIds.push(_newClassId);&#13;
        }&#13;
    }&#13;
    &#13;
    function removeRandomClass(uint32 _oldClassId) onlyModerators public {&#13;
        uint foundIndex = 0;&#13;
        for (; foundIndex &lt; randomClassIds.length; foundIndex++) {&#13;
            if (randomClassIds[foundIndex] == _oldClassId) {&#13;
                break;&#13;
            }&#13;
        }&#13;
        if (foundIndex &lt; randomClassIds.length) {&#13;
            randomClassIds[foundIndex] = randomClassIds[randomClassIds.length-1];&#13;
            delete randomClassIds[randomClassIds.length-1];&#13;
            randomClassIds.length--;&#13;
        }&#13;
    }&#13;
    &#13;
    function removeHatchingTimeWithToken(address _trainer) isActive onlyModerators requireDataContract requireTransformDataContract external {&#13;
        EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);&#13;
        MonsterEgg memory egg;&#13;
        (egg.eggId, egg.objId, egg.classId, egg.trainer, egg.hatchTime, egg.newObjId) = transformData.getHatchingEggData(_trainer);&#13;
        // not hatching any egg&#13;
        if (egg.eggId == 0 || egg.trainer != _trainer || egg.newObjId &gt; 0)&#13;
            revert();&#13;
        &#13;
        transformData.setHatchTime(egg.eggId, 0);&#13;
    }    &#13;
    &#13;
    function buyEggWithToken(address _trainer) isActive onlyModerators requireDataContract requireTransformDataContract external {&#13;
        if (randomClassIds.length == 0) {&#13;
            revert();&#13;
        }&#13;
        &#13;
        EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);&#13;
        // make sure no hatching egg at the same time&#13;
        if (transformData.getHatchingEggId(_trainer) &gt; 0) {&#13;
            revert();&#13;
        }&#13;
&#13;
        // add random egg&#13;
        uint8 classIndex = getRandom(uint16(randomClassIds.length), 1, lastHatchingAddress);&#13;
        uint64 eggId = transformData.addEgg(0, randomClassIds[classIndex], _trainer, block.timestamp + (hatchStartTime + getRandom(hatchMaxTime, 0, lastHatchingAddress)) * 3600);&#13;
        // deduct exp&#13;
        EventLayEgg(msg.sender, 0, eggId);&#13;
    }&#13;
    &#13;
    // public&#13;
&#13;
    function ceil(uint a, uint m) pure public returns (uint) {&#13;
        return ((a + m - 1) / m) * m;&#13;
    }&#13;
&#13;
    function getLevel(uint32 exp) view public returns (uint8) {&#13;
        uint8 minIndex = 1;&#13;
        uint8 maxIndex = 100;&#13;
        uint8 currentIndex;&#13;
     &#13;
        while (minIndex &lt; maxIndex) {&#13;
            currentIndex = (minIndex + maxIndex) / 2;&#13;
            if (exp &lt; levelExps[currentIndex])&#13;
                maxIndex = currentIndex;&#13;
            else&#13;
                minIndex = currentIndex + 1;&#13;
        }&#13;
&#13;
        return minIndex;&#13;
    }&#13;
&#13;
    function getGen0ObjInfo(uint64 _objId) constant public returns(uint32, uint32, uint256) {&#13;
        EtheremonDataBase data = EtheremonDataBase(dataContract);&#13;
        &#13;
        MonsterObjAcc memory obj;&#13;
        (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);&#13;
        &#13;
        Gen0Config memory gen0 = gen0Config[obj.classId];&#13;
        if (gen0.classId != obj.classId) {&#13;
            return (gen0.classId, obj.createIndex, 0);&#13;
        }&#13;
        &#13;
        uint32 totalGap = 0;&#13;
        if (obj.createIndex &lt; gen0.total)&#13;
            totalGap = gen0.total - obj.createIndex;&#13;
        &#13;
        return (obj.classId, obj.createIndex, safeMult(totalGap, gen0.returnPrice));&#13;
    }&#13;
    &#13;
    function getObjClassId(uint64 _objId) requireDataContract constant public returns(uint32, address, uint8) {&#13;
        EtheremonDataBase data = EtheremonDataBase(dataContract);&#13;
        MonsterObjAcc memory obj;&#13;
        uint32 _ = 0;&#13;
        (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);&#13;
        return (obj.classId, obj.trainer, getLevel(obj.exp));&#13;
    }&#13;
    &#13;
    function getClassCheckOwner(uint64 _objId, address _trainer) requireDataContract constant public returns(uint32) {&#13;
        EtheremonDataBase data = EtheremonDataBase(dataContract);&#13;
        MonsterObjAcc memory obj;&#13;
        uint32 _ = 0;&#13;
        (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);&#13;
        if (_trainer != obj.trainer)&#13;
            return 0;&#13;
        return obj.classId;&#13;
    }&#13;
&#13;
    function calculateMaxEggG0(uint64 _objId) constant public returns(uint) {&#13;
        uint32 classId;&#13;
        uint32 createIndex; &#13;
        uint256 totalEarn;&#13;
        (classId, createIndex, totalEarn) = getGen0ObjInfo(_objId);&#13;
        if (classId &gt; GEN0_NO || classId == 20 || classId == 21)&#13;
            return 0;&#13;
        &#13;
        Gen0Config memory config = gen0Config[classId];&#13;
        // the one from egg can not lay&#13;
        if (createIndex &gt; config.total)&#13;
            return 0;&#13;
&#13;
        // calculate agv price&#13;
        uint256 avgPrice = config.originalPrice;&#13;
        uint rate = config.originalPrice/config.returnPrice;&#13;
        if (config.total &gt; rate) {&#13;
            uint k = config.total - rate;&#13;
            avgPrice = (config.total * config.originalPrice + config.returnPrice * k * (k+1) / 2) / config.total;&#13;
        }&#13;
        uint256 catchPrice = config.originalPrice;            &#13;
        if (createIndex &gt; rate) {&#13;
            catchPrice += config.returnPrice * safeSubtract(createIndex, rate);&#13;
        }&#13;
        if (totalEarn &gt;= catchPrice) {&#13;
            return 0;&#13;
        }&#13;
        return ceil((catchPrice - totalEarn)*15*1000/avgPrice, 10000)/10000;&#13;
    }&#13;
    &#13;
    function canLayEgg(uint64 _objId, uint32 _classId, uint32 _level) constant public returns(bool) {&#13;
        if (_classId &lt;= GEN0_NO) {&#13;
            EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);&#13;
            // legends&#13;
            if (transformData.countEgg(_objId) &gt;= calculateMaxEggG0(_objId))&#13;
                return false;&#13;
            return true;&#13;
        } else {&#13;
            if (layingEggLevels[_classId] == 0 || _level &lt; layingEggLevels[_classId])&#13;
                return false;&#13;
            return true;&#13;
        }&#13;
    }&#13;
    &#13;
    function layEgg(uint64 _objId) isActive requireDataContract requireTransformDataContract external {&#13;
        EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);&#13;
        // make sure no hatching egg at the same time&#13;
        if (transformData.getHatchingEggId(msg.sender) &gt; 0) {&#13;
            revert();&#13;
        }&#13;
        &#13;
        // check obj &#13;
        EtheremonDataBase data = EtheremonDataBase(dataContract);&#13;
        MonsterObjAcc memory obj;&#13;
        uint32 _ = 0;&#13;
        (obj.monsterId, obj.classId, obj.trainer, obj.exp, _, _, obj.createTime) = data.getMonsterObj(_objId);&#13;
        if (obj.monsterId != _objId || obj.trainer != msg.sender) {&#13;
            revert();&#13;
        }&#13;
        &#13;
        // check lay egg condition&#13;
        uint8 currentLevel = getLevel(obj.exp);&#13;
        uint8 afterLevel = 0;&#13;
        if (!canLayEgg(_objId, obj.classId, currentLevel))&#13;
            revert();&#13;
        if (layingEggDeductions[obj.classId] &gt;= currentLevel)&#13;
            revert();&#13;
        afterLevel = currentLevel - layingEggDeductions[obj.classId];&#13;
&#13;
        // add egg &#13;
        uint64 eggId = transformData.addEgg(obj.monsterId, obj.classId, msg.sender, block.timestamp + (hatchStartTime + getRandom(hatchMaxTime, 0, lastHatchingAddress)) * 3600);&#13;
        &#13;
        // deduct exp &#13;
        if (afterLevel &lt; currentLevel)&#13;
            data.decreaseMonsterExp(_objId, obj.exp - levelExps[afterLevel-1]);&#13;
        EventLayEgg(msg.sender, _objId, eggId);&#13;
    }&#13;
    &#13;
    function hatchEgg() isActive requireDataContract requireTransformDataContract external {&#13;
        // use as a seed for random&#13;
        lastHatchingAddress = msg.sender;&#13;
        &#13;
        EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);&#13;
        MonsterEgg memory egg;&#13;
        (egg.eggId, egg.objId, egg.classId, egg.trainer, egg.hatchTime, egg.newObjId) = transformData.getHatchingEggData(msg.sender);&#13;
        // not hatching any egg&#13;
        if (egg.eggId == 0 || egg.trainer != msg.sender)&#13;
            revert();&#13;
        // need more time&#13;
        if (egg.newObjId &gt; 0 || egg.hatchTime &gt; block.timestamp) {&#13;
            revert();&#13;
        }&#13;
        &#13;
        uint64 objId = addNewObj(msg.sender, egg.classId);&#13;
        transformData.setHatchedEgg(egg.eggId, objId);&#13;
        EventHatchEgg(msg.sender, egg.eggId, objId);&#13;
    }&#13;
    &#13;
    function removeHatchingTime() isActive requireDataContract requireTransformDataContract external payable  {&#13;
        EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);&#13;
        MonsterEgg memory egg;&#13;
        (egg.eggId, egg.objId, egg.classId, egg.trainer, egg.hatchTime, egg.newObjId) = transformData.getHatchingEggData(msg.sender);&#13;
        // not hatching any egg&#13;
        if (egg.eggId == 0 || egg.trainer != msg.sender || egg.newObjId &gt; 0)&#13;
            revert();&#13;
        &#13;
        if (msg.value != removeHatchingTimeFee) {&#13;
            revert();&#13;
        }&#13;
        transformData.setHatchTime(egg.eggId, 0);&#13;
    }&#13;
&#13;
    &#13;
    function checkAncestors(uint32 _classId, address _trainer, uint64 _a1, uint64 _a2, uint64 _a3) constant public returns(bool) {&#13;
        EtheremonWorld world = EtheremonWorld(worldContract);&#13;
        uint index = 0;&#13;
        uint32 temp = 0;&#13;
        // check ancestor&#13;
        uint32[3] memory ancestors;&#13;
        uint32[3] memory requestAncestors;&#13;
        index = world.getClassPropertySize(_classId, PropertyType.ANCESTOR);&#13;
        while (index &gt; 0) {&#13;
            index -= 1;&#13;
            ancestors[index] = world.getClassPropertyValue(_classId, PropertyType.ANCESTOR, index);&#13;
        }&#13;
            &#13;
        if (_a1 &gt; 0) {&#13;
            temp = getClassCheckOwner(_a1, _trainer);&#13;
            if (temp == 0)&#13;
                return false;&#13;
            requestAncestors[0] = temp;&#13;
        }&#13;
        if (_a2 &gt; 0) {&#13;
            temp = getClassCheckOwner(_a2, _trainer);&#13;
            if (temp == 0)&#13;
                return false;&#13;
            requestAncestors[1] = temp;&#13;
        }&#13;
        if (_a3 &gt; 0) {&#13;
            temp = getClassCheckOwner(_a3, _trainer);&#13;
            if (temp == 0)&#13;
                return false;&#13;
            requestAncestors[2] = temp;&#13;
        }&#13;
            &#13;
        if (requestAncestors[0] &gt; 0 &amp;&amp; (requestAncestors[0] == requestAncestors[1] || requestAncestors[0] == requestAncestors[2]))&#13;
            return false;&#13;
        if (requestAncestors[1] &gt; 0 &amp;&amp; (requestAncestors[1] == requestAncestors[2]))&#13;
            return false;&#13;
                &#13;
        for (index = 0; index &lt; ancestors.length; index++) {&#13;
            temp = ancestors[index];&#13;
            if (temp &gt; 0 &amp;&amp; temp != requestAncestors[0]  &amp;&amp; temp != requestAncestors[1] &amp;&amp; temp != requestAncestors[2])&#13;
                return false;&#13;
        }&#13;
        &#13;
        return true;&#13;
    }&#13;
    &#13;
    function transform(uint64 _objId, uint64 _a1, uint64 _a2, uint64 _a3) isActive requireDataContract requireTransformDataContract external payable {&#13;
        EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);&#13;
        if (transformData.getTranformedId(_objId) &gt; 0)&#13;
            revert();&#13;
        &#13;
        EtheremonBattle battle = EtheremonBattle(battleContract);&#13;
        EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);&#13;
        if (battle.isOnBattle(_objId) || trade.isOnTrading(_objId))&#13;
            revert();&#13;
        &#13;
        EtheremonDataBase data = EtheremonDataBase(dataContract);&#13;
        &#13;
        BasicObjInfo memory objInfo;&#13;
        (objInfo.classId, objInfo.owner, objInfo.level) = getObjClassId(_objId);&#13;
        uint32 transformClass = transformClasses[objInfo.classId];&#13;
        if (objInfo.classId == 0 || objInfo.owner != msg.sender)&#13;
            revert();&#13;
        if (transformLevels[objInfo.classId] == 0 || objInfo.level &lt; transformLevels[objInfo.classId])&#13;
            revert();&#13;
        if (transformClass == 0)&#13;
            revert();&#13;
        &#13;
        &#13;
        // gen0 - can not transform if it has bonus egg &#13;
        if (objInfo.classId &lt;= GEN0_NO) {&#13;
            // legends&#13;
            if (getBonusEgg(_objId) &gt; 0)&#13;
                revert();&#13;
        } else {&#13;
            if (!checkAncestors(objInfo.classId, msg.sender, _a1, _a2, _a3))&#13;
                revert();&#13;
        }&#13;
        &#13;
        uint64 newObjId = addNewObj(msg.sender, transformClass);&#13;
        // remove old one&#13;
        data.removeMonsterIdMapping(msg.sender, _objId);&#13;
        transformData.setTranformed(_objId, newObjId);&#13;
        EventTransform(msg.sender, _objId, newObjId);&#13;
    }&#13;
    &#13;
    function buyEgg() isActive requireDataContract requireTransformDataContract external payable {&#13;
        if (msg.value != buyEggFee) {&#13;
            revert();&#13;
        }&#13;
        &#13;
        if (randomClassIds.length == 0) {&#13;
            revert();&#13;
        }&#13;
        &#13;
        EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);&#13;
        // make sure no hatching egg at the same time&#13;
        if (transformData.getHatchingEggId(msg.sender) &gt; 0) {&#13;
            revert();&#13;
        }&#13;
&#13;
        // add random egg&#13;
        uint8 classIndex = getRandom(uint16(randomClassIds.length), 1, lastHatchingAddress);&#13;
        uint64 eggId = transformData.addEgg(0, randomClassIds[classIndex], msg.sender, block.timestamp + (hatchStartTime + getRandom(hatchMaxTime, 0, lastHatchingAddress)) * 3600);&#13;
        // deduct exp&#13;
        EventLayEgg(msg.sender, 0, eggId);&#13;
    }&#13;
    &#13;
    // read&#13;
    function getBonusEgg(uint64 _objId) constant public returns(uint) {&#13;
        EtheremonTransformData transformData = EtheremonTransformData(transformDataContract);&#13;
        uint totalBonusEgg = calculateMaxEggG0(_objId);&#13;
        if (totalBonusEgg &gt; 0) {&#13;
            return (totalBonusEgg - transformData.countEgg(_objId));&#13;
        }&#13;
        return 0;&#13;
    }&#13;
    &#13;
}