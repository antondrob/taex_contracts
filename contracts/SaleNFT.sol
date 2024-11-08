// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20; // Ensure you're using the latest compatible version

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
    address public artistTreasury;
    address public taexTreasury;
    mapping(address => bool) public whitelist;

    modifier onlyWhitelisted(address _taexNFT) {
        if (!whitelist[_taexNFT]) revert NotWhitelistedNFT();
        _;
    }

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

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

        if (ITaexNFT(_taexNFT).ownerOfToken(_tokenId) != msg.sender) {
            // TODO likely unneeded check if the transferFrom function is implemented correctly
            revert TransferNFTFailed();
        }

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
        address owner = ITaexNFT(_taexNFT).ownerOfToken(_tokenId);

        if (!isListed) revert NotListedForSale(); // Ensure token is listed for sale
        if (msg.value < price) revert InsufficientAmount(); // Validate payment

        // Transfer NFT to buyer
        ITaexNFT(_taexNFT).transferFrom(owner, msg.sender, _tokenId);

        if (ITaexNFT(_taexNFT).ownerOfToken(_tokenId) != msg.sender) {
            // TODO check is not needed if the transferFrom function is implemented correctly
            revert TransferNFTFailed();
        }

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

    function _handleNativeTransfers(
        address[] memory _to,
        uint256[] memory _amount,
        bytes4[] memory _errorSelector
    ) internal {
        for (uint256 i = 0; i < _to.length; i++) {
            _transferNativeWithError(_to[i], _amount[i], _errorSelector[i]);
        }
    }

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
