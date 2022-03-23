pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";



interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Marketplace is ERC721 {
    
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    enum ListingStatus {
		Active,
		Sold,
		Cancelled
	}

    struct AuctionItem{
        ListingStatus status;
        address tokenAddress;
        uint256 tokenId;
        address seller;
        uint256 askingPrice;
        uint256 bidPrice;
        uint256 auctionStartTime; 
        uint256 auctionEndTime;
        address highestBidder;
        uint256 numBids;
    }

    struct Item {
        uint256 id;
        address creator;
        string uri;
    }


    IERC20 internal immutable Token =
        IERC20(address(0x6a4E4746b6c375b972CCc7147dB416Bdda738C4f)); 
           
           


    uint256 public defaultAuctionBidPeriod = 86400 * 3; //3 days
    uint public itemId = 0;

    mapping (address => mapping (uint256 => bool)) activeItems;
    mapping(uint256 => AuctionItem) auctionItems;
    mapping (uint256 => Item) public Items;

    event itemAdded(uint256 id, uint256 tokenId, address tokenAddress, uint256 askingPrice);
    event itemSold(uint256 id, address buyer, uint256 askingPrice);
    event itemListedOnAuction();
    event cancelled(uint256 id);

    modifier OnlyItemOwner(address tokenAddress, uint256 tokenId){
        IERC721 tokenContract = IERC721(tokenAddress);
        require(tokenContract.ownerOf(tokenId) == msg.sender);
        _;
    }

    modifier HasTransferApproval(address tokenAddress, uint256 tokenId){
        IERC721 tokenContract = IERC721(tokenAddress);
        require(tokenContract.getApproved(tokenId) == address(this));
        _;
    }


    constructor () ERC721("NFT", "NFT"){}

    function createItem(string memory uri) public returns (uint256){
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);

        Items[newItemId] = Item(newItemId, msg.sender, uri);

        return newItemId;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        return Items[tokenId].uri;
    }

    function listItem(uint256 tokenId, address tokenAddress, uint256 askingPrice) OnlyItemOwner(tokenAddress,tokenId) HasTransferApproval(tokenAddress,tokenId) external {
        require(activeItems[tokenAddress][tokenId] == false, "Item is already up for sale!");
        IERC721 tokenContract = IERC721(tokenAddress);
        AuctionItem memory item = AuctionItem(ListingStatus.Active, tokenAddress, tokenId, msg.sender, askingPrice, 0, 0, 0, address(0), 0);
        itemId++;
        auctionItems[itemId] = item;
        activeItems[tokenAddress][tokenId] = true;
        tokenContract.transferFrom(msg.sender, address(this), item.tokenId);
     
    }


    function buyItem(uint256 id) external {
        AuctionItem memory item = auctionItems[id];
        require(item.status == ListingStatus.Active, "Listing is not active");
        require(msg.sender != item.seller);

        uint256 amount = item.askingPrice ;
        

        item.status = ListingStatus.Sold;
        activeItems[item.tokenAddress][item.tokenId] = false;
        IERC721(item.tokenAddress).safeTransferFrom(address(this), msg.sender, item.tokenId);
        require(Token.allowance(msg.sender, address(this)) >= amount, "Insufficient allowance.");
        require(Token.balanceOf(msg.sender) >= amount, "Insufficient balance.");
        Token.transferFrom(msg.sender, item.seller, amount);
        auctionItems[id] = item;

        emit itemSold(id, msg.sender, amount);
    }

    function listItemOnAuction(uint256 tokenId, address tokenAddress, uint256 startPrice) OnlyItemOwner(tokenAddress,tokenId) HasTransferApproval(tokenAddress,tokenId) external {
        IERC721 tokenContract = IERC721(tokenAddress);
        require(startPrice > 0, "Item must have a price");
        require(activeItems[tokenAddress][tokenId] == false, "Item is already up for sale!");
        AuctionItem memory item = AuctionItem(ListingStatus.Active, tokenAddress, tokenId, msg.sender, 0, startPrice, block.timestamp, block.timestamp + defaultAuctionBidPeriod, address(0), 0);
        itemId++;
        auctionItems[itemId] = item;
        activeItems[tokenAddress][tokenId] = true;
        tokenContract.transferFrom(msg.sender, address(this), item.tokenId);
        emit itemListedOnAuction();

    }

    function makeBid(uint256 id, uint256 bid) external {
        AuctionItem memory item = auctionItems[id];
        require(block.timestamp < item.auctionEndTime || item.highestBidder == address(0), "Auction has ended");
        if (item.highestBidder != address(0)){
            require(bid >= item.bidPrice * 110 / 100, "Bid must be 10% higher than previous bid");
        } else {
            require(bid >= item.bidPrice, "Too low bid");
        }

        address previousBidder = item.highestBidder;
        
        if (previousBidder != address(0)) {
            Token.transfer(previousBidder, item.bidPrice);
        }

        item.highestBidder = msg.sender;
        item.numBids += 1;
        item.bidPrice = bid;
        auctionItems[id] = item;

        require(Token.allowance(msg.sender, address(this)) >= bid, "Insufficient allowance.");
        require(Token.balanceOf(msg.sender) >= bid, "Insufficient balance.");
        Token.transferFrom(msg.sender, address(this), bid);

    }

    function finishAuction(uint256 id) external {
        AuctionItem memory item = auctionItems[id];
        require(item.highestBidder != address(0),"No bids have been placed");
        require(block.timestamp >= item.auctionEndTime, "The auction is still active"); 
        if(item.numBids <= 2){
           Token.transfer(item.highestBidder, item.bidPrice);
        } else {
           activeItems[item.tokenAddress][item.tokenId] = false;
           IERC721(item.tokenAddress).safeTransferFrom(address(this), item.highestBidder, item.tokenId); 
        }
        activeItems[item.tokenAddress][item.tokenId] = false;
        item.status = ListingStatus.Sold;
        auctionItems[id] = item;

    }

    function cancel(uint256 id) external {
        AuctionItem memory item = auctionItems[id];
        require(msg.sender == item.seller, "Only seller can cancel listing");
		require(item.status == ListingStatus.Active, "Listing is not active");
        
        activeItems[item.tokenAddress][item.tokenId] = false;
        item.status = ListingStatus.Cancelled;
        IERC721(item.tokenAddress).transferFrom(address(this), msg.sender, item.tokenId);
        auctionItems[id] = item;
        emit cancelled(id);
    }
}