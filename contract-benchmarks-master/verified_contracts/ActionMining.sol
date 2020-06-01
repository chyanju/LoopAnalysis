/* ==================================================================== */
/* Copyright (c) 2018 The ether.online Project.  All rights reserved.
/* 
/* https://ether.online  The first RPG game of blockchain 
/*  
/* authors <span class="__cf_email__" data-cfemail="dfadb6bcb4b7aab1abbaadf1acb7bab19fb8b2beb6b3f1bcb0b2">[email protected]</span>   &#13;
/*         <span class="__cf_email__" data-cfemail="dfacacbaacaab1bbb6b1b89fb8b2beb6b3f1bcb0b2">[email protected]</span>            &#13;
/* ==================================================================== */&#13;
&#13;
pragma solidity ^0.4.20;&#13;
&#13;
/// @title ERC-165 Standard Interface Detection&#13;
/// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md&#13;
interface ERC165 {&#13;
    function supportsInterface(bytes4 interfaceID) external view returns (bool);&#13;
}&#13;
&#13;
/// @title ERC-721 Non-Fungible Token Standard&#13;
/// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md&#13;
contract ERC721 is ERC165 {&#13;
    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);&#13;
    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);&#13;
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);&#13;
    function balanceOf(address _owner) external view returns (uint256);&#13;
    function ownerOf(uint256 _tokenId) external view returns (address);&#13;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external;&#13;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;&#13;
    function transferFrom(address _from, address _to, uint256 _tokenId) external;&#13;
    function approve(address _approved, uint256 _tokenId) external;&#13;
    function setApprovalForAll(address _operator, bool _approved) external;&#13;
    function getApproved(uint256 _tokenId) external view returns (address);&#13;
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);&#13;
}&#13;
&#13;
/// @title ERC-721 Non-Fungible Token Standard&#13;
interface ERC721TokenReceiver {&#13;
	function onERC721Received(address _from, uint256 _tokenId, bytes data) external returns(bytes4);&#13;
}&#13;
&#13;
contract AccessAdmin {&#13;
    bool public isPaused = false;&#13;
    address public addrAdmin;  &#13;
&#13;
    event AdminTransferred(address indexed preAdmin, address indexed newAdmin);&#13;
&#13;
    function AccessAdmin() public {&#13;
        addrAdmin = msg.sender;&#13;
    }  &#13;
&#13;
&#13;
    modifier onlyAdmin() {&#13;
        require(msg.sender == addrAdmin);&#13;
        _;&#13;
    }&#13;
&#13;
    modifier whenNotPaused() {&#13;
        require(!isPaused);&#13;
        _;&#13;
    }&#13;
&#13;
    modifier whenPaused {&#13;
        require(isPaused);&#13;
        _;&#13;
    }&#13;
&#13;
    function setAdmin(address _newAdmin) external onlyAdmin {&#13;
        require(_newAdmin != address(0));&#13;
        AdminTransferred(addrAdmin, _newAdmin);&#13;
        addrAdmin = _newAdmin;&#13;
    }&#13;
&#13;
    function doPause() external onlyAdmin whenNotPaused {&#13;
        isPaused = true;&#13;
    }&#13;
&#13;
    function doUnpause() external onlyAdmin whenPaused {&#13;
        isPaused = false;&#13;
    }&#13;
}&#13;
&#13;
contract AccessService is AccessAdmin {&#13;
    address public addrService;&#13;
    address public addrFinance;&#13;
&#13;
    modifier onlyService() {&#13;
        require(msg.sender == addrService);&#13;
        _;&#13;
    }&#13;
&#13;
    modifier onlyFinance() {&#13;
        require(msg.sender == addrFinance);&#13;
        _;&#13;
    }&#13;
&#13;
    function setService(address _newService) external {&#13;
        require(msg.sender == addrService || msg.sender == addrAdmin);&#13;
        require(_newService != address(0));&#13;
        addrService = _newService;&#13;
    }&#13;
&#13;
    function setFinance(address _newFinance) external {&#13;
        require(msg.sender == addrFinance || msg.sender == addrAdmin);&#13;
        require(_newFinance != address(0));&#13;
        addrFinance = _newFinance;&#13;
    }&#13;
&#13;
    function withdraw(address _target, uint256 _amount) &#13;
        external &#13;
    {&#13;
        require(msg.sender == addrFinance || msg.sender == addrAdmin);&#13;
        require(_amount &gt; 0);&#13;
        address receiver = _target == address(0) ? addrFinance : _target;&#13;
        uint256 balance = this.balance;&#13;
        if (_amount &lt; balance) {&#13;
            receiver.transfer(_amount);&#13;
        } else {&#13;
            receiver.transfer(this.balance);&#13;
        }      &#13;
    }&#13;
}&#13;
&#13;
interface IDataMining {&#13;
    function getRecommender(address _target) external view returns(address);&#13;
    function subFreeMineral(address _target) external returns(bool);&#13;
}&#13;
&#13;
interface IDataEquip {&#13;
    function isEquiped(address _target, uint256 _tokenId) external view returns(bool);&#13;
    function isEquipedAny2(address _target, uint256 _tokenId1, uint256 _tokenId2) external view returns(bool);&#13;
    function isEquipedAny3(address _target, uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3) external view returns(bool);&#13;
}&#13;
&#13;
contract Random {&#13;
    uint256 _seed;&#13;
&#13;
    function _rand() internal returns (uint256) {&#13;
        _seed = uint256(keccak256(_seed, block.blockhash(block.number - 1), block.coinbase, block.difficulty));&#13;
        return _seed;&#13;
    }&#13;
&#13;
    function _randBySeed(uint256 _outSeed) internal view returns (uint256) {&#13;
        return uint256(keccak256(_outSeed, block.blockhash(block.number - 1), block.coinbase, block.difficulty));&#13;
    }&#13;
}&#13;
&#13;
/**&#13;
 * @title SafeMath&#13;
 * @dev Math operations with safety checks that throw on error&#13;
 */&#13;
library SafeMath {&#13;
    /**&#13;
    * @dev Multiplies two numbers, throws on overflow.&#13;
    */&#13;
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {&#13;
        if (a == 0) {&#13;
            return 0;&#13;
        }&#13;
        uint256 c = a * b;&#13;
        assert(c / a == b);&#13;
        return c;&#13;
    }&#13;
&#13;
    /**&#13;
    * @dev Integer division of two numbers, truncating the quotient.&#13;
    */&#13;
    function div(uint256 a, uint256 b) internal pure returns (uint256) {&#13;
        // assert(b &gt; 0); // Solidity automatically throws when dividing by 0&#13;
        uint256 c = a / b;&#13;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold&#13;
        return c;&#13;
    }&#13;
&#13;
    /**&#13;
    * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).&#13;
    */&#13;
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {&#13;
        assert(b &lt;= a);&#13;
        return a - b;&#13;
    }&#13;
&#13;
    /**&#13;
    * @dev Adds two numbers, throws on overflow.&#13;
    */&#13;
    function add(uint256 a, uint256 b) internal pure returns (uint256) {&#13;
        uint256 c = a + b;&#13;
        assert(c &gt;= a);&#13;
        return c;&#13;
    }&#13;
}&#13;
&#13;
contract WarToken is ERC721, AccessAdmin {&#13;
    /// @dev The equipment info&#13;
    struct Fashion {&#13;
        uint16 protoId;     // 0  Equipment ID&#13;
        uint16 quality;     // 1  Rarity: 1 Coarse/2 Good/3 Rare/4 Epic/5 Legendary&#13;
        uint16 pos;         // 2  Slots: 1 Weapon/2 Hat/3 Cloth/4 Pant/5 Shoes/9 Pets&#13;
        uint16 health;      // 3  Health&#13;
        uint16 atkMin;      // 4  Min attack&#13;
        uint16 atkMax;      // 5  Max attack&#13;
        uint16 defence;     // 6  Defennse&#13;
        uint16 crit;        // 7  Critical rate&#13;
        uint16 isPercent;   // 8  Attr value type&#13;
        uint16 attrExt1;    // 9  future stat 1&#13;
        uint16 attrExt2;    // 10 future stat 2&#13;
        uint16 attrExt3;    // 11 future stat 3&#13;
    }&#13;
&#13;
    /// @dev All equipments tokenArray (not exceeding 2^32-1)&#13;
    Fashion[] public fashionArray;&#13;
&#13;
    /// @dev Amount of tokens destroyed&#13;
    uint256 destroyFashionCount;&#13;
&#13;
    /// @dev Equipment token ID vs owner address&#13;
    mapping (uint256 =&gt; address) fashionIdToOwner;&#13;
&#13;
    /// @dev Equipments owner by the owner (array)&#13;
    mapping (address =&gt; uint256[]) ownerToFashionArray;&#13;
&#13;
    /// @dev Equipment token ID search in owner array&#13;
    mapping (uint256 =&gt; uint256) fashionIdToOwnerIndex;&#13;
&#13;
    /// @dev The authorized address for each WAR&#13;
    mapping (uint256 =&gt; address) fashionIdToApprovals;&#13;
&#13;
    /// @dev The authorized operators for each address&#13;
    mapping (address =&gt; mapping (address =&gt; bool)) operatorToApprovals;&#13;
&#13;
    /// @dev Trust contract&#13;
    mapping (address =&gt; bool) actionContracts;&#13;
&#13;
    function setActionContract(address _actionAddr, bool _useful) external onlyAdmin {&#13;
        actionContracts[_actionAddr] = _useful;&#13;
    }&#13;
&#13;
    function getActionContract(address _actionAddr) external view onlyAdmin returns(bool) {&#13;
        return actionContracts[_actionAddr];&#13;
    }&#13;
&#13;
    /// @dev This emits when the approved address for an WAR is changed or reaffirmed.&#13;
    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);&#13;
&#13;
    /// @dev This emits when an operator is enabled or disabled for an owner.&#13;
    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);&#13;
&#13;
    /// @dev This emits when the equipment ownership changed &#13;
    event Transfer(address indexed from, address indexed to, uint256 tokenId);&#13;
&#13;
    /// @dev This emits when the equipment created&#13;
    event CreateFashion(address indexed owner, uint256 tokenId, uint16 protoId, uint16 quality, uint16 pos, uint16 createType);&#13;
&#13;
    /// @dev This emits when the equipment's attributes changed&#13;
    event ChangeFashion(address indexed owner, uint256 tokenId, uint16 changeType);&#13;
&#13;
    /// @dev This emits when the equipment destroyed&#13;
    event DeleteFashion(address indexed owner, uint256 tokenId, uint16 deleteType);&#13;
    &#13;
    function WarToken() public {&#13;
        addrAdmin = msg.sender;&#13;
        fashionArray.length += 1;&#13;
    }&#13;
&#13;
    // modifier&#13;
    /// @dev Check if token ID is valid&#13;
    modifier isValidToken(uint256 _tokenId) {&#13;
        require(_tokenId &gt;= 1 &amp;&amp; _tokenId &lt;= fashionArray.length);&#13;
        require(fashionIdToOwner[_tokenId] != address(0)); &#13;
        _;&#13;
    }&#13;
&#13;
    modifier canTransfer(uint256 _tokenId) {&#13;
        address owner = fashionIdToOwner[_tokenId];&#13;
        require(msg.sender == owner || msg.sender == fashionIdToApprovals[_tokenId] || operatorToApprovals[owner][msg.sender]);&#13;
        _;&#13;
    }&#13;
&#13;
    // ERC721&#13;
    function supportsInterface(bytes4 _interfaceId) external view returns(bool) {&#13;
        // ERC165 || ERC721 || ERC165^ERC721&#13;
        return (_interfaceId == 0x01ffc9a7 || _interfaceId == 0x80ac58cd || _interfaceId == 0x8153916a) &amp;&amp; (_interfaceId != 0xffffffff);&#13;
    }&#13;
        &#13;
    function name() public pure returns(string) {&#13;
        return "WAR Token";&#13;
    }&#13;
&#13;
    function symbol() public pure returns(string) {&#13;
        return "WAR";&#13;
    }&#13;
&#13;
    /// @dev Search for token quantity address&#13;
    /// @param _owner Address that needs to be searched&#13;
    /// @return Returns token quantity&#13;
    function balanceOf(address _owner) external view returns(uint256) {&#13;
        require(_owner != address(0));&#13;
        return ownerToFashionArray[_owner].length;&#13;
    }&#13;
&#13;
    /// @dev Find the owner of an WAR&#13;
    /// @param _tokenId The tokenId of WAR&#13;
    /// @return Give The address of the owner of this WAR&#13;
    function ownerOf(uint256 _tokenId) external view /*isValidToken(_tokenId)*/ returns (address owner) {&#13;
        return fashionIdToOwner[_tokenId];&#13;
    }&#13;
&#13;
    /// @dev Transfers the ownership of an WAR from one address to another address&#13;
    /// @param _from The current owner of the WAR&#13;
    /// @param _to The new owner&#13;
    /// @param _tokenId The WAR to transfer&#13;
    /// @param data Additional data with no specified format, sent in call to `_to`&#13;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) &#13;
        external&#13;
        whenNotPaused&#13;
    {&#13;
        _safeTransferFrom(_from, _to, _tokenId, data);&#13;
    }&#13;
&#13;
    /// @dev Transfers the ownership of an WAR from one address to another address&#13;
    /// @param _from The current owner of the WAR&#13;
    /// @param _to The new owner&#13;
    /// @param _tokenId The WAR to transfer&#13;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) &#13;
        external&#13;
        whenNotPaused&#13;
    {&#13;
        _safeTransferFrom(_from, _to, _tokenId, "");&#13;
    }&#13;
&#13;
    /// @dev Transfer ownership of an WAR, '_to' must be a vaild address, or the WAR will lost&#13;
    /// @param _from The current owner of the WAR&#13;
    /// @param _to The new owner&#13;
    /// @param _tokenId The WAR to transfer&#13;
    function transferFrom(address _from, address _to, uint256 _tokenId)&#13;
        external&#13;
        whenNotPaused&#13;
        isValidToken(_tokenId)&#13;
        canTransfer(_tokenId)&#13;
    {&#13;
        address owner = fashionIdToOwner[_tokenId];&#13;
        require(owner != address(0));&#13;
        require(_to != address(0));&#13;
        require(owner == _from);&#13;
        &#13;
        _transfer(_from, _to, _tokenId);&#13;
    }&#13;
&#13;
    /// @dev Set or reaffirm the approved address for an WAR&#13;
    /// @param _approved The new approved WAR controller&#13;
    /// @param _tokenId The WAR to approve&#13;
    function approve(address _approved, uint256 _tokenId)&#13;
        external&#13;
        whenNotPaused&#13;
    {&#13;
        address owner = fashionIdToOwner[_tokenId];&#13;
        require(owner != address(0));&#13;
        require(msg.sender == owner || operatorToApprovals[owner][msg.sender]);&#13;
&#13;
        fashionIdToApprovals[_tokenId] = _approved;&#13;
        Approval(owner, _approved, _tokenId);&#13;
    }&#13;
&#13;
    /// @dev Enable or disable approval for a third party ("operator") to manage all your asset.&#13;
    /// @param _operator Address to add to the set of authorized operators.&#13;
    /// @param _approved True if the operators is approved, false to revoke approval&#13;
    function setApprovalForAll(address _operator, bool _approved) &#13;
        external &#13;
        whenNotPaused&#13;
    {&#13;
        operatorToApprovals[msg.sender][_operator] = _approved;&#13;
        ApprovalForAll(msg.sender, _operator, _approved);&#13;
    }&#13;
&#13;
    /// @dev Get the approved address for a single WAR&#13;
    /// @param _tokenId The WAR to find the approved address for&#13;
    /// @return The approved address for this WAR, or the zero address if there is none&#13;
    function getApproved(uint256 _tokenId) external view isValidToken(_tokenId) returns (address) {&#13;
        return fashionIdToApprovals[_tokenId];&#13;
    }&#13;
&#13;
    /// @dev Query if an address is an authorized operator for another address&#13;
    /// @param _owner The address that owns the WARs&#13;
    /// @param _operator The address that acts on behalf of the owner&#13;
    /// @return True if `_operator` is an approved operator for `_owner`, false otherwise&#13;
    function isApprovedForAll(address _owner, address _operator) external view returns (bool) {&#13;
        return operatorToApprovals[_owner][_operator];&#13;
    }&#13;
&#13;
    /// @dev Count WARs tracked by this contract&#13;
    /// @return A count of valid WARs tracked by this contract, where each one of&#13;
    ///  them has an assigned and queryable owner not equal to the zero address&#13;
    function totalSupply() external view returns (uint256) {&#13;
        return fashionArray.length - destroyFashionCount - 1;&#13;
    }&#13;
&#13;
    /// @dev Do the real transfer with out any condition checking&#13;
    /// @param _from The old owner of this WAR(If created: 0x0)&#13;
    /// @param _to The new owner of this WAR &#13;
    /// @param _tokenId The tokenId of the WAR&#13;
    function _transfer(address _from, address _to, uint256 _tokenId) internal {&#13;
        if (_from != address(0)) {&#13;
            uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];&#13;
            uint256[] storage fsArray = ownerToFashionArray[_from];&#13;
            require(fsArray[indexFrom] == _tokenId);&#13;
&#13;
            // If the WAR is not the element of array, change it to with the last&#13;
            if (indexFrom != fsArray.length - 1) {&#13;
                uint256 lastTokenId = fsArray[fsArray.length - 1];&#13;
                fsArray[indexFrom] = lastTokenId; &#13;
                fashionIdToOwnerIndex[lastTokenId] = indexFrom;&#13;
            }&#13;
            fsArray.length -= 1; &#13;
            &#13;
            if (fashionIdToApprovals[_tokenId] != address(0)) {&#13;
                delete fashionIdToApprovals[_tokenId];&#13;
            }      &#13;
        }&#13;
&#13;
        // Give the WAR to '_to'&#13;
        fashionIdToOwner[_tokenId] = _to;&#13;
        ownerToFashionArray[_to].push(_tokenId);&#13;
        fashionIdToOwnerIndex[_tokenId] = ownerToFashionArray[_to].length - 1;&#13;
        &#13;
        Transfer(_from != address(0) ? _from : this, _to, _tokenId);&#13;
    }&#13;
&#13;
    /// @dev Actually perform the safeTransferFrom&#13;
    function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) &#13;
        internal&#13;
        isValidToken(_tokenId) &#13;
        canTransfer(_tokenId)&#13;
    {&#13;
        address owner = fashionIdToOwner[_tokenId];&#13;
        require(owner != address(0));&#13;
        require(_to != address(0));&#13;
        require(owner == _from);&#13;
        &#13;
        _transfer(_from, _to, _tokenId);&#13;
&#13;
        // Do the callback after everything is done to avoid reentrancy attack&#13;
        uint256 codeSize;&#13;
        assembly { codeSize := extcodesize(_to) }&#13;
        if (codeSize == 0) {&#13;
            return;&#13;
        }&#13;
        bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);&#13;
        // bytes4(keccak256("onERC721Received(address,uint256,bytes)")) = 0xf0b9e5ba;&#13;
        require(retval == 0xf0b9e5ba);&#13;
    }&#13;
&#13;
    //----------------------------------------------------------------------------------------------------------&#13;
&#13;
    /// @dev Equipment creation&#13;
    /// @param _owner Owner of the equipment created&#13;
    /// @param _attrs Attributes of the equipment created&#13;
    /// @return Token ID of the equipment created&#13;
    function createFashion(address _owner, uint16[9] _attrs, uint16 _createType) &#13;
        external &#13;
        whenNotPaused&#13;
        returns(uint256)&#13;
    {&#13;
        require(actionContracts[msg.sender]);&#13;
        require(_owner != address(0));&#13;
&#13;
        uint256 newFashionId = fashionArray.length;&#13;
        require(newFashionId &lt; 4294967296);&#13;
&#13;
        fashionArray.length += 1;&#13;
        Fashion storage fs = fashionArray[newFashionId];&#13;
        fs.protoId = _attrs[0];&#13;
        fs.quality = _attrs[1];&#13;
        fs.pos = _attrs[2];&#13;
        if (_attrs[3] != 0) {&#13;
            fs.health = _attrs[3];&#13;
        }&#13;
        &#13;
        if (_attrs[4] != 0) {&#13;
            fs.atkMin = _attrs[4];&#13;
            fs.atkMax = _attrs[5];&#13;
        }&#13;
       &#13;
        if (_attrs[6] != 0) {&#13;
            fs.defence = _attrs[6];&#13;
        }&#13;
        &#13;
        if (_attrs[7] != 0) {&#13;
            fs.crit = _attrs[7];&#13;
        }&#13;
&#13;
        if (_attrs[8] != 0) {&#13;
            fs.isPercent = _attrs[8];&#13;
        }&#13;
        &#13;
        _transfer(0, _owner, newFashionId);&#13;
        CreateFashion(_owner, newFashionId, _attrs[0], _attrs[1], _attrs[2], _createType);&#13;
        return newFashionId;&#13;
    }&#13;
&#13;
    /// @dev One specific attribute of the equipment modified&#13;
    function _changeAttrByIndex(Fashion storage _fs, uint16 _index, uint16 _val) internal {&#13;
        if (_index == 3) {&#13;
            _fs.health = _val;&#13;
        } else if(_index == 4) {&#13;
            _fs.atkMin = _val;&#13;
        } else if(_index == 5) {&#13;
            _fs.atkMax = _val;&#13;
        } else if(_index == 6) {&#13;
            _fs.defence = _val;&#13;
        } else if(_index == 7) {&#13;
            _fs.crit = _val;&#13;
        } else if(_index == 9) {&#13;
            _fs.attrExt1 = _val;&#13;
        } else if(_index == 10) {&#13;
            _fs.attrExt2 = _val;&#13;
        } else if(_index == 11) {&#13;
            _fs.attrExt3 = _val;&#13;
        }&#13;
    }&#13;
&#13;
    /// @dev Equiment attributes modified (max 4 stats modified)&#13;
    /// @param _tokenId Equipment Token ID&#13;
    /// @param _idxArray Stats order that must be modified&#13;
    /// @param _params Stat value that must be modified&#13;
    /// @param _changeType Modification type such as enhance, socket, etc.&#13;
    function changeFashionAttr(uint256 _tokenId, uint16[4] _idxArray, uint16[4] _params, uint16 _changeType) &#13;
        external &#13;
        whenNotPaused&#13;
        isValidToken(_tokenId) &#13;
    {&#13;
        require(actionContracts[msg.sender]);&#13;
&#13;
        Fashion storage fs = fashionArray[_tokenId];&#13;
        if (_idxArray[0] &gt; 0) {&#13;
            _changeAttrByIndex(fs, _idxArray[0], _params[0]);&#13;
        }&#13;
&#13;
        if (_idxArray[1] &gt; 0) {&#13;
            _changeAttrByIndex(fs, _idxArray[1], _params[1]);&#13;
        }&#13;
&#13;
        if (_idxArray[2] &gt; 0) {&#13;
            _changeAttrByIndex(fs, _idxArray[2], _params[2]);&#13;
        }&#13;
&#13;
        if (_idxArray[3] &gt; 0) {&#13;
            _changeAttrByIndex(fs, _idxArray[3], _params[3]);&#13;
        }&#13;
&#13;
        ChangeFashion(fashionIdToOwner[_tokenId], _tokenId, _changeType);&#13;
    }&#13;
&#13;
    /// @dev Equipment destruction&#13;
    /// @param _tokenId Equipment Token ID&#13;
    /// @param _deleteType Destruction type, such as craft&#13;
    function destroyFashion(uint256 _tokenId, uint16 _deleteType)&#13;
        external &#13;
        whenNotPaused&#13;
        isValidToken(_tokenId) &#13;
    {&#13;
        require(actionContracts[msg.sender]);&#13;
&#13;
        address _from = fashionIdToOwner[_tokenId];&#13;
        uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];&#13;
        uint256[] storage fsArray = ownerToFashionArray[_from]; &#13;
        require(fsArray[indexFrom] == _tokenId);&#13;
&#13;
        if (indexFrom != fsArray.length - 1) {&#13;
            uint256 lastTokenId = fsArray[fsArray.length - 1];&#13;
            fsArray[indexFrom] = lastTokenId; &#13;
            fashionIdToOwnerIndex[lastTokenId] = indexFrom;&#13;
        }&#13;
        fsArray.length -= 1; &#13;
&#13;
        fashionIdToOwner[_tokenId] = address(0);&#13;
        delete fashionIdToOwnerIndex[_tokenId];&#13;
        destroyFashionCount += 1;&#13;
&#13;
        Transfer(_from, 0, _tokenId);&#13;
&#13;
        DeleteFashion(_from, _tokenId, _deleteType);&#13;
    }&#13;
&#13;
    /// @dev Safe transfer by trust contracts&#13;
    function safeTransferByContract(uint256 _tokenId, address _to) &#13;
        external&#13;
        whenNotPaused&#13;
    {&#13;
        require(actionContracts[msg.sender]);&#13;
&#13;
        require(_tokenId &gt;= 1 &amp;&amp; _tokenId &lt;= fashionArray.length);&#13;
        address owner = fashionIdToOwner[_tokenId];&#13;
        require(owner != address(0));&#13;
        require(_to != address(0));&#13;
        require(owner != _to);&#13;
&#13;
        _transfer(owner, _to, _tokenId);&#13;
    }&#13;
&#13;
    //----------------------------------------------------------------------------------------------------------&#13;
&#13;
    /// @dev Get fashion attrs by tokenId&#13;
    function getFashion(uint256 _tokenId) external view isValidToken(_tokenId) returns (uint16[12] datas) {&#13;
        Fashion storage fs = fashionArray[_tokenId];&#13;
        datas[0] = fs.protoId;&#13;
        datas[1] = fs.quality;&#13;
        datas[2] = fs.pos;&#13;
        datas[3] = fs.health;&#13;
        datas[4] = fs.atkMin;&#13;
        datas[5] = fs.atkMax;&#13;
        datas[6] = fs.defence;&#13;
        datas[7] = fs.crit;&#13;
        datas[8] = fs.isPercent;&#13;
        datas[9] = fs.attrExt1;&#13;
        datas[10] = fs.attrExt2;&#13;
        datas[11] = fs.attrExt3;&#13;
    }&#13;
&#13;
    /// @dev Get tokenIds and flags by owner&#13;
    function getOwnFashions(address _owner) external view returns(uint256[] tokens, uint32[] flags) {&#13;
        require(_owner != address(0));&#13;
        uint256[] storage fsArray = ownerToFashionArray[_owner];&#13;
        uint256 length = fsArray.length;&#13;
        tokens = new uint256[](length);&#13;
        flags = new uint32[](length);&#13;
        for (uint256 i = 0; i &lt; length; ++i) {&#13;
            tokens[i] = fsArray[i];&#13;
            Fashion storage fs = fashionArray[fsArray[i]];&#13;
            flags[i] = uint32(uint32(fs.protoId) * 100 + uint32(fs.quality) * 10 + fs.pos);&#13;
        }&#13;
    }&#13;
&#13;
    /// @dev WAR token info returned based on Token ID transfered (64 at most)&#13;
    function getFashionsAttrs(uint256[] _tokens) external view returns(uint16[] attrs) {&#13;
        uint256 length = _tokens.length;&#13;
        require(length &lt;= 64);&#13;
        attrs = new uint16[](length * 11);&#13;
        uint256 tokenId;&#13;
        uint256 index;&#13;
        for (uint256 i = 0; i &lt; length; ++i) {&#13;
            tokenId = _tokens[i];&#13;
            if (fashionIdToOwner[tokenId] != address(0)) {&#13;
                index = i * 11;&#13;
                Fashion storage fs = fashionArray[tokenId];&#13;
                attrs[index] = fs.health;&#13;
                attrs[index + 1] = fs.atkMin;&#13;
                attrs[index + 2] = fs.atkMax;&#13;
                attrs[index + 3] = fs.defence;&#13;
                attrs[index + 4] = fs.crit;&#13;
                attrs[index + 5] = fs.isPercent;&#13;
                attrs[index + 6] = fs.attrExt1;&#13;
                attrs[index + 7] = fs.attrExt2;&#13;
                attrs[index + 8] = fs.attrExt3;&#13;
            }   &#13;
        }&#13;
    }&#13;
}&#13;
&#13;
contract ActionMining is Random, AccessService {&#13;
    using SafeMath for uint256;&#13;
&#13;
    event MiningOrderCreated(uint256 indexed index, address indexed miner, uint64 chestCnt);&#13;
    event MiningResolved(uint256 indexed index, address indexed miner, uint64 chestCnt);&#13;
&#13;
    struct MiningOrder {&#13;
        address miner;      &#13;
        uint64 chestCnt;    &#13;
        uint64 tmCreate;    &#13;
        uint64 tmResolve;   &#13;
    }&#13;
&#13;
    /// @dev Max fashion suit id&#13;
    uint16 maxProtoId;&#13;
    /// @dev If the recommender can get reward &#13;
    bool isRecommendOpen;&#13;
    /// @dev prizepool percent&#13;
    uint256 constant prizePoolPercent = 50;&#13;
    /// @dev prizepool contact address&#13;
    address poolContract;&#13;
    /// @dev WarToken(NFT) contract address&#13;
    WarToken public tokenContract;&#13;
    /// @dev DataMining contract address&#13;
    IDataMining public dataContract;&#13;
    /// @dev mining order array&#13;
    MiningOrder[] public ordersArray;&#13;
&#13;
    mapping (uint16 =&gt; uint256) public protoIdToCount;&#13;
&#13;
&#13;
    function ActionMining(address _nftAddr, uint16 _maxProtoId) public {&#13;
        addrAdmin = msg.sender;&#13;
        addrService = msg.sender;&#13;
        addrFinance = msg.sender;&#13;
&#13;
        tokenContract = WarToken(_nftAddr);&#13;
        maxProtoId = _maxProtoId;&#13;
        &#13;
        MiningOrder memory order = MiningOrder(0, 0, 1, 1);&#13;
        ordersArray.push(order);&#13;
    }&#13;
&#13;
    function() external payable {&#13;
&#13;
    }&#13;
&#13;
    function getOrderCount() external view returns(uint256) {&#13;
        return ordersArray.length - 1;&#13;
    }&#13;
&#13;
    function setDataMining(address _addr) external onlyAdmin {&#13;
        require(_addr != address(0));&#13;
        dataContract = IDataMining(_addr);&#13;
    }&#13;
    &#13;
    function setPrizePool(address _addr) external onlyAdmin {&#13;
        require(_addr != address(0));&#13;
        poolContract = _addr;&#13;
    }&#13;
&#13;
    function setMaxProtoId(uint16 _maxProtoId) external onlyAdmin {&#13;
        require(_maxProtoId &gt; 0 &amp;&amp; _maxProtoId &lt; 10000);&#13;
        require(_maxProtoId != maxProtoId);&#13;
        maxProtoId = _maxProtoId;&#13;
    }&#13;
&#13;
    function setRecommendStatus(bool _isOpen) external onlyAdmin {&#13;
        require(_isOpen != isRecommendOpen);&#13;
        isRecommendOpen = _isOpen;&#13;
    }&#13;
&#13;
    function setFashionSuitCount(uint16 _protoId, uint256 _cnt) external onlyAdmin {&#13;
        require(_protoId &gt; 0 &amp;&amp; _protoId &lt;= maxProtoId);&#13;
        require(_cnt &gt; 0 &amp;&amp; _cnt &lt;= 5);&#13;
        require(protoIdToCount[_protoId] != _cnt);&#13;
        protoIdToCount[_protoId] = _cnt;&#13;
    }&#13;
&#13;
    function _getFashionParam(uint256 _seed) internal view returns(uint16[9] attrs) {&#13;
        uint256 curSeed = _seed;&#13;
        // quality&#13;
        uint256 rdm = curSeed % 10000;&#13;
        uint16 qtyParam;&#13;
        if (rdm &lt; 6900) {&#13;
            attrs[1] = 1;&#13;
            qtyParam = 0;&#13;
        } else if (rdm &lt; 8700) {&#13;
            attrs[1] = 2;&#13;
            qtyParam = 1;&#13;
        } else if (rdm &lt; 9600) {&#13;
            attrs[1] = 3;&#13;
            qtyParam = 2;&#13;
        } else if (rdm &lt; 9900) {&#13;
            attrs[1] = 4;&#13;
            qtyParam = 4;&#13;
        } else {&#13;
            attrs[1] = 5;&#13;
            qtyParam = 6;&#13;
        }&#13;
&#13;
        // protoId&#13;
        curSeed /= 10000;&#13;
        rdm = ((curSeed % 10000) / (9999 / maxProtoId)) + 1;&#13;
        attrs[0] = uint16(rdm &lt;= maxProtoId ? rdm : maxProtoId);&#13;
&#13;
        // pos&#13;
        curSeed /= 10000;&#13;
        uint256 tmpVal = protoIdToCount[attrs[0]];&#13;
        if (tmpVal == 0) {&#13;
            tmpVal = 5;&#13;
        }&#13;
        rdm = ((curSeed % 10000) / (9999 / tmpVal)) + 1;&#13;
        uint16 pos = uint16(rdm &lt;= tmpVal ? rdm : tmpVal);&#13;
        attrs[2] = pos;&#13;
&#13;
        rdm = attrs[0] % 3;&#13;
&#13;
        curSeed /= 10000;&#13;
        tmpVal = (curSeed % 10000) % 21 + 90;&#13;
&#13;
        if (rdm == 0) {&#13;
            if (pos == 1) {&#13;
                uint256 attr = (200 + qtyParam * 200) * tmpVal / 100;              // +atk&#13;
                attrs[4] = uint16(attr * 40 / 100);&#13;
                attrs[5] = uint16(attr * 160 / 100);&#13;
            } else if (pos == 2) {&#13;
                attrs[6] = uint16((40 + qtyParam * 40) * tmpVal / 100);            // +def&#13;
            } else if (pos == 3) {&#13;
                attrs[3] = uint16((600 + qtyParam * 600) * tmpVal / 100);          // +hp&#13;
            } else if (pos == 4) {&#13;
                attrs[6] = uint16((60 + qtyParam * 60) * tmpVal / 100);            // +def&#13;
            } else {&#13;
                attrs[3] = uint16((400 + qtyParam * 400) * tmpVal / 100);          // +hp&#13;
            }&#13;
        } else if (rdm == 1) {&#13;
            if (pos == 1) {&#13;
                uint256 attr2 = (190 + qtyParam * 190) * tmpVal / 100;              // +atk&#13;
                attrs[4] = uint16(attr2 * 50 / 100);&#13;
                attrs[5] = uint16(attr2 * 150 / 100);&#13;
            } else if (pos == 2) {&#13;
                attrs[6] = uint16((42 + qtyParam * 42) * tmpVal / 100);            // +def&#13;
            } else if (pos == 3) {&#13;
                attrs[3] = uint16((630 + qtyParam * 630) * tmpVal / 100);          // +hp&#13;
            } else if (pos == 4) {&#13;
                attrs[6] = uint16((63 + qtyParam * 63) * tmpVal / 100);            // +def&#13;
            } else {&#13;
                attrs[3] = uint16((420 + qtyParam * 420) * tmpVal / 100);          // +hp&#13;
            }&#13;
        } else {&#13;
            if (pos == 1) {&#13;
                uint256 attr3 = (210 + qtyParam * 210) * tmpVal / 100;             // +atk&#13;
                attrs[4] = uint16(attr3 * 30 / 100);&#13;
                attrs[5] = uint16(attr3 * 170 / 100);&#13;
            } else if (pos == 2) {&#13;
                attrs[6] = uint16((38 + qtyParam * 38) * tmpVal / 100);            // +def&#13;
            } else if (pos == 3) {&#13;
                attrs[3] = uint16((570 + qtyParam * 570) * tmpVal / 100);          // +hp&#13;
            } else if (pos == 4) {&#13;
                attrs[6] = uint16((57 + qtyParam * 57) * tmpVal / 100);            // +def&#13;
            } else {&#13;
                attrs[3] = uint16((380 + qtyParam * 380) * tmpVal / 100);          // +hp&#13;
            }&#13;
        }&#13;
        attrs[8] = 0;&#13;
    }&#13;
&#13;
    function _addOrder(address _miner, uint64 _chestCnt) internal {&#13;
        uint64 newOrderId = uint64(ordersArray.length);&#13;
        ordersArray.length += 1;&#13;
        MiningOrder storage order = ordersArray[newOrderId];&#13;
        order.miner = _miner;&#13;
        order.chestCnt = _chestCnt;&#13;
        order.tmCreate = uint64(block.timestamp);&#13;
&#13;
        MiningOrderCreated(newOrderId, _miner, _chestCnt);&#13;
    }&#13;
&#13;
    function _transferHelper(uint256 ethVal) private {&#13;
        bool recommenderSended = false;&#13;
        uint256 fVal;&#13;
        uint256 pVal;&#13;
        if (isRecommendOpen) {&#13;
            address recommender = dataContract.getRecommender(msg.sender);&#13;
            if (recommender != address(0)) {&#13;
                uint256 rVal = ethVal.div(10);&#13;
                fVal = ethVal.sub(rVal).mul(prizePoolPercent).div(100);&#13;
                addrFinance.transfer(fVal);&#13;
                recommenderSended = true;&#13;
                recommender.transfer(rVal);&#13;
                pVal = ethVal.sub(rVal).sub(fVal);&#13;
                if (poolContract != address(0) &amp;&amp; pVal &gt; 0) {&#13;
                    poolContract.transfer(pVal);&#13;
                }&#13;
            } &#13;
        } &#13;
        if (!recommenderSended) {&#13;
            fVal = ethVal.mul(prizePoolPercent).div(100);&#13;
            pVal = ethVal.sub(fVal);&#13;
            addrFinance.transfer(fVal);&#13;
            if (poolContract != address(0) &amp;&amp; pVal &gt; 0) {&#13;
                poolContract.transfer(pVal);&#13;
            }&#13;
        }&#13;
    }&#13;
&#13;
    function miningOneFree()&#13;
        external&#13;
        whenNotPaused&#13;
    {&#13;
        require(dataContract != address(0));&#13;
&#13;
        uint256 seed = _rand();&#13;
        uint16[9] memory attrs = _getFashionParam(seed);&#13;
&#13;
        require(dataContract.subFreeMineral(msg.sender));&#13;
&#13;
        tokenContract.createFashion(msg.sender, attrs, 3);&#13;
&#13;
        MiningResolved(0, msg.sender, 1);&#13;
    }&#13;
&#13;
    function miningOneSelf() &#13;
        external &#13;
        payable &#13;
        whenNotPaused&#13;
    {&#13;
        require(msg.value &gt;= 0.01 ether);&#13;
&#13;
        uint256 seed = _rand();&#13;
        uint16[9] memory attrs = _getFashionParam(seed);&#13;
&#13;
        tokenContract.createFashion(msg.sender, attrs, 2);&#13;
        _transferHelper(0.01 ether);&#13;
&#13;
        if (msg.value &gt; 0.01 ether) {&#13;
            msg.sender.transfer(msg.value - 0.01 ether);&#13;
        }&#13;
&#13;
        MiningResolved(0, msg.sender, 1);&#13;
    }&#13;
&#13;
    function miningOne() &#13;
        external &#13;
        payable &#13;
        whenNotPaused&#13;
    {&#13;
        require(msg.value &gt;= 0.01 ether);&#13;
&#13;
        _addOrder(msg.sender, 1);&#13;
        _transferHelper(0.01 ether);&#13;
&#13;
        if (msg.value &gt; 0.01 ether) {&#13;
            msg.sender.transfer(msg.value - 0.01 ether);&#13;
        }&#13;
    }&#13;
&#13;
    function miningThree() &#13;
        external &#13;
        payable &#13;
        whenNotPaused&#13;
    {&#13;
        require(msg.value &gt;= 0.03 ether);&#13;
&#13;
        _addOrder(msg.sender, 3);&#13;
        _transferHelper(0.03 ether);&#13;
&#13;
        if (msg.value &gt; 0.03 ether) {&#13;
            msg.sender.transfer(msg.value - 0.03 ether);&#13;
        }&#13;
    }&#13;
&#13;
    function miningFive() &#13;
        external &#13;
        payable &#13;
        whenNotPaused&#13;
    {&#13;
        require(msg.value &gt;= 0.0475 ether);&#13;
&#13;
        _addOrder(msg.sender, 5);&#13;
        _transferHelper(0.0475 ether);&#13;
&#13;
        if (msg.value &gt; 0.0475 ether) {&#13;
            msg.sender.transfer(msg.value - 0.0475 ether);&#13;
        }&#13;
    }&#13;
&#13;
    function miningTen() &#13;
        external &#13;
        payable &#13;
        whenNotPaused&#13;
    {&#13;
        require(msg.value &gt;= 0.09 ether);&#13;
        &#13;
        _addOrder(msg.sender, 10);&#13;
        _transferHelper(0.09 ether);&#13;
&#13;
        if (msg.value &gt; 0.09 ether) {&#13;
            msg.sender.transfer(msg.value - 0.09 ether);&#13;
        }&#13;
    }&#13;
&#13;
    function miningResolve(uint256 _orderIndex, uint256 _seed) &#13;
        external &#13;
        onlyService&#13;
    {&#13;
        require(_orderIndex &gt; 0 &amp;&amp; _orderIndex &lt; ordersArray.length);&#13;
        MiningOrder storage order = ordersArray[_orderIndex];&#13;
        require(order.tmResolve == 0);&#13;
        address miner = order.miner;&#13;
        require(miner != address(0));&#13;
        uint64 chestCnt = order.chestCnt;&#13;
        require(chestCnt &gt;= 1 &amp;&amp; chestCnt &lt;= 10);&#13;
&#13;
        uint256 rdm = _seed;&#13;
        uint16[9] memory attrs;&#13;
        for (uint64 i = 0; i &lt; chestCnt; ++i) {&#13;
            rdm = _randBySeed(rdm);&#13;
            attrs = _getFashionParam(rdm);&#13;
            tokenContract.createFashion(miner, attrs, 2);&#13;
        }&#13;
        order.tmResolve = uint64(block.timestamp);&#13;
        MiningResolved(_orderIndex, miner, chestCnt);&#13;
    }&#13;
}