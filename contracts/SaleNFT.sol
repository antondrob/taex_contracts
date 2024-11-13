// SPDX-License-Identifier: MIT
pragma solidity 0.8.25; 

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {ReentrancyGuardTransientUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardTransientUpgradeable.sol";
import {ITaexNFT} from "./interfaces/ITaexNFT.sol";
import {ISaleNFT} from "./interfaces/ISaleNFT.sol";

/**
 * @title SaleNFT
 * @dev Contract for handling the sale of NFTs, including primary and secondary sales.
 */
contract SaleNFT is
    OwnableUpgradeable,
    ReentrancyGuardTransientUpgradeable,
    ISaleNFT
{
    /// @notice Address of the artist treasury
    address public artistTreasury;
    /// @notice Address of the Taex treasury
    address public taexTreasury;
    /// @notice Mapping of whitelisted NFT contracts
    mapping(address => bool) public whitelist;

    /**
     * @notice modifier to check if the NFT contract is whitelisted.
     */
    modifier onlyWhitelisted(address _taexNFT) {
        if (!whitelist[_taexNFT]) revert NotWhitelistedNFT();
        _;
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /**
     * @notice Initializes the contract with the artist and Taex treasuries.
     * @param _artistTreasury The address of the artist treasury.
     * @param _taexTreasury  The address of the Taex treasury.
     */
    function initialize(
        address _artistTreasury,
        address _taexTreasury
    ) public initializer {
        __Ownable_init(msg.sender);
        artistTreasury = _artistTreasury;
        taexTreasury = _taexTreasury;
    }

    /**
     * @dev Executes the primary sale of an NFT.
     * @param _taexNFT The address of the NFT contract.
     * @param _tokenId The ID of the token being sold.
     */
    function primarySale(
        address _taexNFT,
        uint256 _tokenId
    ) external payable nonReentrant onlyWhitelisted(_taexNFT) {
        // Retrieve token data
        (, uint8 primaryArtistFee, , , uint256 price) = ITaexNFT(_taexNFT)
            .tokenData(_tokenId);
        address owner = ITaexNFT(_taexNFT).ownerOfToken(_tokenId);

        if (msg.value < price) revert InsufficientAmount(); // Validate payment

        // Transfer NFT to buyer
        ITaexNFT(_taexNFT).transferFrom(owner, msg.sender, _tokenId);

        // Calculate fees
        uint256 artistFeeAmount = (price * primaryArtistFee) / 100;

        // Pay artist treasury
        _transferNativeWithError(
            artistTreasury,
            artistFeeAmount,
            ISaleNFT.TransferETHToArtistFailed.selector
        );

        // Pay Taex treasury
        _transferNativeWithError(
            taexTreasury,
            price - artistFeeAmount,
            ISaleNFT.TransferETHToTaexFailed.selector
        );
        // Refund excess ETH if sent more than required
        if (msg.value > price) {
            payable(msg.sender).transfer(msg.value - price);
        }

        emit PrimarySale(_taexNFT, _tokenId, msg.sender);
    }

    /**
     * @dev Executes the secondary sale of an NFT.
     * @param _taexNFT The address of the NFT contract.
     * @param _tokenId The ID of the token being sold.
     */
    function secondarySale(
        address _taexNFT,
        uint256 _tokenId
    ) external payable nonReentrant onlyWhitelisted(_taexNFT) {
        // Retrieve token data
        (
            bool isListed,
            ,
            uint8 secondaryArtistFee,
            uint8 secondaryTaexFee,
            uint256 price
        ) = ITaexNFT(_taexNFT).tokenData(_tokenId);
        // Ensure token is listed for sale
        if (!isListed) revert NotListedForSale(); 
        // Validate payment
        if (msg.value < price) revert InsufficientAmount(); 
        
        address owner = ITaexNFT(_taexNFT).ownerOfToken(_tokenId);

        // Transfer NFT to buyer
        ITaexNFT(_taexNFT).transferFrom(owner, msg.sender, _tokenId);

        // Calculate fees
        uint256 artistFeeAmount = (price * secondaryArtistFee) / 100;
        uint256 taexFeeAmount = (price * secondaryTaexFee) / 100;

        // Pay seller (owner)
        _transferNativeWithError(
            owner,
            (price - artistFeeAmount - taexFeeAmount),
            ISaleNFT.TransferETHToOwnerFailed.selector
        );

        // Pay artist treasury
        _transferNativeWithError(
            artistTreasury,
            artistFeeAmount,
            ISaleNFT.TransferETHToArtistFailed.selector
        );

        // Pay Taex treasury
        _transferNativeWithError(
            taexTreasury,
            taexFeeAmount,
            ISaleNFT.TransferETHToTaexFailed.selector
        );

        // Refund excess ETH if sent more than required
        if (msg.value > price) {
            payable(msg.sender).transfer(msg.value - price);
        }

        emit SecondarySale(_taexNFT, _tokenId, msg.sender);
    }

    /**
     * @dev Withdraws ETH from the contract to a specified address.
     * @param to The address to withdraw ETH to.
     */
    function withdrawETH(address to) external onlyOwner {
        uint256 balance = address(this).balance;
        if (balance == 0) revert NoExistETHTowithdraw();

        _transferNativeWithError(
            to,
            balance,
            ISaleNFT.TransferETHToWithdrawFailed.selector
        );

        emit ETHWithdrawn(to, balance);
    }

    /**
     * @dev Sets the artist treasury address.
     * @param _artistTreasury The new artist treasury address.
     */
    function setArtistTreasury(address _artistTreasury) external onlyOwner {
        artistTreasury = _artistTreasury;
        emit SetArtistTreasury(_artistTreasury);
    }

    /**
     * @dev Sets the Taex treasury address.
     * @param _taexTreasury The new Taex treasury address.
     */
    function setTaexTreasury(address _taexTreasury) external onlyOwner {
        taexTreasury = _taexTreasury;
        emit SetTaexTreasury(_taexTreasury);
    }

    /**
     * @dev Adds a contract address to the whitelist.
     * @param _contract The address of the contract to whitelist.
     */
    function addToWhitelist(address _contract) external onlyOwner {
        whitelist[_contract] = true;
        emit AddToWhitelist(_contract);
    }

    /**
     * @dev Removes a contract address from the whitelist.
     * @param _contract The address of the contract to remove from the whitelist.
     */
    function removeFromWhitelist(address _contract) external onlyOwner {
        whitelist[_contract] = false;
        emit RemoveFromWhitelist(_contract);
    }

    /**
     * Function used to transfer ETH to a specified address. And emit a specified error if the transfer fails.
     * @param _to The address for eth transfer
     * @param _amount The amount of eth to transfer 
     * @param _errorSelector The error to emit if the transfer fails
     */
    function _transferNativeWithError(
        address _to,
        uint256 _amount,
        bytes4 _errorSelector
    ) internal {
        if (_amount > 0) {
            (bool success, ) = payable(_to).call{value: _amount}("");
            if (!success) {
                assembly {
                    mstore(0, _errorSelector)
                    revert(0, 0x04)
                }
            }
        }
    }
}
