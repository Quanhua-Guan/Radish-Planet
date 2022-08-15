// deploy/00_deploy_your_contract.js

const { ethers } = require("hardhat");

const localChainId = "31337";

module.exports = async ({ getNamedAccounts, deployments, getChainId }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  const stringLib = await deploy("RDHStrings", {
    from: deployer,
    log: true,
  });

  const SVGenLib = await deploy("SVGen", {
    from: deployer,
    log: true,
    libraries: {
      RDHStrings: stringLib.address
    }
  });

  const SVGenBodyLib = await deploy("SVGenBody", {
    from: deployer,
    log: true,
    libraries: {
      RDHStrings: stringLib.address,
      SVGen: SVGenLib.address,
    }
  });

  const SVGenEyeLib = await deploy("SVGenEye", {
    from: deployer,
    log: true,
    libraries: {
      RDHStrings: stringLib.address,
      SVGen: SVGenLib.address,
    }
  });

  const SVGenMouthLib = await deploy("SVGenMouth", {
    from: deployer,
    log: true,
    libraries: {
      RDHStrings: stringLib.address,
      SVGen: SVGenLib.address,
    }
  });

  const SVGenLeafLib = await deploy("SVGenLeaf", {
    from: deployer,
    log: true,
    libraries: {
      RDHStrings: stringLib.address,
      SVGen: SVGenLib.address,
    }
  });

  const SVGenStyleLib = await deploy("SVGenStyle", {
    from: deployer,
    log: true,
    libraries: {
      RDHStrings: stringLib.address,
    },
  });
  
  await deploy("YourCollectible", {
    // Learn more about args here: https://www.npmjs.com/package/hardhat-deploy#deploymentsdeploy
    from: deployer,
    log: true,
    libraries: {
      RDHStrings: stringLib.address,
      SVGenBody: SVGenBodyLib.address,
      SVGenEye: SVGenEyeLib.address,
      SVGenMouth: SVGenMouthLib.address,
      SVGenLeaf: SVGenLeafLib.address,
      SVGenStyle: SVGenStyleLib.address,
    }
  });

  // Verify from the command line by running `yarn verify`

  // You can also Verify your contracts with Etherscan here...
  // You don't want to verify on localhost
  // try {
  //   if (chainId !== localChainId) {
  //     await run("verify:verify", {
  //       address: YourCollectible.address,
  //       contract: "contracts/YourCollectible.sol:YourCollectible",
  //       constructorArguments: [],
  //     });
  //   }
  // } catch (error) {
  //   console.error(error);
  // }
};
module.exports.tags = ["YourCollectible"];