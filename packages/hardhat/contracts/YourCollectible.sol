pragma solidity ^0.8.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "base64-sol/base64.sol";

import "./RDHStrings.sol";
import "./SVGenStyle.sol";
import "./SVGenBody.sol";
import "./SVGenEye.sol";
import "./SVGenMouth.sol";
import "./SVGenLeaf.sol";

contract YourCollectible is ERC721Enumerable, Ownable {
    using RDHStrings for uint160;
    using RDHStrings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    constructor() ERC721("Radish Planet", "RDH") {}

    mapping(uint256 => uint256) public birth;
    mapping(uint256 => uint256) public genes;

    function mintItem() public returns (uint256) {
        // At most 99999 Radish NFTs
        require(_tokenIds.current() <= 99999, "DONE");
        _tokenIds.increment();

        uint256 id = _tokenIds.current();
        _mint(msg.sender, id);

        bytes32 predictableRandom = keccak256(
            abi.encodePacked(
                blockhash(block.number - 1),
                msg.sender,
                address(this),
                block.chainid,
                id
            )
        );

        genes[id] = uint256(predictableRandom);
        birth[id] = block.timestamp;

        return id;
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        require(_exists(id), "!EXIST");

        bytes memory name = abi.encodePacked("Radish #", id.toString());
        bytes memory description = abi.encodePacked(
            "I am Radish #",
            id.toString(),
            ", all is well!"
        );
        uint256 gene = genes[id];
        string memory image = Base64.encode(
            abi.encodePacked(
                '<svg xmlns="http://www.w3.org/2000/svg" width="400" height="400" version="1.1">',
                SVGenStyle.style(gene),
                '<rect class="background" x="1" y="1" rx="3" ry="3" width="398" height="398" />',
                SVGenLeaf.leafs(gene),
                SVGenBody.body(gene),
                SVGenEye.eyes(gene),
                SVGenMouth.mouth(gene),
                "</svg>"
            )
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                name,
                                '","description":"',
                                description,
                                '","attributes":[{"trait_type":"left ear color","value":"#',
                                '"}],"owner":"',
                                (uint160(ownerOf(id))).toHexString(20),
                                '","image": "',
                                "data:image/svg+xml;base64,",
                                image,
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}
