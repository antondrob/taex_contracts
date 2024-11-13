// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

interface ITaexNFT {
    /**
     * Function is used to get a Token's data.
     * @param tokenId The ID of the token
     * @return isListedForSale The token is listed for sale
     * @return primaryArtistFee The primary artist fee percentage
     * @return secondaryArtistFee The secondary artist fee percentage
     * @return secondaryTaexFee The secondary Taex fee percentage
     * @return price The sale price of the token
     */
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

    /**
     * The function is used to get the owner of a specified token ID.
     * @param tokenId The ID of the token
     */
    function ownerOfToken(uint256 tokenId) external view returns (address);

    /**
     * The function is used to get the price of a specified token ID.
     * @param tokenId The ID of the token
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * The event emitted when a token is listed for sale.
     * @param tokenId The ID of the token
     * @param price The price at which the token is listed for sale
     */
    event TokenListedForSale(uint256 tokenId, uint256 price);
    
    /**
     * The event emitted when a token is unlisted from sale.
     * @param tokenId The ID of the token
     */
    event TokenUnlistedFromSale(uint256 tokenId);
    
    /**
     * The event emitted when a token's price is adjusted.
     * @param tokenId The ID of the token
     * @param price The new price of the token
     */
    event TokenPriceAdjusted(uint256 tokenId, uint256 price);
    
    /**
     * The event emitted when a token is minted.
     * @param to The address the token is minted to
     * @param tokenId The ID of the minted token
     */
    event TokenMinted(address indexed to, uint256 tokenId);
    
    /**
     * The event emitted when the base URI is set.
     * @param baseURI The base URI
     */
    event SetBaseURI(string baseURI);
    
    /**
     * The event emitted when the default data is updated.
     * @param tokenId The ID of the token
     * @param primaryArtistFee The primary artist fee percentage
     * @param secondaryArtistFee The secondary artist fee percentage
     * @param secondaryTaexFee The secondary Taex fee percentage
     */
    event SetDefaultData(uint256 tokenId, uint8 primaryArtistFee, uint8 secondaryArtistFee, uint8 secondaryTaexFee);

    error ZeroAddress();
    error ZeroAmount();
    error NotOwnerOfTokenId();
    error InvalidFeePercentage();
    error NewPriceMustBeDifferent();
}
