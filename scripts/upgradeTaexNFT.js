const { ethers, upgrades } = require("hardhat");

async function upgradeTaexNFT() {
    let proxyAddress = "0xF06bCA98c3d2c2a315eE59eabdD9D7e755c712C9";
    const TaexNFTContract = await ethers.getContractFactory("TaexNFT");
    const taexNFT = await upgrades.upgradeProxy(proxyAddress, TaexNFTContract);

    console.log("taexNFT was upgraded ");

    const TaexNFTContractImplAddress =
        await upgrades.erc1967.getImplementationAddress(proxyAddress);
    console.log(
        `New TaexNFT Implementation Contract Address: ${TaexNFTContractImplAddress}`
    );
}

upgradeTaexNFT();

module.exports = upgradeTaexNFT;
