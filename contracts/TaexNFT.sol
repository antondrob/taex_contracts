// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import {ReentrancyGuardTransientUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardTransientUpgradeable.sol";
import {ITaexNFT} from "./interfaces/ITaexNFT.sol";

/**
 * @title TaexNFT
 * @dev Implementation of an ERC721 NFT contract with fee management.
 */
contract TaexNFT is
    ERC721Upgradeable,
    OwnableUpgradeable,
    ReentrancyGuardTransientUpgradeable,
    ITaexNFT
{
    /// @notice Last minted token ID
    uint256 private _lastTokenId;
    /// Base URI for metadata
    string public internalBaseURI; 

     /**
     * @notice Represents the data of a token.
     * @param isListedForSale Indicates if the token is listed for sale
     * @param primaryArtistFee Primary artist fee percentage
     * @param secondaryArtistFee Secondary artist fee percentage
     * @param secondaryTaexFee Secondary Taex fee percentage
     * @param price Sale price of the token
     */
    struct TokenData {
        bool isListedForSale; 
        uint8 primaryArtistFee; 
        uint8 secondaryArtistFee; 
        uint8 secondaryTaexFee; 
        uint256 price; 
    }

    /// Mapping of token ID to its data
    mapping(uint256 => TokenData) public tokenData;

    /**
     * @notice Modifier that is used to check if the address is not zero.
     */
    modifier isNotZeroAddress(address _address) {
        if (_address == address(0)) revert ZeroAddress();
        _;
    }

    /**
     * @notice Modifier that is used to check if the amount is not zero.
     */
    modifier isNotZero(uint256 _amount) {
        if (_amount == 0) revert ZeroAmount();
        _;
    }

    /**
     * @notice Modifier that is used to check if the percentage is valid.
     */
    modifier isValidFeePercentage(uint256 _percentage) {
        if (_percentage > 100) revert InvalidFeePercentage();
        _;
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @dev Constructor to initialize the NFT contract with name, symbol, and fee settings.
     * @param _name Name of the NFT contract
     * @param _symbol Symbol of the NFT contract
     * @param _uri Initial base URI for token metadata
     * @param _primaryPrice Initial primary sale price for tokens
     * @param _primaryArtistFee Primary artist fee percentage
     * @param _secondaryArtistFee Secondary artist fee percentage
     * @param _secondaryTaexFee Secondary Taex fee percentage
     */
    function initialize(
        string memory _name,
        string memory _symbol,
        string memory _uri,
        uint256 _primaryPrice,
        uint8 _primaryArtistFee,
        uint8 _secondaryArtistFee,
        uint8 _secondaryTaexFee
    )
        public
        initializer
        isNotZero(_primaryPrice)
        isValidFeePercentage(_primaryArtistFee)
        isValidFeePercentage(_secondaryArtistFee + _secondaryTaexFee)
    {
        __ERC721_init(_name, _symbol);
        __Ownable_init(msg.sender);

        internalBaseURI = _uri;
        /**
         * @notice Default primary price for future tokens
         */
        tokenData[0].price = _primaryPrice; 
        tokenData[0].primaryArtistFee = _primaryArtistFee;
        tokenData[0].secondaryArtistFee = _secondaryArtistFee;
        tokenData[0].secondaryTaexFee = _secondaryTaexFee;
    }

    /**
     * @dev Returns the owner of a given token ID.
     * @param _tokenId The ID of the token to query
     * @return The address of the token owner
     */
    function ownerOfToken(uint256 _tokenId) external view returns (address) {
        return ownerOf(_tokenId);
    }


    /**
     * @dev Overrides the transferFrom function to ensure proper checks are made.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override(ITaexNFT, ERC721Upgradeable) {
        ERC721Upgradeable.transferFrom(from, to, tokenId);
    }

    /**
     * @dev Lists NFT for sale by the token's owner.
     * @param _tokenId The ID of the token to list
     * @param _price The price at which the token will be listed for sale
     */
    function listForSale(uint256 _tokenId, uint256 _price) external {
        if (ownerOf(_tokenId) != msg.sender) revert NotOwnerOfTokenId();

        tokenData[_tokenId].isListedForSale = true;
        tokenData[_tokenId].price = _price;

        emit TokenListedForSale(_tokenId, _price);
    }

    /**
     * @dev Unlists NFT from sale by the token's owner.
     * @param _tokenId The ID of the token to unlist
     */
    function unlistFromSale(uint256 _tokenId) external {
        if (ownerOf(_tokenId) != msg.sender) revert NotOwnerOfTokenId();

        tokenData[_tokenId].isListedForSale = false;

        emit TokenUnlistedFromSale(_tokenId);
    }

    /**
     * @dev Adjusts the price of an NFT by the token's owner.
     * @param _tokenId The ID of the token to adjust
     * @param _price The new price for the token
     */
    function adjustPrice(uint256 _tokenId, uint256 _price) external {
        if (ownerOf(_tokenId) != msg.sender) revert NotOwnerOfTokenId();
        if (_price == tokenData[_tokenId].price) revert NewPriceMustBeDifferent();

        tokenData[_tokenId].price = _price;

        emit TokenPriceAdjusted(_tokenId, _price);
    }

    /**
     * @dev Internal function to mint NFTs with specified fees and data.
     * @param to The address to mint the token to
     * @param _primaryArtistFee Primary artist fee percentage
     * @param _secondaryArtistFee Secondary artist fee percentage
     * @param _secondaryTaexFee Secondary Taex fee percentage
     * @return The ID of the minted token
     */
    function _mintTaex(
        address to,
        uint8 _primaryArtistFee,
        uint8 _secondaryArtistFee,
        uint8 _secondaryTaexFee
    ) internal returns (uint256) {
        _lastTokenId++;
        uint256 tokenId = _lastTokenId;

        tokenData[tokenId] = TokenData({
            isListedForSale: false,
            price: tokenData[0].price, // Default primary price
            primaryArtistFee: _primaryArtistFee,
            secondaryArtistFee: _secondaryArtistFee,
            secondaryTaexFee: _secondaryTaexFee
        });

        _safeMint(to, tokenId);

        emit TokenMinted(to, tokenId);
        return tokenId;
    }

    /**
     * @dev Public function to mint NFTs by the contract owner.
     * @param to The address to mint the token to
     * @return The ID of the minted token
     */
    function mint(
        address to
    ) external onlyOwner nonReentrant isNotZeroAddress(to) returns (uint256) {
        return
            _mintTaex(
                to,
                tokenData[0].primaryArtistFee,
                tokenData[0].secondaryArtistFee,
                tokenData[0].secondaryTaexFee
            );
    }

    /**
     * @dev Allows minting with custom fee values.
     * @param to The address to mint the token to
     * @param _primaryArtistFee Primary artist fee percentage
     * @param _secondaryArtistFee Secondary artist fee percentage
     * @param _secondaryTaexFee Secondary Taex fee percentage
     * @return The ID of the minted token
     */
    function mintWithSpecifiedFee(
        address to,
        uint8 _primaryArtistFee,
        uint8 _secondaryArtistFee,
        uint8 _secondaryTaexFee
    )
        external
        isValidFeePercentage(_primaryArtistFee)
        isValidFeePercentage(_secondaryArtistFee + _secondaryTaexFee)
        onlyOwner
        nonReentrant
        isNotZeroAddress(to)
        returns (uint256)
    {
        return
            _mintTaex(
                to,
                _primaryArtistFee,
                _secondaryArtistFee,
                _secondaryTaexFee
            );
    }

    /**
     * @dev External function to set new Base URI only by admin
     * @param newBaseUri New base URI for token metadata
     */
    function setBaseURI(string calldata newBaseUri) external onlyOwner {
        internalBaseURI = newBaseUri;
        emit SetBaseURI(newBaseUri);
    }

    /**
     * @dev External function to set default token data only by admin
     * @param _price New primary price
     * @param _primaryArtistFee New primary artist fee
     * @param _secondaryArtistFee New secondary artist fee
     * @param _secondaryTaexFee New secondary Taex fee
     */
    function setDefaultData(
        uint256 _price,
        uint8 _primaryArtistFee,
        uint8 _secondaryArtistFee,
        uint8 _secondaryTaexFee
    )
        external
        isValidFeePercentage(_primaryArtistFee)
        isValidFeePercentage(_secondaryArtistFee + _secondaryTaexFee)
        isNotZero(_price)
    {
        tokenData[0].price = _price;
        tokenData[0].primaryArtistFee = _primaryArtistFee;
        tokenData[0].secondaryArtistFee = _secondaryArtistFee;
        tokenData[0].secondaryTaexFee = _secondaryTaexFee;
        emit SetDefaultData(
            _price,
            _primaryArtistFee,
            _secondaryArtistFee,
            _secondaryTaexFee
        );
    }

    /**
     * @dev See {ERC721-tokenURI}.
     * @return The base URI for the token
     */
    function _baseURI() internal view override returns (string memory) {
        return internalBaseURI;
    }
}
