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

/*
Rinkeby

deploying "RDHStrings" (tx: 0xddc442f940f828dcd89c6f8b6243105866180653cf2d036be5d936c6834d1d5d)...: deployed at 0xC357A390a7Fd8a6AbE2853A6CDa36FeC6B2e7dB8 with 262650 gas
deploying "SVGen" (tx: 0x73fbba2e59f78596fada75ab3eda0d15307510673bae763c9e41fcb0cdf7d77f)...: deployed at 0x3f9Ea80C24Cb9B166Dc4B70E8e91256439F0b496 with 2172144 gas
deploying "SVGenBody" (tx: 0x7afe8a641d45b5b3f0b5713b698941390f0964f1e9d629cc49e67da248ba683e)...: deployed at 0x05EdDba502D1437c2ae62B84d8F2ACf79228a704 with 1036054 gas
deploying "SVGenEye" (tx: 0xddf8bcc0b9fd1818f3c6f2e3166a989ba0eb161b2d30cb0f49c3bbcc24d38499)...: deployed at 0x8751D09949D15FB5ecDc40073EE6788b01578Ed4 with 4507402 gas
deploying "SVGenMouth" (tx: 0x396ffce0200a1a0c1824777d327f9ab308d8baeb5eb09b0a60230f2981103363)...: deployed at 0x47E9e382C42Cf9e7905B9FF2849be3BC7373b5CA with 878308 gas
deploying "SVGenLeaf" (tx: 0xd0efd36beaf09fabf9f72656612bf7da83f47f9bae596c459603e1a97b39bf6d)...: deployed at 0xb9c608CEc5d7639faff32b2492f870a6d37Ce3a2 with 2058694 gas
deploying "SVGenStyle" (tx: 0xfbe0828bd8b6282f15c5c0fce5f19d2bbf4dde295602806d37ab109099987a21)...: deployed at 0x113Bad6Fb5D551dA4C741Aa748CCE497dd3f166c with 521312 gas
deploying "YourCollectible" (tx: 0x16171bd7edb7f7058f97136dd4807555080c2c8f8ddea59188d8bc30fbcdd13e)...: deployed at 0x887a0aeC0297D866886bF3616c7059dBF079e991 with 2472409 gas
*/