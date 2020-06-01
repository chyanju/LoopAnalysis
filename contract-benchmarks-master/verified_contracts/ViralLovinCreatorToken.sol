pragma solidity ^0.4.20; // solhint-disable-line

/// @title A standard interface for non-fungible tokens.
/// @author Dieter Shirley <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="b6d2d3c2d3f6d7cedfd9dbccd3d898d5d9">[email protected]</a>&gt;&#13;
contract ERC721 {&#13;
  // Required methods&#13;
  function approve(address _to, uint256 _tokenId) public;&#13;
  function balanceOf(address _owner) public view returns (uint256 balance);&#13;
  function implementsERC721() public pure returns (bool);&#13;
  function ownerOf(uint256 _tokenId) public view returns (address addr);&#13;
  function takeOwnership(uint256 _tokenId) public;&#13;
  function totalSupply() public view returns (uint256 total);&#13;
  function transferFrom(address _from, address _to, uint256 _tokenId) public;&#13;
  function transfer(address _to, uint256 _tokenId) public;&#13;
&#13;
  event Transfer(address indexed from, address indexed to, uint256 tokenId);&#13;
  event Approval(address indexed owner, address indexed approved, uint256 tokenId);&#13;
}&#13;
&#13;
/// @title ViralLo.vin, Creator token smart contract&#13;
/// @author Sam Morris &lt;<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="c1a9a881b2a0acefb7a8b3a0adaeefb7a8af">[email protected]</a>&gt;&#13;
contract ViralLovinCreatorToken is ERC721 {&#13;
&#13;
  /*** EVENTS ***/&#13;
&#13;
  /// @dev The Birth event is fired whenever a new Creator is created&#13;
  event Birth(&#13;
      uint256 tokenId, &#13;
      string name, &#13;
      address owner, &#13;
      uint256 collectiblesOrdered&#13;
    );&#13;
&#13;
  /// @dev The TokenSold event is fired whenever a token is sold.&#13;
  event TokenSold(&#13;
      uint256 tokenId, &#13;
      uint256 oldPrice, &#13;
      uint256 newPrice, &#13;
      address prevOwner, &#13;
      address winner, &#13;
      string name, &#13;
      uint256 collectiblesOrdered&#13;
    );&#13;
&#13;
  /// @dev Transfer event as defined in current draft of ERC721. &#13;
  ///  ownership is assigned, including births.&#13;
  event Transfer(address from, address to, uint256 tokenId);&#13;
&#13;
  /*** CONSTANTS ***/&#13;
&#13;
  /// @notice Name and symbol of the non fungible token, as defined in ERC721.&#13;
  string public constant NAME = "ViralLovin Creator Token"; // solhint-disable-line&#13;
  string public constant SYMBOL = "CREATOR"; // solhint-disable-line&#13;
&#13;
  uint256 private startingPrice = 0.001 ether;&#13;
&#13;
  /*** STORAGE ***/&#13;
&#13;
  /// @dev A mapping from Creator IDs to the address that owns them. &#13;
  /// All Creators have some valid owner address.&#13;
  mapping (uint256 =&gt; address) public creatorIndexToOwner;&#13;
&#13;
  /// @dev A mapping from owner address to count of tokens that address owns.&#13;
  //  Used internally inside balanceOf() to resolve ownership count.&#13;
  mapping (address =&gt; uint256) private ownershipTokenCount;&#13;
&#13;
  /// @dev A mapping from Creator IDs to an address that has been approved to call&#13;
  ///  transferFrom(). Each Creator can only have one approved address for transfer&#13;
  ///  at any time. A zero value means no approval is outstanding.&#13;
  mapping (uint256 =&gt; address) public creatorIndexToApproved;&#13;
&#13;
  // @dev A mapping from creator IDs to the price of the token.&#13;
  mapping (uint256 =&gt; uint256) private creatorIndexToPrice;&#13;
&#13;
  // The addresses that can execute actions within each roles.&#13;
  address public ceoAddress;&#13;
  address public cooAddress;&#13;
&#13;
  uint256 public creatorsCreatedCount;&#13;
&#13;
  /*** DATATYPES ***/&#13;
  struct Creator {&#13;
    string name;&#13;
    uint256 collectiblesOrdered;&#13;
  }&#13;
&#13;
  Creator[] private creators;&#13;
&#13;
  /*** ACCESS MODIFIERS ***/&#13;
  &#13;
  /// @dev Access modifier for CEO-only functionality&#13;
  modifier onlyCEO() {&#13;
    require(msg.sender == ceoAddress);&#13;
    _;&#13;
  }&#13;
&#13;
  /// @dev Access modifier for COO-only functionality&#13;
  modifier onlyCOO() {&#13;
    require(msg.sender == cooAddress);&#13;
    _;&#13;
  }&#13;
&#13;
  /// Access modifier for contract owner only functionality&#13;
  modifier onlyCLevel() {&#13;
    require(&#13;
      msg.sender == ceoAddress ||&#13;
      msg.sender == cooAddress&#13;
    );&#13;
    _;&#13;
  }&#13;
&#13;
  /*** CONSTRUCTOR ***/&#13;
  &#13;
  function ViralLovinCreatorToken() public {&#13;
    ceoAddress = msg.sender;&#13;
    cooAddress = msg.sender;&#13;
  }&#13;
&#13;
  /*** PUBLIC FUNCTIONS ***/&#13;
  &#13;
  /// @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().&#13;
  /// @param _to The address to be granted transfer approval. Pass address(0) to clear all approvals.&#13;
  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.&#13;
  /// @dev Required for ERC-721 compliance.&#13;
  function approve(address _to, uint256 _tokenId) public {&#13;
    // Caller must own token.&#13;
    require(_owns(msg.sender, _tokenId));&#13;
    creatorIndexToApproved[_tokenId] = _to;&#13;
    Approval(msg.sender, _to, _tokenId);&#13;
  }&#13;
&#13;
  /// For querying balance of a particular account&#13;
  /// @param _owner The address for balance query&#13;
  /// @dev Required for ERC-721 compliance.&#13;
  function balanceOf(address _owner) public view returns (uint256 balance) {&#13;
    return ownershipTokenCount[_owner];&#13;
  }&#13;
&#13;
  /// @dev Creates a new Creator with the given name, price, and the total number of collectibles ordered then assigns to an address.&#13;
  function createCreator(&#13;
      address _owner, &#13;
      string _name, &#13;
      uint256 _price, &#13;
      uint256 _collectiblesOrdered&#13;
    ) public onlyCOO {&#13;
    address creatorOwner = _owner;&#13;
    if (creatorOwner == address(0)) {&#13;
      creatorOwner = cooAddress;&#13;
    }&#13;
&#13;
    if (_price &lt;= 0) {&#13;
      _price = startingPrice;&#13;
    }&#13;
&#13;
    creatorsCreatedCount++;&#13;
    _createCreator(_name, creatorOwner, _price, _collectiblesOrdered);&#13;
    }&#13;
&#13;
  /// @notice Returns all the information about Creator token.&#13;
  /// @param _tokenId The tokenId of the Creator token.&#13;
  function getCreator(&#13;
      uint256 _tokenId&#13;
    ) public view returns (&#13;
        string creatorName, &#13;
        uint256 sellingPrice, &#13;
        address owner, &#13;
        uint256 collectiblesOrdered&#13;
    ) {&#13;
    Creator storage creator = creators[_tokenId];&#13;
    creatorName = creator.name;&#13;
    collectiblesOrdered = creator.collectiblesOrdered;&#13;
    sellingPrice = creatorIndexToPrice[_tokenId];&#13;
    owner = creatorIndexToOwner[_tokenId];&#13;
  }&#13;
&#13;
  function implementsERC721() public pure returns (bool) {&#13;
    return true;&#13;
  }&#13;
&#13;
  /// @dev For ERC-721 compliance.&#13;
  function name() public pure returns (string) {&#13;
    return NAME;&#13;
  }&#13;
&#13;
  /// For querying owner of a token&#13;
  /// @param _tokenId The tokenID&#13;
  /// @dev Required for ERC-721 compliance.&#13;
  function ownerOf(uint256 _tokenId) public view returns (address owner)&#13;
  {&#13;
    owner = creatorIndexToOwner[_tokenId];&#13;
    require(owner != address(0));&#13;
  }&#13;
&#13;
  /// For contract payout&#13;
  function payout(address _to) public onlyCLevel {&#13;
    require(_addressNotNull(_to));&#13;
    _payout(_to);&#13;
  }&#13;
&#13;
  /// Allows someone to obtain the token&#13;
  function purchase(uint256 _tokenId) public payable {&#13;
    address oldOwner = creatorIndexToOwner[_tokenId];&#13;
    address newOwner = msg.sender;&#13;
    uint256 sellingPrice = creatorIndexToPrice[_tokenId];&#13;
&#13;
    // Safety check to prevent against an unexpected 0x0 default.&#13;
    require(_addressNotNull(newOwner));&#13;
&#13;
    // Making sure sent amount is greater than or equal to the sellingPrice&#13;
    require(msg.value &gt;= sellingPrice);&#13;
&#13;
    // Transfer contract to new owner&#13;
    _transfer(oldOwner, newOwner, _tokenId);&#13;
&#13;
    // Transfer payment to VL&#13;
    ceoAddress.transfer(sellingPrice);&#13;
&#13;
    // Emits TokenSold event&#13;
    TokenSold(&#13;
        _tokenId, &#13;
        sellingPrice, &#13;
        creatorIndexToPrice[_tokenId], &#13;
        oldOwner, &#13;
        newOwner, &#13;
        creators[_tokenId].name, &#13;
        creators[_tokenId].collectiblesOrdered&#13;
    );&#13;
  }&#13;
&#13;
  function priceOf(uint256 _tokenId) public view returns (uint256 price) {&#13;
    return creatorIndexToPrice[_tokenId];&#13;
  }&#13;
&#13;
  /// @dev Assigns a new address to act as the CEO. Only available to the current CEO.&#13;
  /// @param _newCEO The address of the new CEO&#13;
  function setCEO(address _newCEO) public onlyCEO {&#13;
    require(_newCEO != address(0));&#13;
    ceoAddress = _newCEO;&#13;
  }&#13;
&#13;
  /// @dev Assigns a new address to act as the COO. Only available to the current CEO.&#13;
  /// @param _newCOO The address of the new COO&#13;
  function setCOO(address _newCOO) public onlyCEO {&#13;
    require(_newCOO != address(0));&#13;
    cooAddress = _newCOO;&#13;
  }&#13;
&#13;
  /// @dev For ERC-721 compliance.&#13;
  function symbol() public pure returns (string) {&#13;
    return SYMBOL;&#13;
  }&#13;
&#13;
  /// @notice Allow pre-approved user to take ownership of a token&#13;
  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.&#13;
  /// @dev Required for ERC-721 compliance.&#13;
  function takeOwnership(uint256 _tokenId) public {&#13;
    address newOwner = msg.sender;&#13;
    address oldOwner = creatorIndexToOwner[_tokenId];&#13;
&#13;
    // Safety check to prevent against an unexpected 0x0 default.&#13;
    require(_addressNotNull(newOwner));&#13;
&#13;
    // Making sure transfer is approved&#13;
    require(_approved(newOwner, _tokenId));&#13;
&#13;
    _transfer(oldOwner, newOwner, _tokenId);&#13;
  }&#13;
&#13;
  /// @param _owner Creator tokens belonging to the owner.&#13;
  /// @dev Expensive; not to be called by smart contract. Walks the collectibes array looking for Creator tokens belonging to owner.&#13;
  function tokensOfOwner(&#13;
      address _owner&#13;
      ) public view returns(uint256[] ownerTokens) {&#13;
    uint256 tokenCount = balanceOf(_owner);&#13;
    if (tokenCount == 0) {&#13;
        // Return an empty array&#13;
      return new uint256[](0);&#13;
    } else {&#13;
      uint256[] memory result = new uint256[](tokenCount);&#13;
      uint256 totalCreators = totalSupply();&#13;
      uint256 resultIndex = 0;&#13;
      uint256 creatorId;&#13;
      for (creatorId = 0; creatorId &lt;= totalCreators; creatorId++) {&#13;
        if (creatorIndexToOwner[creatorId] == _owner) {&#13;
          result[resultIndex] = creatorId;&#13;
          resultIndex++;&#13;
        }&#13;
      }&#13;
      return result;&#13;
    }&#13;
  }&#13;
&#13;
  /// For querying totalSupply of token&#13;
  /// @dev Required for ERC-721 compliance.&#13;
  function totalSupply() public view returns (uint256 total) {&#13;
    return creators.length;&#13;
  }&#13;
&#13;
  /// Owner initates the transfer of the token to another account&#13;
  /// @param _to The address for the token to be transferred to.&#13;
  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.&#13;
  /// @dev Required for ERC-721 compliance.&#13;
  function transfer(address _to, uint256 _tokenId) public {&#13;
    require(_owns(msg.sender, _tokenId));&#13;
    require(_addressNotNull(_to));&#13;
    _transfer(msg.sender, _to, _tokenId);&#13;
  }&#13;
&#13;
  /// Initiates transfer of token from address _from to address _to&#13;
  /// @param _from The address for the token to be transferred from.&#13;
  /// @param _to The address for the token to be transferred to.&#13;
  /// @param _tokenId The ID of the Token that can be transferred if this call succeeds.&#13;
  /// @dev Required for ERC-721 compliance.&#13;
  function transferFrom(address _from, address _to, uint256 _tokenId) public {&#13;
    require(_owns(_from, _tokenId));&#13;
    require(_approved(_to, _tokenId));&#13;
    require(_addressNotNull(_to));&#13;
&#13;
    _transfer(_from, _to, _tokenId);&#13;
  }&#13;
&#13;
  /*** PRIVATE FUNCTIONS ***/&#13;
  &#13;
  /// Safety check on _to address to prevent against an unexpected 0x0 default.&#13;
  function _addressNotNull(address _to) private pure returns (bool) {&#13;
    return _to != address(0);&#13;
  }&#13;
&#13;
  /// For checking approval of transfer for address _to&#13;
  function _approved(&#13;
      address _to, &#13;
      uint256 _tokenId&#13;
      ) private view returns (bool) {&#13;
    return creatorIndexToApproved[_tokenId] == _to;&#13;
  }&#13;
&#13;
  /// For creating a Creator&#13;
  function _createCreator(&#13;
      string _name, &#13;
      address _owner, &#13;
      uint256 _price, &#13;
      uint256 _collectiblesOrdered&#13;
      ) private {&#13;
    Creator memory _creator = Creator({&#13;
      name: _name,&#13;
      collectiblesOrdered: _collectiblesOrdered&#13;
    });&#13;
    uint256 newCreatorId = creators.push(_creator) - 1;&#13;
&#13;
    require(newCreatorId == uint256(uint32(newCreatorId)));&#13;
&#13;
    Birth(newCreatorId, _name, _owner, _collectiblesOrdered);&#13;
&#13;
    creatorIndexToPrice[newCreatorId] = _price;&#13;
&#13;
    // This will assign ownership, and also emit the Transfer event as per ERC721 draft&#13;
    _transfer(address(0), _owner, newCreatorId);&#13;
  }&#13;
&#13;
  /// Check for token ownership&#13;
  function _owns(&#13;
      address claimant, &#13;
      uint256 _tokenId&#13;
      ) private view returns (bool) {&#13;
    return claimant == creatorIndexToOwner[_tokenId];&#13;
  }&#13;
&#13;
  /// For paying out the full balance of contract&#13;
  function _payout(address _to) private {&#13;
    if (_to == address(0)) {&#13;
      ceoAddress.transfer(this.balance);&#13;
    } else {&#13;
      _to.transfer(this.balance);&#13;
    }&#13;
  }&#13;
&#13;
  /// @dev Assigns ownership of Creator token to an address.&#13;
  function _transfer(address _from, address _to, uint256 _tokenId) private {&#13;
    // increment owner token count&#13;
    ownershipTokenCount[_to]++;&#13;
    // transfer ownership&#13;
    creatorIndexToOwner[_tokenId] = _to;&#13;
&#13;
    // When creating new creators _from is 0x0, we can't account that address.&#13;
    if (_from != address(0)) {&#13;
      ownershipTokenCount[_from]--;&#13;
      // clear any previously approved ownership&#13;
      delete creatorIndexToApproved[_tokenId];&#13;
    }&#13;
&#13;
    // Emit the transfer event.&#13;
    Transfer(_from, _to, _tokenId);&#13;
  }&#13;
  &#13;
}