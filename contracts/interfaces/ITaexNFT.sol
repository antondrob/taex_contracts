// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

interface ITaexNFT {
    //TODO  natSpec
    function tokenData(
        uint256 tokenId
    )
        external
        view
        returns (
            bool isListedForSale,
            uint8 primaryArtistFee,
            uint8 secondaryArtistFee,
            uint8 secondaryTaexFee,
            uint256 price
        );

    //TODO  natSpec
    function ownerOfToken(uint256 tokenId) external view returns (address);

    //TODO  natSpec
    function transferFrom(address from, address to, uint256 tokenId) external;

    //TODO  natSpec
    event TokenListedForSale(uint256 tokenId, uint256 price);
    //TODO  natSpec
    event TokenUnlistedFromSale(uint256 tokenId);
    //TODO  natSpec
    event TokenPriceAdjusted(uint256 tokenId, uint256 price);
    //TODO  natSpec
    event TokenMinted(address indexed to, uint256 tokenId);
    //TODO  natSpec
    event SetBaseURI(string);
    //TODO  natSpec
    event SetDefaultData(uint256, uint8, uint8, uint8);
    //TODO  natSpec

    error ZeroAddress();
    //TODO  natSpec
    error ZeroAmount();
    //TODO  natSpec
    error NotOwnerOfTokenId();
    //TODO  natSpec
    error InvalidFeePercentage();
}
