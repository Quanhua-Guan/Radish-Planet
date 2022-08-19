import { Button, List, Card, Spin, Divider } from "antd";
import React, { useState, useEffect } from "react";
import { Address, AddressInput } from "../components";
import { useContractReader } from "eth-hooks";

const { ethers } = require("ethers");

const DEBUG = false;

/**
 * web3 props can be passed from '../App.jsx' into your local view component for use
 * @param {*} yourLocalBalance balance on current network
 * @param {*} readContracts contracts from current chain already pre-loaded using ethers contract module. More here https://docs.ethers.io/v5/api/contract/contract/
 * @returns react component
 **/
function Home({
  userSigner,
  readContracts,
  writeContracts,
  tx,
  loadWeb3Modal,
  blockExplorer,
  mainnetProvider,
  address,
}) {

  const [transferToAddresses, setTransferToAddresses] = useState({});

  // 🧠 This effect will update yourCollectibles by polling when your balance changes
  const balanceContract = useContractReader(readContracts, "YourCollectible", "balanceOf", [address]);
  const [balance, setBalance] = useState();
  const [oldBalance, setOldBalance] = useState();

  const priceContract = useContractReader(readContracts, "YourCollectible", "price");
  const [price, setPrice] = useState();

  const [loading, setLoading] = useState(false);

  const limitContract = useContractReader(readContracts, "YourCollectible", "limit");
  const [limit, setLimit] = useState();

  const totalSupplyContract = useContractReader(readContracts, "YourCollectible", "totalSupply");
  const [totalSupply, setTotalSupply] = useState();

  useEffect(() => {
    if (balanceContract && (balance === undefined || !balanceContract.eq(balance))) {
      setBalance(balanceContract);
    }
  }, [balanceContract, balance]);

  useEffect(() => {
    if (priceContract && (price === undefined || !priceContract.eq(price))) {
      setPrice(priceContract);
      if (DEBUG) console.log("xxx: set price, ", price, priceContract);
    }
    if (DEBUG) console.log("xxx: price, ", price, priceContract);
  }, [priceContract, price]);

  useEffect(() => {
    if (limitContract && (limit == undefined || !limitContract.eq(limit))) {
      setLimit(limitContract);
    }
  }, [limitContract]);

  useEffect(() => {
    if (totalSupplyContract && (totalSupply == undefined || !totalSupplyContract.eq(totalSupply))) {
      setTotalSupply(totalSupplyContract);
    }
  }, [totalSupplyContract]);

  const [yourCollectibles, setYourCollectibles] = useState();

  useEffect(() => {
    const updateYourCollectibles = async () => {
      setLoading(true);
      const collectibleUpdate = [];
      for (let tokenIndex = 0; tokenIndex < balance; ++tokenIndex) {
        try {
          if (DEBUG) console.log("Getting token index " + tokenIndex);
          const tokenId = await readContracts.YourCollectible.tokenOfOwnerByIndex(address, tokenIndex);
          if (DEBUG) console.log("tokenId: " + tokenId);
          const tokenURI = await readContracts.YourCollectible.tokenURI(tokenId);
          const jsonManifestString = Buffer.from(tokenURI.substring(29), "base64").toString();
          if (DEBUG) console.log("jsonManifestString: " + jsonManifestString);

          try {
            const jsonManifest = JSON.parse(jsonManifestString);
            if (DEBUG) console.log("jsonManifest: " + jsonManifest);
            collectibleUpdate.push({ id: tokenId, uri: tokenURI, owner: address, ...jsonManifest });
          } catch (err) {
            console.log(err);
          }
        } catch (err) {
          console.log(err);
        }
      }
      setYourCollectibles(collectibleUpdate.reverse());
      setLoading(false);
    }
    if (address && balance && (oldBalance == undefined || !balance.eq(oldBalance))) {
      setOldBalance(balance);
      updateYourCollectibles();
    }
  }, [address, balance, setOldBalance, oldBalance]);

  return (
    <div>
      <div style={{ maxWidth: 820, margin: "auto", marginTop: 32 }}>
        <div style={{ fontSize: 16 }}>
          <p><strong>RADISH NFTs WILL EXIST FOREVER! THEIR SOULS ARE STORED INSIDE THE BLOCKCHAIN!</strong></p>
          <Divider />
          <p>Half Ether from sales goes to <strong><a href="https://optimistic.etherscan.io/address/0xa81a6a910FeD20374361B35C451a4a44F86CeD46" target="_blank">buidlguidl.eth</a></strong>, another half goes to the author.</p>
        </div>
      </div>
      <div style={{ maxWidth: 820, height: 50, margin: "auto" }}>
        {
          (totalSupply && limit) ?
            (<p style={{ fontWeight: "bold" }}>
              🎉 {totalSupply.toString()} OF {limit.toString()} MINTED 🎉
            </p>) : (<div />)
        }
      </div>
      <div style={{ maxWidth: 820, margin: "auto", marginTop: 0, paddingBottom: 0 }}>
        {userSigner ? (
          <div>
            <div style={{ maxWidth: 820, margin: "auto", marginTop: 0, paddingBottom: 10 }}>
              <Button type={"primary"} onClick={() => {
                if (price === undefined) return;

                tx(writeContracts.YourCollectible.mintItem({ value: price }))
              }}>MINT WITH {price ? ethers.utils.formatEther(price) : 0.001} ETH 🥳</Button>
            </div>
            <div style={{ maxWidth: 820, margin: "auto", marginTop: 0, paddingBottom: 10 }}>
              <Button type={"primary"} onClick={() => {
                if (price === undefined) return;
                tx(writeContracts.YourCollectible.mintItem({ value: price.mul(2) }))
              }}>MINT WITH {price ? ethers.utils.formatEther(price.mul(2)) : 0.002} ETH 🥰</Button>
            </div>
            <div style={{ maxWidth: 820, margin: "auto", marginTop: 0, paddingBottom: 10 }}>
              <Button type={"primary"} onClick={() => {
                if (price === undefined) return;

                tx(writeContracts.YourCollectible.mintItem({ value: price.mul(5) }))
              }}>MINT WITH {price ? ethers.utils.formatEther(price.mul(5)) : 0.005} ETH 🤩</Button>
            </div>
          </div>
        ) : (
          <Button type={"primary"} onClick={loadWeb3Modal}>CONNECT WALLET</Button>
        )}
      </div>
      <Divider />

      <div style={{ width: 820, margin: "auto", paddingBottom: 256 }}>
        {loading ? <Spin /> :
          <List
            bordered
            dataSource={yourCollectibles}
            renderItem={item => {
              const id = item.id.toNumber();

              if (DEBUG) console.log("IMAGE", item.image)

              return (
                <List.Item key={id + "_" + item.uri + "_" + item.owner}>
                  <Card
                    title={
                      <div>
                        <span style={{ fontSize: 18, marginRight: 8 }}>{item.name}</span>
                      </div>
                    }
                  >
                    {/* <a href={"https://opensea.io/assets/" + (readContracts && readContracts.YourCollectible && readContracts.YourCollectible.address) + "/" + item.id} target="_blank"> */}
                    <img src={item.image} />
                    {/* </a> */}
                    <div>{item.description}</div>
                  </Card>

                  <div>
                    owner:{" "}
                    <Address
                      address={item.owner}
                      ensProvider={mainnetProvider}
                      blockExplorer={blockExplorer}
                      fontSize={16}
                    />
                    <AddressInput
                      ensProvider={mainnetProvider}
                      placeholder="transfer to address"
                      value={transferToAddresses[id]}
                      onChange={newValue => {
                        const update = {};
                        update[id] = newValue;
                        setTransferToAddresses({ ...transferToAddresses, ...update });
                      }}
                    />
                    <Button
                      onClick={() => {
                        if (DEBUG) console.log("writeContracts", writeContracts);
                        tx(writeContracts.YourCollectible.transferFrom(address, transferToAddresses[id], id));
                      }}
                    >
                      Transfer
                    </Button>
                  </div>
                </List.Item>
              );
            }}
          />}
      </div>
    </div >
  );
}

export default Home;
