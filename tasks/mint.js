require("@nomiclabs/hardhat-ethers");
const { ethers } = require("ethers");
const contract = require("../artifacts/contracts/Marketplace.sol/Marketplace.json");

task("createItem", "mints nft")
  .addParam("uri" , "uri")
  .setAction(async (taskArgs) => {
    const PRIVATE_KEY = process.env.PRIVATE_KEY;
    const API_KEY = process.env.API_KEY;
    const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS;  

    const infuraProvider = new ethers.providers.InfuraProvider(network = "rinkeby", API_KEY);
    const signer = new ethers.Wallet(PRIVATE_KEY, infuraProvider);
    const CharityContract = new ethers.Contract(CONTRACT_ADDRESS, contract.abi, signer);
    const tx = await CharityContract.createItem(taskArgs.uri);
    
    console.log(tx);
  });

module.exports = {};