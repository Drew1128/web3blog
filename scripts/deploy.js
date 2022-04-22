const hre = require("hardhat");
const fs = require("fs");
const { network } = require("hardhat");

async function main() {
 
  const Blog = await hre.ethers.getContractFactory("Blog");
  const blog = await Blog.deploy("My web3 blog");

  await blog.deployed();
  console.log("Blog deployed to:", blog.address);
  console.log(network);

  
  fs.writeFileSync('./config.js', `
  export const contractAddress = "${blog.address}"
  export const ownerAddress = "${blog.signer.address}"
  `);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error, "catch is working");
    process.exit(1);
  });
