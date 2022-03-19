pragma solidity ^0.8.9;



interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}

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

contract Marketplace {
    
    struct MarketItem {
        uint256 id;
        address tokenAddress;
        uint256 tokenId;
        address payable seller;
        uint256 askingPrice;
        bool isSold;
    }

    struct AuctionItem{
        uint256 id;
        address tokenAddress;
        uint256 tokenId;
        address payable seller;
        uint256 bidPrice;
        uint256 auctionStartTime; 
        uint256 auctionEndTime;
        address highestBidder;
        uint256 numBids;
    }


    IERC20 internal immutable Token =
        IERC20(address(0x28b5F469B9763b940D4F9AD2840A59660Cb7Fd60)); 
           
           
    MarketItem[] public itemsForSale;
    AuctionItem[] public AuctionItemsForSale;

    uint256 public defaultAuctionBidPeriod = 86400 * 3; //3 days

    mapping (address => mapping (uint256 => bool)) activeItems;

    event itemAdded(uint256 id, uint256 tokenId, address tokenAddress, uint256 askingPrice);
    event itemSold(uint256 id, address buyer, uint256 askingPrice);

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

    modifier ItemExists(uint256 id){
        require(id < itemsForSale.length && itemsForSale[id].id == id, "Could not find item");
        _;
    }

    modifier IsForSale(uint256 id){
        require(itemsForSale[id].isSold == false, "Item is already sold!");
        _;
    }


    function listItem(uint256 tokenId, address tokenAddress, uint256 askingPrice) OnlyItemOwner(tokenAddress,tokenId) HasTransferApproval(tokenAddress,tokenId) external returns (uint256){
        require(activeItems[tokenAddress][tokenId] == false, "Item is already up for sale!");
        uint256 newItemId = itemsForSale.length;  
        itemsForSale.push(MarketItem(newItemId, tokenAddress, tokenId, payable(msg.sender), askingPrice, false));
        activeItems[tokenAddress][tokenId] = true;

        assert(itemsForSale[newItemId].id == newItemId);
        emit itemAdded(newItemId, tokenId, tokenAddress, askingPrice);
        return newItemId;
    }


    function buyItem(uint256 id) external ItemExists(id) IsForSale(id) HasTransferApproval(itemsForSale[id].tokenAddress,itemsForSale[id].tokenId){
        require(msg.sender != itemsForSale[id].seller);

        uint256 amount = itemsForSale[id].askingPrice ;
        

        itemsForSale[id].isSold = true;
        activeItems[itemsForSale[id].tokenAddress][itemsForSale[id].tokenId] = false;
        IERC721(itemsForSale[id].tokenAddress).safeTransferFrom(itemsForSale[id].seller, msg.sender, itemsForSale[id].tokenId);
        require(Token.allowance(msg.sender, address(this)) >= amount, "Insufficient allowance.");
        require(Token.balanceOf(msg.sender) >= amount, "Insufficient balance.");
        Token.transferFrom(msg.sender, itemsForSale[id].seller, amount);

        emit itemSold(id, msg.sender, amount);
    }

    function listItemOnAuction(uint256 tokenId, address tokenAddress, uint256 startPrice) external {
        IERC721 tokenContract = IERC721(tokenAddress);
        require(activeItems[tokenAddress][tokenId] == false, "Item is already up for sale!");
        require(tokenContract.ownerOf(tokenId) == msg.sender, "Missing Item Ownership");
        require(tokenContract.getApproved(tokenId) == address(this), "Missing transfer approval");
        uint256 newItemId = itemsForSale.length;
        AuctionItemsForSale.push(AuctionItem(newItemId, tokenAddress, tokenId, payable(msg.sender), startPrice, block.timestamp, block.timestamp + defaultAuctionBidPeriod, address(0), 0));
        activeItems[tokenAddress][tokenId] = true;
        assert(AuctionItemsForSale[newItemId].id == newItemId);

        require(startPrice > 0, "Item must have a price");

    }

    function makeBid(uint256 id, uint256 bid) external {
        AuctionItem memory item = AuctionItemsForSale[id];
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
        AuctionItemsForSale[id] = item;

        require(Token.allowance(msg.sender, address(this)) >= bid, "Insufficient allowance.");
        require(Token.balanceOf(msg.sender) >= bid, "Insufficient balance.");
        Token.transferFrom(msg.sender, address(this), bid);

    }

    function finishAuction(uint256 id) external {
        AuctionItem memory item = AuctionItemsForSale[id];
        require(item.highestBidder != address(0),"No bids have been placed");
        require(block.timestamp >= item.auctionEndTime); 
        if(item.numBids <= 2){
           Token.transfer(item.highestBidder, item.bidPrice);
        } else {
           activeItems[itemsForSale[id].tokenAddress][itemsForSale[id].tokenId] = false;
           IERC721(AuctionItemsForSale[id].tokenAddress).safeTransferFrom(AuctionItemsForSale[id].seller, item.highestBidder, AuctionItemsForSale[id].tokenId); 
        }

    }


}