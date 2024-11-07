// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface ISaleNFT {
    function primarySale(address _taexNFT, uint256 _tokenId) external payable;

    function secondarySale(address _taexNFT, uint256 _tokenId) external payable;

    // Retrieve token data

    event PrimarySale(
        address indexed nft,
        uint256 indexed tokenId,
        address indexed to
    );
    event SecondarySale(
        address indexed nft,
        uint256 indexed tokenId,
        address indexed to
    );
    event ETHWithdrawn(address indexed to, uint256 amount);
    event SetArtistTreasury(address indexed treasury);
    event SetTaexTreasury(address indexed treasury);
    event AddToWhitelist(address indexed nftContract);
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
