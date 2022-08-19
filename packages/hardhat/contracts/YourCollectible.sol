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
    uint256 public limit = 99999;
    uint256 public price = 0.001 ether;

    // half funds go to buidlguidl.eth
    address payable public constant buidlguidl =
        payable(0xa81a6a910FeD20374361B35C451a4a44F86CeD46);

    function mintItem() public payable returns (uint256) {
        // At most 99999 Radish NFTs
        require(_tokenIds.current() <= limit, "LIMIT");
        require(msg.value >= price, "0.001 Ether");

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

        // half to owner
        (bool success0, ) = payable(owner()).call{value: (msg.value / 2)}("");
        require(success0, "!PAY0");

        // half to buidlguidl
        (bool success1, ) = buidlguidl.call{
            value: (msg.value - (msg.value / 2))
        }("");
        require(success1, "!PAY1");

        return id;
    }

    function updateLimit(uint256 _limit) public onlyOwner {
        require(_limit > limit, "!IL");
        limit = _limit;
    }

    function updatePrice(uint256 _price) public onlyOwner {
        price = _price;
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
                SVGenStyle.style(gene, block.timestamp - birth[id]),
                '<rect class="background" x="1" y="1" rx="3" ry="3" width="398" height="398" />',
                SVGenLeaf.leafs(gene),
                SVGenBody.body(gene),
                SVGenEye.eyes(gene),
                SVGenMouth.mouth(gene),
                "</svg>"
            )
        );

        uint256 body = uint256(gene) % uint256(5);
        bool differentEyes = (uint256(uint8(gene >> 32)) % uint256(1000)) ==
            uint256(0);
        uint256 leftEye = uint256(uint8(gene >> 40)) % uint256(44);
        uint256 rightEye = differentEyes
            ? uint256(uint8(gene >> 64)) % uint256(44)
            : leftEye;
        uint256 mouth = uint256(uint8(gene >> 72)) % uint256(14);
        uint256 leafsCount = uint256(1) +
            (uint256(uint8(gene >> 104)) % uint256(5));
        bool hasColorChangingLeaf = uint256(uint8(gene >> 124)) %
            uint256(1000) ==
            0;

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
                                '","attributes":[{"trait_type":"body","value":"B-',
                                body.toString(),
                                '"},{"trait_type":"left eye","value":"E-',
                                leftEye.toString(),
                                '"},{"trait_type":"right eye","value":"E-',
                                rightEye.toString(),
                                '"},{"trait_type":"different eyes","value":"',
                                differentEyes ? "YES(1/1000)" : "NO",
                                '"},{"trait_type":"mouth","value":"M-',
                                mouth.toString(),
                                '"},{"trait_type":"leafs","value":"',
                                leafsCount.toString(),
                                '"},{"trait_type":"color-changing leaf","value":"',
                                hasColorChangingLeaf ? "HAS(1/1000)" : "NONE",
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
