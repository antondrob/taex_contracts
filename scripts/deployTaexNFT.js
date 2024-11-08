const { ethers, upgrades } = require("hardhat");

async function deployTaexNFT() {
    let name = "TaexNFTTest";
    let symbol = "TNFTT";
    let uri = "";
    let primaryPrice = ethers.parseEther("0.1");
    let primaryArtistFee = 10;
    let secondaryArtistFee = 25;
    let secondaryTaexFee = 15;
    const TaexNFTContract = await ethers.getContractFactory("TaexNFT");
    const TaexNFTProxy = await upgrades.deployProxy(TaexNFTContract, [
        name,
        symbol,
        uri,
        primaryPrice,
        primaryArtistFee,
        secondaryArtistFee,
        secondaryTaexFee,
    ]);

    await TaexNFTProxy.waitForDeployment();

    const TaexNFTProxyAddress = await TaexNFTProxy.getAddress();
    console.log(`TaexNFT Proxy was deployted at ${TaexNFTProxyAddress}`);

    // Retrieve the implementation address using ERC-1967 standard functions.
    // ERC-1967 standardizes proxy storage slots to safely manage upgrades of contract implementations.
    // This ensures compatibility and safe upgrade paths for proxy contracts.
    // More info on ERC-1967: https://eips.ethereum.org/EIPS/eip-1967
    const TaexNFTContractImplAddress =
        await upgrades.erc1967.getImplementationAddress(TaexNFTProxyAddress);
    console.log(
        `TaexNFT Implementation Contract Address: ${TaexNFTContractImplAddress}`
    );
}

deployTaexNFT()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

module.exports = deployTaexNFT;
