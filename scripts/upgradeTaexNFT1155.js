const { ethers, upgrades } = require("hardhat");

async function upgradeTaexNFT1155() {
    let proxyAddress = "0xF06bCA98c3d2c2a315eE59eabdD9D7e755c712C9";
    const TaexNFT1155Contract = await ethers.getContractFactory("TaexNFT1155");
    const taexNFT = await upgrades.upgradeProxy(
        proxyAddress,
        TaexNFT1155Contract
    );

    console.log("taexNFT1155 was upgraded ");

    const TaexNFT1155ContractImplAddress =
        await upgrades.erc1967.getImplementationAddress(proxyAddress);
    console.log(
        `New TaexNFT1155 Implementation Contract Address: ${TaexNFT1155ContractImplAddress}`
    );
}

upgradeTaexNFT1155();

module.exports = upgradeTaexNFT1155;
