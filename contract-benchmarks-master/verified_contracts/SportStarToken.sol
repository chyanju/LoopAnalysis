pragma solidity ^0.4.18; // solhint-disable-line



/// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
/// @author Dieter Shirley <<a href="/cdn-cgi/l/email-protection" class="__cf_email__" data-cfemail="f296978697b2938a9b9d9f88979cdc919d">[email protected]</a>&gt; (https://github.com/dete)&#13;
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
&#13;
    // Optional&#13;
    // function name() public view returns (string name);&#13;
    // function symbol() public view returns (string symbol);&#13;
    // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);&#13;
    // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);&#13;
}&#13;
&#13;
&#13;
contract SportStarToken is ERC721 {&#13;
&#13;
    // ***** EVENTS&#13;
&#13;
    // @dev Transfer event as defined in current draft of ERC721.&#13;
    //  ownership is assigned, including births.&#13;
    event Transfer(address from, address to, uint256 tokenId);&#13;
&#13;
&#13;
&#13;
    // ***** STORAGE&#13;
&#13;
    // @dev A mapping from token IDs to the address that owns them. All tokens have&#13;
    //  some valid owner address.&#13;
    mapping (uint256 =&gt; address) public tokenIndexToOwner;&#13;
&#13;
    // @dev A mapping from owner address to count of tokens that address owns.&#13;
    //  Used internally inside balanceOf() to resolve ownership count.&#13;
    mapping (address =&gt; uint256) private ownershipTokenCount;&#13;
&#13;
    // @dev A mapping from TokenIDs to an address that has been approved to call&#13;
    //  transferFrom(). Each Token can only have one approved address for transfer&#13;
    //  at any time. A zero value means no approval is outstanding.&#13;
    mapping (uint256 =&gt; address) public tokenIndexToApproved;&#13;
&#13;
    // Additional token data&#13;
    mapping (uint256 =&gt; bytes32) public tokenIndexToData;&#13;
&#13;
    address public ceoAddress;&#13;
    address public masterContractAddress;&#13;
&#13;
    uint256 public promoCreatedCount;&#13;
&#13;
&#13;
&#13;
    // ***** DATATYPES&#13;
&#13;
    struct Token {&#13;
        string name;&#13;
    }&#13;
&#13;
    Token[] private tokens;&#13;
&#13;
&#13;
&#13;
    // ***** ACCESS MODIFIERS&#13;
&#13;
    modifier onlyCEO() {&#13;
        require(msg.sender == ceoAddress);&#13;
        _;&#13;
    }&#13;
&#13;
    modifier onlyMasterContract() {&#13;
        require(msg.sender == masterContractAddress);&#13;
        _;&#13;
    }&#13;
&#13;
&#13;
&#13;
    // ***** CONSTRUCTOR&#13;
&#13;
    function SportStarToken() public {&#13;
        ceoAddress = msg.sender;&#13;
    }&#13;
&#13;
&#13;
&#13;
    // ***** PRIVILEGES SETTING FUNCTIONS&#13;
&#13;
    function setCEO(address _newCEO) public onlyCEO {&#13;
        require(_newCEO != address(0));&#13;
&#13;
        ceoAddress = _newCEO;&#13;
    }&#13;
&#13;
    function setMasterContract(address _newMasterContract) public onlyCEO {&#13;
        require(_newMasterContract != address(0));&#13;
&#13;
        masterContractAddress = _newMasterContract;&#13;
    }&#13;
&#13;
&#13;
&#13;
    // ***** PUBLIC FUNCTIONS&#13;
&#13;
    // @notice Returns all the relevant information about a specific token.&#13;
    // @param _tokenId The tokenId of the token of interest.&#13;
    function getToken(uint256 _tokenId) public view returns (&#13;
        string tokenName,&#13;
        address owner&#13;
    ) {&#13;
        Token storage token = tokens[_tokenId];&#13;
        tokenName = token.name;&#13;
        owner = tokenIndexToOwner[_tokenId];&#13;
    }&#13;
&#13;
    // @param _owner The owner whose sport star tokens we are interested in.&#13;
    // @dev This method MUST NEVER be called by smart contract code. First, it's fairly&#13;
    //  expensive (it walks the entire Tokens array looking for tokens belonging to owner),&#13;
    //  but it also returns a dynamic array, which is only supported for web3 calls, and&#13;
    //  not contract-to-contract calls.&#13;
    function tokensOfOwner(address _owner) public view returns (uint256[] ownerTokens) {&#13;
        uint256 tokenCount = balanceOf(_owner);&#13;
        if (tokenCount == 0) {&#13;
            // Return an empty array&#13;
            return new uint256[](0);&#13;
        } else {&#13;
            uint256[] memory result = new uint256[](tokenCount);&#13;
            uint256 totalTokens = totalSupply();&#13;
            uint256 resultIndex = 0;&#13;
&#13;
            uint256 tokenId;&#13;
            for (tokenId = 0; tokenId &lt;= totalTokens; tokenId++) {&#13;
                if (tokenIndexToOwner[tokenId] == _owner) {&#13;
                    result[resultIndex] = tokenId;&#13;
                    resultIndex++;&#13;
                }&#13;
            }&#13;
            return result;&#13;
        }&#13;
    }&#13;
&#13;
    function getTokenData(uint256 _tokenId) public view returns (bytes32 tokenData) {&#13;
        return tokenIndexToData[_tokenId];&#13;
    }&#13;
&#13;
&#13;
&#13;
    // ***** ERC-721 FUNCTIONS&#13;
&#13;
    // @notice Grant another address the right to transfer token via takeOwnership() and transferFrom().&#13;
    // @param _to The address to be granted transfer approval. Pass address(0) to&#13;
    //  clear all approvals.&#13;
    // @param _tokenId The ID of the Token that can be transferred if this call succeeds.&#13;
    function approve(address _to, uint256 _tokenId) public {&#13;
        // Caller must own token.&#13;
        require(_owns(msg.sender, _tokenId));&#13;
&#13;
        tokenIndexToApproved[_tokenId] = _to;&#13;
&#13;
        Approval(msg.sender, _to, _tokenId);&#13;
    }&#13;
&#13;
    // For querying balance of a particular account&#13;
    // @param _owner The address for balance query&#13;
    function balanceOf(address _owner) public view returns (uint256 balance) {&#13;
        return ownershipTokenCount[_owner];&#13;
    }&#13;
&#13;
    function name() public pure returns (string) {&#13;
        return "CryptoSportStars";&#13;
    }&#13;
&#13;
    function symbol() public pure returns (string) {&#13;
        return "SportStarToken";&#13;
    }&#13;
&#13;
    function implementsERC721() public pure returns (bool) {&#13;
        return true;&#13;
    }&#13;
&#13;
    // For querying owner of token&#13;
    // @param _tokenId The tokenID for owner inquiry&#13;
    function ownerOf(uint256 _tokenId) public view returns (address owner)&#13;
    {&#13;
        owner = tokenIndexToOwner[_tokenId];&#13;
        require(owner != address(0));&#13;
    }&#13;
&#13;
    // @notice Allow pre-approved user to take ownership of a token&#13;
    // @param _tokenId The ID of the Token that can be transferred if this call succeeds.&#13;
    function takeOwnership(uint256 _tokenId) public {&#13;
        address newOwner = msg.sender;&#13;
        address oldOwner = tokenIndexToOwner[_tokenId];&#13;
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
    // For querying totalSupply of token&#13;
    function totalSupply() public view returns (uint256 total) {&#13;
        return tokens.length;&#13;
    }&#13;
&#13;
    // Owner initates the transfer of the token to another account&#13;
    // @param _to The address for the token to be transferred to.&#13;
    // @param _tokenId The ID of the Token that can be transferred if this call succeeds.&#13;
    function transfer(address _to, uint256 _tokenId) public {&#13;
        require(_owns(msg.sender, _tokenId));&#13;
        require(_addressNotNull(_to));&#13;
&#13;
        _transfer(msg.sender, _to, _tokenId);&#13;
    }&#13;
&#13;
    // Third-party initiates transfer of token from address _from to address _to&#13;
    // @param _from The address for the token to be transferred from.&#13;
    // @param _to The address for the token to be transferred to.&#13;
    // @param _tokenId The ID of the Token that can be transferred if this call succeeds.&#13;
    function transferFrom(address _from, address _to, uint256 _tokenId) public {&#13;
        require(_owns(_from, _tokenId));&#13;
        require(_approved(_to, _tokenId));&#13;
        require(_addressNotNull(_to));&#13;
&#13;
        _transfer(_from, _to, _tokenId);&#13;
    }&#13;
&#13;
&#13;
&#13;
    // ONLY MASTER CONTRACT FUNCTIONS&#13;
&#13;
    function createToken(string _name, address _owner) public onlyMasterContract returns (uint256 _tokenId) {&#13;
        return _createToken(_name, _owner);&#13;
    }&#13;
&#13;
    function updateOwner(address _from, address _to, uint256 _tokenId) public onlyMasterContract {&#13;
        _transfer(_from, _to, _tokenId);&#13;
    }&#13;
&#13;
    function setTokenData(uint256 _tokenId, bytes32 tokenData) public onlyMasterContract {&#13;
        tokenIndexToData[_tokenId] = tokenData;&#13;
    }&#13;
&#13;
&#13;
&#13;
    // PRIVATE FUNCTIONS&#13;
&#13;
    // Safety check on _to address to prevent against an unexpected 0x0 default.&#13;
    function _addressNotNull(address _to) private pure returns (bool) {&#13;
        return _to != address(0);&#13;
    }&#13;
&#13;
    // For checking approval of transfer for address _to&#13;
    function _approved(address _to, uint256 _tokenId) private view returns (bool) {&#13;
        return tokenIndexToApproved[_tokenId] == _to;&#13;
    }&#13;
&#13;
    // For creating Token&#13;
    function _createToken(string _name, address _owner) private returns (uint256 _tokenId) {&#13;
        Token memory _token = Token({&#13;
            name: _name&#13;
            });&#13;
        uint256 newTokenId = tokens.push(_token) - 1;&#13;
&#13;
        // It's probably never going to happen, 4 billion tokens are A LOT, but&#13;
        // let's just be 100% sure we never let this happen.&#13;
        require(newTokenId == uint256(uint32(newTokenId)));&#13;
&#13;
        // This will assign ownership, and also emit the Transfer event as&#13;
        // per ERC721 draft&#13;
        _transfer(address(0), _owner, newTokenId);&#13;
&#13;
        return newTokenId;&#13;
    }&#13;
&#13;
    // Check for token ownership&#13;
    function _owns(address claimant, uint256 _tokenId) private view returns (bool) {&#13;
        return claimant == tokenIndexToOwner[_tokenId];&#13;
    }&#13;
&#13;
    // @dev Assigns ownership of a specific Token to an address.&#13;
    function _transfer(address _from, address _to, uint256 _tokenId) private {&#13;
        // Since the number of tokens is capped to 2^32 we can't overflow this&#13;
        ownershipTokenCount[_to]++;&#13;
        //transfer ownership&#13;
        tokenIndexToOwner[_tokenId] = _to;&#13;
&#13;
        // When creating new tokens _from is 0x0, but we can't account that address.&#13;
        if (_from != address(0)) {&#13;
            ownershipTokenCount[_from]--;&#13;
            // clear any previously approved ownership exchange&#13;
            delete tokenIndexToApproved[_tokenId];&#13;
        }&#13;
&#13;
        // Emit the transfer event.&#13;
        Transfer(_from, _to, _tokenId);&#13;
    }&#13;
}