const { ethers, upgrades } = require("hardhat");

async function upgradeSaleNFT() {
    let proxyAddress = "0xF06bCA98c3d2c2a315eE59eabdD9D7e755c712C9";
    const SaleNFTContract = await ethers.getContractFactory("SaleNFT");
    const taexNFT = await upgrades.upgradeProxy(proxyAddress, SaleNFTContract);

    console.log("SaleNFT was upgraded ");

    const SaleNFTContractImplAddress =
        await upgrades.erc1967.getImplementationAddress(proxyAddress);
    console.log(
        `New SaleNFT Implementation Contract Address: ${SaleNFTContractImplAddress}`
    );
}

upgradeSaleNFT();

module.exports = upgradeSaleNFT;
