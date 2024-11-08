const { ethers, upgrades } = require("hardhat");

async function deploySaleNFT() {
    let artistTreasury = "";
    let taexTreasury = "";
    const SaleNFT = await ethers.getContractFactory("TaexNFT1155");
    const SaleNFTProxy = await upgrades.deployProxy(SaleNFT, [
        artistTreasury,
        taexTreasury,
    ]);
    await SaleNFTProxy.waitForDeployment();

    const SaleNFTProxyAddress = await SaleNFTProxy.getAddress();
    console.log(`SaleNFT Proxy was deployted at ${SaleNFTProxyAddress}`);

    // Retrieve the implementation address using ERC-1967 standard functions.
    // ERC-1967 standardizes proxy storage slots to safely manage upgrades of contract implementations.
    // This ensures compatibility and safe upgrade paths for proxy contracts.
    // More info on ERC-1967: https://eips.ethereum.org/EIPS/eip-1967
    const SaleNFTContractImplAddress =
        await upgrades.erc1967.getImplementationAddress(SaleNFTProxyAddress);
    console.log(
        `SaleNFT Implementation Contract Address: ${SaleNFTContractImplAddress}`
    );
}

deploySaleNFT()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

module.exports = deploySaleNFT;
