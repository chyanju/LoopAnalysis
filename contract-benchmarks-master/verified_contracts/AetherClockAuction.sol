pragma solidity ^0.4.18;

// File: contracts-origin/ERC721Draft.sol

/// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
/// @author Dieter Shirley <<span class="__cf_email__" data-cfemail="385c5d4c5d785940515755425d56165b57">[email protected]</span>&gt; (https://github.com/dete)&#13;
contract ERC721 {&#13;
    function implementsERC721() public pure returns (bool);&#13;
    function totalSupply() public view returns (uint256 total);&#13;
    function balanceOf(address _owner) public view returns (uint256 balance);&#13;
    function ownerOf(uint256 _tokenId) public view returns (address owner);&#13;
    function approve(address _to, uint256 _tokenId) public;&#13;
    function transferFrom(address _from, address _to, uint256 _tokenId) public;&#13;
    function transfer(address _to, uint256 _tokenId) public;&#13;
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);&#13;
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);&#13;
&#13;
    // Optional&#13;
    // function name() public view returns (string name);&#13;
    // function symbol() public view returns (string symbol);&#13;
    // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);&#13;
    // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);&#13;
}&#13;
&#13;
// File: contracts-origin/Auction/ClockAuctionBase.sol&#13;
&#13;
/// @title Auction Core&#13;
/// @dev Contains models, variables, and internal methods for the auction.&#13;
contract ClockAuctionBase {&#13;
&#13;
    // Represents an auction on an NFT&#13;
    struct Auction {&#13;
        // Current owner of NFT&#13;
        address seller;&#13;
        // Price (in wei) at beginning of auction&#13;
        uint128 startingPrice;&#13;
        // Price (in wei) at end of auction&#13;
        uint128 endingPrice;&#13;
        // Duration (in seconds) of auction&#13;
        uint64 duration;&#13;
        // Time when auction started&#13;
        // NOTE: 0 if this auction has been concluded&#13;
        uint64 startedAt;&#13;
    }&#13;
&#13;
    // Reference to contract tracking NFT ownership&#13;
    ERC721 public nonFungibleContract;&#13;
&#13;
    // Cut owner takes on each auction, measured in basis points (1/100 of a percent).&#13;
    // Values 0-10,000 map to 0%-100%&#13;
    uint256 public ownerCut;&#13;
&#13;
    // Map from token ID to their corresponding auction.&#13;
    mapping (uint256 =&gt; Auction) tokenIdToAuction;&#13;
&#13;
    event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);&#13;
    event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner);&#13;
    event AuctionCancelled(uint256 tokenId);&#13;
&#13;
    /// @dev DON'T give me your money.&#13;
    function() external {}&#13;
&#13;
    // Modifiers to check that inputs can be safely stored with a certain&#13;
    // number of bits. We use constants and multiple modifiers to save gas.&#13;
    modifier canBeStoredWith64Bits(uint256 _value) {&#13;
        require(_value &lt;= 18446744073709551615);&#13;
        _;&#13;
    }&#13;
&#13;
    modifier canBeStoredWith128Bits(uint256 _value) {&#13;
        require(_value &lt; 340282366920938463463374607431768211455);&#13;
        _;&#13;
    }&#13;
&#13;
    /// @dev Returns true if the claimant owns the token.&#13;
    /// @param _claimant - Address claiming to own the token.&#13;
    /// @param _tokenId - ID of token whose ownership to verify.&#13;
    function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {&#13;
        return (nonFungibleContract.ownerOf(_tokenId) == _claimant);&#13;
    }&#13;
&#13;
    /// @dev Escrows the NFT, assigning ownership to this contract.&#13;
    /// Throws if the escrow fails.&#13;
    /// @param _owner - Current owner address of token to escrow.&#13;
    /// @param _tokenId - ID of token whose approval to verify.&#13;
    function _escrow(address _owner, uint256 _tokenId) internal {&#13;
        // it will throw if transfer fails&#13;
        nonFungibleContract.transferFrom(_owner, this, _tokenId);&#13;
    }&#13;
&#13;
    /// @dev Transfers an NFT owned by this contract to another address.&#13;
    /// Returns true if the transfer succeeds.&#13;
    /// @param _receiver - Address to transfer NFT to.&#13;
    /// @param _tokenId - ID of token to transfer.&#13;
    function _transfer(address _receiver, uint256 _tokenId) internal {&#13;
        // it will throw if transfer fails&#13;
        nonFungibleContract.transfer(_receiver, _tokenId);&#13;
    }&#13;
&#13;
    /// @dev Adds an auction to the list of open auctions. Also fires the&#13;
    ///  AuctionCreated event.&#13;
    /// @param _tokenId The ID of the token to be put on auction.&#13;
    /// @param _auction Auction to add.&#13;
    function _addAuction(uint256 _tokenId, Auction _auction) internal {&#13;
        // Require that all auctions have a duration of&#13;
        // at least one minute. (Keeps our math from getting hairy!)&#13;
        require(_auction.duration &gt;= 1 minutes);&#13;
&#13;
        tokenIdToAuction[_tokenId] = _auction;&#13;
&#13;
        AuctionCreated(&#13;
            uint256(_tokenId),&#13;
            uint256(_auction.startingPrice),&#13;
            uint256(_auction.endingPrice),&#13;
            uint256(_auction.duration)&#13;
        );&#13;
    }&#13;
&#13;
    /// @dev Cancels an auction unconditionally.&#13;
    function _cancelAuction(uint256 _tokenId, address _seller) internal {&#13;
        _removeAuction(_tokenId);&#13;
        _transfer(_seller, _tokenId);&#13;
        AuctionCancelled(_tokenId);&#13;
    }&#13;
&#13;
    /// @dev Computes the price and transfers winnings.&#13;
    /// Does NOT transfer ownership of token.&#13;
    function _bid(uint256 _tokenId, uint256 _bidAmount)&#13;
        internal&#13;
        returns (uint256)&#13;
    {&#13;
        // Get a reference to the auction struct&#13;
        Auction storage auction = tokenIdToAuction[_tokenId];&#13;
&#13;
        // Explicitly check that this auction is currently live.&#13;
        // (Because of how Ethereum mappings work, we can't just count&#13;
        // on the lookup above failing. An invalid _tokenId will just&#13;
        // return an auction object that is all zeros.)&#13;
        require(_isOnAuction(auction));&#13;
&#13;
        // Check that the incoming bid is higher than the current&#13;
        // price&#13;
        uint256 price = _currentPrice(auction);&#13;
        require(_bidAmount &gt;= price);&#13;
&#13;
        // Grab a reference to the seller before the auction struct&#13;
        // gets deleted.&#13;
        address seller = auction.seller;&#13;
&#13;
        // The bid is good! Remove the auction before sending the fees&#13;
        // to the sender so we can't have a reentrancy attack.&#13;
        _removeAuction(_tokenId);&#13;
&#13;
        // Transfer proceeds to seller (if there are any!)&#13;
        if (price &gt; 0) {&#13;
            //  Calculate the auctioneer's cut.&#13;
            // (NOTE: _computeCut() is guaranteed to return a&#13;
            //  value &lt;= price, so this subtraction can't go negative.)&#13;
            uint256 auctioneerCut = _computeCut(price);&#13;
            uint256 sellerProceeds = price - auctioneerCut;&#13;
&#13;
            // NOTE: Doing a transfer() in the middle of a complex&#13;
            // method like this is generally discouraged because of&#13;
            // reentrancy attacks and DoS attacks if the seller is&#13;
            // a contract with an invalid fallback function. We explicitly&#13;
            // guard against reentrancy attacks by removing the auction&#13;
            // before calling transfer(), and the only thing the seller&#13;
            // can DoS is the sale of their own asset! (And if it's an&#13;
            // accident, they can call cancelAuction(). )&#13;
            seller.transfer(sellerProceeds);&#13;
        }&#13;
&#13;
        // Tell the world!&#13;
        AuctionSuccessful(_tokenId, price, msg.sender);&#13;
&#13;
        return price;&#13;
    }&#13;
&#13;
    /// @dev Removes an auction from the list of open auctions.&#13;
    /// @param _tokenId - ID of NFT on auction.&#13;
    function _removeAuction(uint256 _tokenId) internal {&#13;
        delete tokenIdToAuction[_tokenId];&#13;
    }&#13;
&#13;
    /// @dev Returns true if the NFT is on auction.&#13;
    /// @param _auction - Auction to check.&#13;
    function _isOnAuction(Auction storage _auction) internal view returns (bool) {&#13;
        return (_auction.startedAt &gt; 0);&#13;
    }&#13;
&#13;
    /// @dev Returns current price of an NFT on auction. Broken into two&#13;
    ///  functions (this one, that computes the duration from the auction&#13;
    ///  structure, and the other that does the price computation) so we&#13;
    ///  can easily test that the price computation works correctly.&#13;
    function _currentPrice(Auction storage _auction)&#13;
        internal&#13;
        view&#13;
        returns (uint256)&#13;
    {&#13;
        uint256 secondsPassed = 0;&#13;
&#13;
        // A bit of insurance against negative values (or wraparound).&#13;
        // Probably not necessary (since Ethereum guarnatees that the&#13;
        // now variable doesn't ever go backwards).&#13;
        if (now &gt; _auction.startedAt) {&#13;
            secondsPassed = now - _auction.startedAt;&#13;
        }&#13;
&#13;
        return _computeCurrentPrice(&#13;
            _auction.startingPrice,&#13;
            _auction.endingPrice,&#13;
            _auction.duration,&#13;
            secondsPassed&#13;
        );&#13;
    }&#13;
&#13;
    /// @dev Computes the current price of an auction. Factored out&#13;
    ///  from _currentPrice so we can run extensive unit tests.&#13;
    ///  When testing, make this function public and turn on&#13;
    ///  `Current price computation` test suite.&#13;
    function _computeCurrentPrice(&#13;
        uint256 _startingPrice,&#13;
        uint256 _endingPrice,&#13;
        uint256 _duration,&#13;
        uint256 _secondsPassed&#13;
    )&#13;
        internal&#13;
        pure&#13;
        returns (uint256)&#13;
    {&#13;
        // NOTE: We don't use SafeMath (or similar) in this function because&#13;
        //  all of our public functions carefully cap the maximum values for&#13;
        //  time (at 64-bits) and currency (at 128-bits). _duration is&#13;
        //  also known to be non-zero (see the require() statement in&#13;
        //  _addAuction())&#13;
        if (_secondsPassed &gt;= _duration) {&#13;
            // We've reached the end of the dynamic pricing portion&#13;
            // of the auction, just return the end price.&#13;
            return _endingPrice;&#13;
        } else {&#13;
            // Starting price can be higher than ending price (and often is!), so&#13;
            // this delta can be negative.&#13;
            int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);&#13;
&#13;
            // This multiplication can't overflow, _secondsPassed will easily fit within&#13;
            // 64-bits, and totalPriceChange will easily fit within 128-bits, their product&#13;
            // will always fit within 256-bits.&#13;
            int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);&#13;
&#13;
            // currentPriceChange can be negative, but if so, will have a magnitude&#13;
            // less that _startingPrice. Thus, this result will always end up positive.&#13;
            int256 currentPrice = int256(_startingPrice) + currentPriceChange;&#13;
&#13;
            return uint256(currentPrice);&#13;
        }&#13;
    }&#13;
&#13;
    /// @dev Computes owner's cut of a sale.&#13;
    /// @param _price - Sale price of NFT.&#13;
    function _computeCut(uint256 _price) internal view returns (uint256) {&#13;
        // NOTE: We don't use SafeMath (or similar) in this function because&#13;
        //  all of our entry functions carefully cap the maximum values for&#13;
        //  currency (at 128-bits), and ownerCut &lt;= 10000 (see the require()&#13;
        //  statement in the ClockAuction constructor). The result of this&#13;
        //  function is always guaranteed to be &lt;= _price.&#13;
        return _price * ownerCut / 10000;&#13;
    }&#13;
&#13;
}&#13;
&#13;
// File: zeppelin-solidity/contracts/ownership/Ownable.sol&#13;
&#13;
/**&#13;
 * @title Ownable&#13;
 * @dev The Ownable contract has an owner address, and provides basic authorization control&#13;
 * functions, this simplifies the implementation of "user permissions".&#13;
 */&#13;
contract Ownable {&#13;
  address public owner;&#13;
&#13;
&#13;
  /**&#13;
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender&#13;
   * account.&#13;
   */&#13;
  function Ownable() {&#13;
    owner = msg.sender;&#13;
  }&#13;
&#13;
&#13;
  /**&#13;
   * @dev Throws if called by any account other than the owner.&#13;
   */&#13;
  modifier onlyOwner() {&#13;
    require(msg.sender == owner);&#13;
    _;&#13;
  }&#13;
&#13;
&#13;
  /**&#13;
   * @dev Allows the current owner to transfer control of the contract to a newOwner.&#13;
   * @param newOwner The address to transfer ownership to.&#13;
   */&#13;
  function transferOwnership(address newOwner) onlyOwner {&#13;
    if (newOwner != address(0)) {&#13;
      owner = newOwner;&#13;
    }&#13;
  }&#13;
&#13;
}&#13;
&#13;
// File: zeppelin-solidity/contracts/lifecycle/Pausable.sol&#13;
&#13;
/**&#13;
 * @title Pausable&#13;
 * @dev Base contract which allows children to implement an emergency stop mechanism.&#13;
 */&#13;
contract Pausable is Ownable {&#13;
  event Pause();&#13;
  event Unpause();&#13;
&#13;
  bool public paused = false;&#13;
&#13;
&#13;
  /**&#13;
   * @dev modifier to allow actions only when the contract IS paused&#13;
   */&#13;
  modifier whenNotPaused() {&#13;
    require(!paused);&#13;
    _;&#13;
  }&#13;
&#13;
  /**&#13;
   * @dev modifier to allow actions only when the contract IS NOT paused&#13;
   */&#13;
  modifier whenPaused {&#13;
    require(paused);&#13;
    _;&#13;
  }&#13;
&#13;
  /**&#13;
   * @dev called by the owner to pause, triggers stopped state&#13;
   */&#13;
  function pause() onlyOwner whenNotPaused returns (bool) {&#13;
    paused = true;&#13;
    Pause();&#13;
    return true;&#13;
  }&#13;
&#13;
  /**&#13;
   * @dev called by the owner to unpause, returns to normal state&#13;
   */&#13;
  function unpause() onlyOwner whenPaused returns (bool) {&#13;
    paused = false;&#13;
    Unpause();&#13;
    return true;&#13;
  }&#13;
}&#13;
&#13;
// File: contracts-origin/Auction/ClockAuction.sol&#13;
&#13;
/// @title Clock auction for non-fungible tokens.&#13;
contract ClockAuction is Pausable, ClockAuctionBase {&#13;
&#13;
    /// @dev Constructor creates a reference to the NFT ownership contract&#13;
    ///  and verifies the owner cut is in the valid range.&#13;
    /// @param _nftAddress - address of a deployed contract implementing&#13;
    ///  the Nonfungible Interface.&#13;
    /// @param _cut - percent cut the owner takes on each auction, must be&#13;
    ///  between 0-10,000.&#13;
    function ClockAuction(address _nftAddress, uint256 _cut) public {&#13;
        require(_cut &lt;= 10000);&#13;
        ownerCut = _cut;&#13;
        &#13;
        ERC721 candidateContract = ERC721(_nftAddress);&#13;
        require(candidateContract.implementsERC721());&#13;
        nonFungibleContract = candidateContract;&#13;
    }&#13;
&#13;
    /// @dev Remove all Ether from the contract, which is the owner's cuts&#13;
    ///  as well as any Ether sent directly to the contract address.&#13;
    ///  Always transfers to the NFT contract, but can be called either by&#13;
    ///  the owner or the NFT contract.&#13;
    function withdrawBalance() external {&#13;
        address nftAddress = address(nonFungibleContract);&#13;
&#13;
        require(&#13;
            msg.sender == owner ||&#13;
            msg.sender == nftAddress&#13;
        );&#13;
        nftAddress.transfer(this.balance);&#13;
    }&#13;
&#13;
    /// @dev Creates and begins a new auction.&#13;
    /// @param _tokenId - ID of token to auction, sender must be owner.&#13;
    /// @param _startingPrice - Price of item (in wei) at beginning of auction.&#13;
    /// @param _endingPrice - Price of item (in wei) at end of auction.&#13;
    /// @param _duration - Length of time to move between starting&#13;
    ///  price and ending price (in seconds).&#13;
    /// @param _seller - Seller, if not the message sender&#13;
    function createAuction(&#13;
        uint256 _tokenId,&#13;
        uint256 _startingPrice,&#13;
        uint256 _endingPrice,&#13;
        uint256 _duration,&#13;
        address _seller&#13;
    )&#13;
        public&#13;
        whenNotPaused&#13;
        canBeStoredWith128Bits(_startingPrice)&#13;
        canBeStoredWith128Bits(_endingPrice)&#13;
        canBeStoredWith64Bits(_duration)&#13;
    {&#13;
        require(_owns(msg.sender, _tokenId));&#13;
        _escrow(msg.sender, _tokenId);&#13;
        Auction memory auction = Auction(&#13;
            _seller,&#13;
            uint128(_startingPrice),&#13;
            uint128(_endingPrice),&#13;
            uint64(_duration),&#13;
            uint64(now)&#13;
        );&#13;
        _addAuction(_tokenId, auction);&#13;
    }&#13;
&#13;
    /// @dev Bids on an open auction, completing the auction and transferring&#13;
    ///  ownership of the NFT if enough Ether is supplied.&#13;
    /// @param _tokenId - ID of token to bid on.&#13;
    function bid(uint256 _tokenId)&#13;
        public&#13;
        payable&#13;
        whenNotPaused&#13;
    {&#13;
        // _bid will throw if the bid or funds transfer fails&#13;
        _bid(_tokenId, msg.value);&#13;
        _transfer(msg.sender, _tokenId);&#13;
    }&#13;
&#13;
    /// @dev Cancels an auction that hasn't been won yet.&#13;
    ///  Returns the NFT to original owner.&#13;
    /// @notice This is a state-modifying function that can&#13;
    ///  be called while the contract is paused.&#13;
    /// @param _tokenId - ID of token on auction&#13;
    function cancelAuction(uint256 _tokenId)&#13;
        public&#13;
    {&#13;
        Auction storage auction = tokenIdToAuction[_tokenId];&#13;
        require(_isOnAuction(auction));&#13;
        address seller = auction.seller;&#13;
        require(msg.sender == seller);&#13;
        _cancelAuction(_tokenId, seller);&#13;
    }&#13;
&#13;
    /// @dev Cancels an auction when the contract is paused.&#13;
    ///  Only the owner may do this, and NFTs are returned to&#13;
    ///  the seller. This should only be used in emergencies.&#13;
    /// @param _tokenId - ID of the NFT on auction to cancel.&#13;
    function cancelAuctionWhenPaused(uint256 _tokenId)&#13;
        whenPaused&#13;
        onlyOwner&#13;
        public&#13;
    {&#13;
        Auction storage auction = tokenIdToAuction[_tokenId];&#13;
        require(_isOnAuction(auction));&#13;
        _cancelAuction(_tokenId, auction.seller);&#13;
    }&#13;
&#13;
    /// @dev Returns auction info for an NFT on auction.&#13;
    /// @param _tokenId - ID of NFT on auction.&#13;
    function getAuction(uint256 _tokenId)&#13;
        public&#13;
        view&#13;
        returns&#13;
    (&#13;
        address seller,&#13;
        uint256 startingPrice,&#13;
        uint256 endingPrice,&#13;
        uint256 duration,&#13;
        uint256 startedAt&#13;
    ) {&#13;
        Auction storage auction = tokenIdToAuction[_tokenId];&#13;
        require(_isOnAuction(auction));&#13;
        return (&#13;
            auction.seller,&#13;
            auction.startingPrice,&#13;
            auction.endingPrice,&#13;
            auction.duration,&#13;
            auction.startedAt&#13;
        );&#13;
    }&#13;
&#13;
    /// @dev Returns the current price of an auction.&#13;
    /// @param _tokenId - ID of the token price we are checking.&#13;
    function getCurrentPrice(uint256 _tokenId)&#13;
        public&#13;
        view&#13;
        returns (uint256)&#13;
    {&#13;
        Auction storage auction = tokenIdToAuction[_tokenId];&#13;
        require(_isOnAuction(auction));&#13;
        return _currentPrice(auction);&#13;
    }&#13;
&#13;
}&#13;
&#13;
// File: contracts-origin/Auction/AetherClockAuction.sol&#13;
&#13;
/// @title Clock auction modified for sale of property&#13;
contract AetherClockAuction is ClockAuction {&#13;
&#13;
    // @dev Sanity check that allows us to ensure that we are pointing to the&#13;
    //  right auction in our setSaleAuctionAddress() call.&#13;
    bool public isAetherClockAuction = true;&#13;
&#13;
    // Tracks last 5 sale price of gen0 property sales&#13;
    uint256 public saleCount;&#13;
    uint256[5] public lastSalePrices;&#13;
&#13;
    // Delegate constructor&#13;
    function AetherClockAuction(address _nftAddr, uint256 _cut) public&#13;
      ClockAuction(_nftAddr, _cut) {}&#13;
&#13;
&#13;
    /// @dev Creates and begins a new auction.&#13;
    /// @param _tokenId - ID of token to auction, sender must be owner.&#13;
    /// @param _startingPrice - Price of item (in wei) at beginning of auction.&#13;
    /// @param _endingPrice - Price of item (in wei) at end of auction.&#13;
    /// @param _duration - Length of auction (in seconds).&#13;
    /// @param _seller - Seller, if not the message sender&#13;
    function createAuction(&#13;
        uint256 _tokenId,&#13;
        uint256 _startingPrice,&#13;
        uint256 _endingPrice,&#13;
        uint256 _duration,&#13;
        address _seller&#13;
    )&#13;
        public&#13;
        canBeStoredWith128Bits(_startingPrice)&#13;
        canBeStoredWith128Bits(_endingPrice)&#13;
        canBeStoredWith64Bits(_duration)&#13;
    {&#13;
        require(msg.sender == address(nonFungibleContract));&#13;
        _escrow(_seller, _tokenId);&#13;
        Auction memory auction = Auction(&#13;
            _seller,&#13;
            uint128(_startingPrice),&#13;
            uint128(_endingPrice),&#13;
            uint64(_duration),&#13;
            uint64(now)&#13;
        );&#13;
        _addAuction(_tokenId, auction);&#13;
    }&#13;
&#13;
    /// @dev Updates lastSalePrice if seller is the nft contract&#13;
    /// Otherwise, works the same as default bid method.&#13;
    function bid(uint256 _tokenId)&#13;
        public&#13;
        payable&#13;
    {&#13;
        // _bid verifies token ID size&#13;
        address seller = tokenIdToAuction[_tokenId].seller;&#13;
        uint256 price = _bid(_tokenId, msg.value);&#13;
        _transfer(msg.sender, _tokenId);&#13;
&#13;
        // If not a gen0 auction, exit&#13;
        if (seller == address(nonFungibleContract)) {&#13;
            // Track gen0 sale prices&#13;
            lastSalePrices[saleCount % 5] = price;&#13;
            saleCount++;&#13;
        }&#13;
    }&#13;
&#13;
    function averageSalePrice() public view returns (uint256) {&#13;
        uint256 sum = 0;&#13;
        for (uint256 i = 0; i &lt; 5; i++) {&#13;
            sum += lastSalePrices[i];&#13;
        }&#13;
        return sum / 5;&#13;
    }&#13;
}