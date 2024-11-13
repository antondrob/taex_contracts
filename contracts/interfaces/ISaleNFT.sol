// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

interface ISaleNFT {
    /**
     * The function that allows the primary sale of an NFT.
     * @param _taexNFT The address of the NFT contract.
     * @param _tokenId  The ID of the token being sold.
     */
    function primarySale(address _taexNFT, uint256 _tokenId) external payable;

    /**
     * The function that allows the secondary sale of an NFT.
     * @param _taexNFT The address of the NFT contract.
     * @param _tokenId The ID of the token being sold.
     */
    function secondarySale(address _taexNFT, uint256 _tokenId) external payable;

    /**
     * The event that is emitted when a primary sale occurs.
     * @param nft The address of the NFT contract.
     * @param tokenId The ID of the token being sold.
     * @param to The address of the buyer.
     */
    event PrimarySale(
        address indexed nft,
        uint256 indexed tokenId,
        address indexed to
    );

    /**
     * The event that is emitted when a secondary sale occurs.
     * @param nft The address of the NFT contract.
     * @param tokenId The ID of the token being sold.
     * @param to The address of the buyer.
     */
    event SecondarySale(
        address indexed nft,
        uint256 indexed tokenId,
        address indexed to
    );

    /**
     * The event emits when the owner withdraws ETH from the contract.
     * @param to The address to withdraw to.
     * @param amount The amount of ETH has been withdrawn.
     */
    event ETHWithdrawn(address indexed to, uint256 amount);
    
    /**
     * The event that emits when the address of the artist treasury is changed by owner
     * @param treasury The new address of the artist treasury.
     */
    event SetArtistTreasury(address indexed treasury);
    /**
     * The event that emits when the address of the Taex treasury is changed by owner
     * @param treasury The new address of the Taex treasury.
     */
    event SetTaexTreasury(address indexed treasury);
    /**
     * The event that emits when an NFT contract is added to the whitelist.
     * @param nftContract The new address of the NFT contract that was added to whitelist.
     */
    event AddToWhitelist(address indexed nftContract);
    /**
     * The event that emits when an NFT contract is removed from the whitelist.
     * @param nftContract The new address of the NFT contract that was removed from  whitelist.
     */
    event RemoveFromWhitelist(address indexed nftContract);

    error InvalidTokenId();
    error ZeroAmount();
    error InsufficientAmount();
    error TransferNFTFailed();
    error TransferETHToArtistFailed();
    error TransferETHToTaexFailed();
    error TransferETHToOwnerFailed();
    error TransferETHToWithdrawFailed();
    error NotListedForSale();
    error NoExistETHTowithdraw();
    error NotWhitelistedNFT();
}
