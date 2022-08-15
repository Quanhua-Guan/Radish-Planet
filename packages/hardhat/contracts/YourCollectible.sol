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
    mapping(uint256 => uint256) public shape;

    uint256 mintDeadline = block.timestamp + 3650 days;

    function mintItem() public returns (uint256) {
        require(block.timestamp < mintDeadline, "DONE MINTING");
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

        shape[id] = uint256(predictableRandom);
        birth[id] = block.timestamp;

        return id;
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        require(_exists(id), "!exist");

        string memory name = string(
            abi.encodePacked("Radish #", id.toString())
        );
        string memory description = string(
            abi.encodePacked(
                "This Radish borns with svgen.genes of color #",
                "!!!"
            )
        );
        uint256 _shape = shape[id];
        string memory image = Base64.encode(
            abi.encodePacked(
                '<svg xmlns="http://www.w3.org/2000/svg" width="400" height="400" version="1.1">',
                SVGenStyle.style(_shape),
                '<rect class="background" x="1" y="1" rx="2" ry="2" width="398" height="398" />',
                SVGenLeaf.leafs(_shape),
                SVGenBody.body(_shape),
                SVGenEye.eyes(_shape),
                SVGenMouth.mouth(_shape),
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
                                '","external_url":"https://radishplanet.com/token/',
                                id.toString(),
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
