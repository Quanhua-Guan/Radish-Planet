pragma solidity ^0.8.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "base64-sol/base64.sol";

import "./ToColor.sol";

// GET LISTED ON OPENSEA: https://testnets.opensea.io/get-listed/step-two

contract YourCollectible is ERC721Enumerable, Ownable {
    using Strings for uint256;
    using Strings for uint160;
    using ToColor for bytes3;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    constructor() ERC721("Radish Planet", "RDH") {}

    mapping(uint256 => uint256) public birth;
    mapping(uint256 => bytes3) public color;
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

        color[id] =
            bytes2(predictableRandom[0]) |
            (bytes2(predictableRandom[1]) >> 8) |
            (bytes3(predictableRandom[2]) >> 16);
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
                "This Radish borns with genes of color #",
                color[id].toColor(),
                // " and size ",
                // shape[id].toString(),
                "!!!"
            )
        );
        string memory image = Base64.encode(bytes(generateSVGofTokenById(id)));
        (
            string memory leftEarColor,
            string memory rightEarColor,
            string memory faceStrokeColor,
            string memory leftEyeColor,
            string memory rightEyeColor,
            string memory noseColor,
            string memory mouthColor,
            uint256 mouthSize,
            uint256 earSize,
            uint256 noseSize
        ) = getPropertiesById(id);
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
                                '","external_url":"https://ohpandas.com/token/',
                                id.toString(),
                                '","attributes":[{"trait_type":"left ear color","value":"#',
                                leftEarColor,
                                '"},{"trait_type":"right ear color","value":"#',
                                rightEarColor,
                                '"},{"trait_type":"facial outline color","value":"#',
                                faceStrokeColor,
                                '"},{"trait_type":"left eye color","value":"#',
                                leftEyeColor,
                                '"},{"trait_type":"right eye color","value":"#',
                                rightEyeColor,
                                '"},{"trait_type":"nose color","value":"#',
                                noseColor,
                                '"},{"trait_type":"mouth color","value":"#',
                                mouthColor,
                                '"},{"trait_type":"mouth size","value":"',
                                mouthSize.toString(),
                                '"},{"trait_type":"ear size","value": "',
                                earSize.toString(),
                                '"},{"trait_type":"nose size","value": "',
                                noseSize.toString(),
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

    // function generateSVGofTokenById(uint256 id) internal view returns (string memory) {
    function generateSVGofTokenById(uint256 id)
        internal
        view
        returns (string memory)
    {
        string memory svg = string(
            abi.encodePacked(
                '<svg xmlns="http://www.w3.org/2000/svg" width="400" height="400" version="1.1" xmlns:xlink="http://www.w3.org/1999/xlink">',
                renderTokenById(id),
                "</svg>"
            )
        );
        return svg;
    }

    // properties of the token of id
    function getPropertiesById(uint256 id)
        public
        view
        returns (
            string memory leftEarColor,
            string memory rightEarColor,
            string memory faceStrokeColor,
            string memory leftEyeColor,
            string memory rightEyeColor,
            string memory noseColor,
            string memory mouthColor,
            uint256 mouthSize,
            uint256 earSize,
            uint256 noseSize
        )
    {
        uint24 theColor = uint24(color[id]);
        leftEarColor = bytes3(theColor).toColor();
        rightEarColor;
        faceStrokeColor;
        leftEyeColor;
        rightEyeColor;
        noseColor;
        mouthColor;
        mouthSize = shape[id];
        earSize = 20 + mouthSize / 2;
        noseSize = 17 + mouthSize / 8;
        unchecked {
            rightEarColor = bytes3(theColor + 0xF5F7E3).toColor();
            faceStrokeColor = bytes3(theColor + 0xDDD5ED).toColor();
            leftEyeColor = bytes3(theColor + 0xBCB5DD).toColor();
            rightEyeColor = bytes3(theColor + 0x9079A8).toColor();
            noseColor = bytes3(theColor + 0x625068).toColor();
            mouthColor = bytes3(theColor + 0x8D64A8).toColor();
        }
    }

    // Visibility is `public` to enable it being called by other contracts for composition.
    function renderTokenById(uint256 id) public view returns (string memory) {
        string memory render = string(
            abi.encodePacked(style(id), background(id), body(id))
        );
        return render;
    }

    function style(uint256 id) private view returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '<style type="text/css"><![CDATA[',
                    ".background{fill:#dad1c9;stroke:white;stroke-width:1}",
                    ".body{fill:#dc7f70;stroke:white;stroke-width:5}",
                    ".eye{fill:#e8d0d4;stroke:white;stroke-width:3}",
                    ".mouth{fill:#e8d0d4;stroke:white;stroke-width:3}",
                    ".branch{fill:#e8d0d4;stroke:white;stroke-width:4}",
                    ".bottom{stroke:white;stroke-width:3}",
                    ".leaf{fill:#efbbb6; stroke:white; stroke-width:5}",
                    "]]></style>"
                )
            );
    }

    function background(uint256 id) private view returns (string memory) {
        return
            '<rect class="background" x="1" y="1" rx="2" ry="2" width="398" height="398" />';
    }

    // generate body part
    function body(uint256 id) private view returns (string memory) {
        uint256 _shape = shape[id];

        // top point
        uint256 topX = 200;
        uint256 topY = 100;
        // bottom point
        uint256 bottomX = 200;
        uint256 bottomY = uint256(300) +
            (uint256(75) * uint256(uint8(_shape))) /
            uint256(255);
        // left point
        uint256 delta = (uint256(50) * uint256(uint8(_shape >> 8))) /
            uint256(255);
        uint256 leftX = 50 + delta;
        uint256 leftY = 200;
        // right point
        uint256 rightX = uint256(350) - delta;
        uint256 rightY = 200;

        // body type:
        // 0: circle/ellipse
        // 1: rectangle/square
        // 2: triangle
        // 3: diamond
        // 4: oval
        uint256 bodyType = uint256(_shape) % uint256(5);

        if (bodyType == 0) {
            // circle/eclipse
            uint256 cx = 200;
            uint256 cy = (topY + bottomY) / uint256(2);
            uint256 rx = (rightX - leftX) / uint256(2);
            uint256 ry = (bottomY - topY) / uint256(2);
            return
                string(
                    abi.encodePacked(
                        '<ellipse class="body" cx="',
                        cx.toString(),
                        '" cy="',
                        cy.toString(),
                        '" rx="',
                        rx.toString(),
                        '" ry="',
                        ry.toString(),
                        '"/>'
                    )
                );
        } else if (bodyType == 1) {
            // rectangle/square
            uint256 width = rightX - leftX;
            uint256 height = bottomY - topY;
            uint256 r = (((width > height ? height : width) / uint256(4)) *
                uint256(uint8(_shape >> 16))) / uint256(255);
            return
                string(
                    abi.encodePacked(
                        '<rect class="body" x="',
                        leftX.toString(),
                        '" y="',
                        topY.toString(),
                        '" width="',
                        width.toString(),
                        '" height="',
                        height.toString(),
                        '" rx="',
                        r.toString(),
                        '" ry="',
                        r.toString(),
                        '" />'
                    )
                );
        } else if (bodyType == 2) {
            // triangle
            return
                string(
                    abi.encodePacked(
                        '<polygon class="body" points="',
                        leftX.toString(),
                        ",",
                        topY.toString(),
                        " ",
                        rightX.toString(),
                        ",",
                        topY.toString(),
                        " 200,",
                        bottomY.toString(),
                        '"/>'
                    )
                );
        } else if (bodyType == 3) {
            // diamond
            return
                string(
                    abi.encodePacked(
                        '<polygon class="body" points="',
                        leftX.toString(),
                        ",",
                        leftY.toString(),
                        " ",
                        topX.toString(),
                        ",",
                        topY.toString(),
                        " ",
                        rightX.toString(),
                        ",",
                        rightY.toString(),
                        " ",
                        bottomX.toString(),
                        ",",
                        bottomY.toString(),
                        '"/>'
                    )
                );
        } else {
            // oval
            uint256 controlY = topY /
                2 +
                ((leftY - topY / 2) * uint256(uint8(_shape >> 32))) /
                uint256(255);
            return
                string(
                    abi.encodePacked(
                        '<path class="body" d="M',
                        bottomX.toString(),
                        ",",
                        bottomY.toString(),
                        " Q0,",
                        controlY.toString(),
                        " ",
                        topX.toString(),
                        ",",
                        topY.toString(),
                        " Q400,",
                        controlY.toString(),
                        " ",
                        bottomX.toString(),
                        ",",
                        bottomY.toString(),
                        ' Z"/>'
                    )
                );
        }
    }
}
