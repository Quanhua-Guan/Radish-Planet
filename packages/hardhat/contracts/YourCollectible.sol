pragma solidity ^0.8.0;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "base64-sol/base64.sol";

import "./ToColor.sol";

contract YourCollectible is ERC721Enumerable, Ownable {
    using Strings for uint256;
    using Strings for uint160;
    using ToColor for bytes3;
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
            abi.encodePacked("This Radish borns with genes of color #", "!!!")
        );
        string memory image = Base64.encode(
            abi.encodePacked(
                '<svg xmlns="http://www.w3.org/2000/svg" width="400" height="400" version="1.1">',
                style(id),
                background(),
                body(id),
                eyes(id),
                mouth(id),
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

    function style(uint256 id) private view returns (bytes memory) {
        bytes32 _shape = bytes32(shape[id]);
        bytes3 _color = bytes2(_shape[0]) |
            (bytes2(_shape[1]) >> 8) |
            (bytes3(_shape[2]) >> 16);
        bytes3 backgroundColor = _color;

        return
            abi.encodePacked(
                '<style type="text/css"><![CDATA[',
                // background
                ".background{fill:#",
                backgroundColor.toColor(),
                ";stroke:white;stroke-width:1;fill-opacity:0.2}",
                // body
                ".body{fill:#",
                _color.toColor(),
                ";stroke:white;stroke-width:5}",
                // eye
                ".eye_l{fill:#e8d0d4;stroke:white;stroke-width:3}",
                ".eye_r{fill:#e8d0d4;stroke:white;stroke-width:3}",
                ".eye_c{fill:#e8d0d4;stroke:white;stroke-width:1}",
                ".eye_opacity{fill:#e8d0d4;stroke:white;stroke-width:3;fill-opacity:0.3}",
                // mouth
                ".mouth{fill:#e8d0d4;stroke:white;stroke-width:3}",
                ".mouth_opacity{fill:#e8d0d4;stroke:white;stroke-width:3;fill-opacity:0.3}",
                // branch
                ".branch{fill:#e8d0d4;stroke:white;stroke-width:4}",
                // leaf
                ".leaf{fill:#efbbb6; stroke:white; stroke-width:5}",
                // bottom
                ".bottom{stroke:white;stroke-width:3}",
                "]]></style>"
            );
    }

    function background() private pure returns (string memory) {
        return
            '<rect class="background" x="1" y="1" rx="2" ry="2" width="398" height="398" />';
    }

    // generate body part
    function body(uint256 id) private view returns (bytes memory) {
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
                );
        } else if (bodyType == 1) {
            // rectangle/square
            uint256 width = rightX - leftX;
            uint256 height = bottomY - topY;
            uint256 r = (((width > height ? height : width) / uint256(4)) *
                uint256(uint8(_shape >> 16))) / uint256(255);
            return
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
                );
        } else if (bodyType == 2) {
            // triangle
            return
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
                );
        } else if (bodyType == 3) {
            // diamond
            return
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
                );
        } else {
            // oval
            uint256 controlY = topY /
                2 +
                ((leftY - topY / 2) * uint256(uint8(_shape >> 24))) /
                uint256(255);
            return
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
                );
        }
    }

    // generate eyes
    function eyes(uint256 id) private view returns (bytes memory) {
        uint256 _shape = shape[id];
        bool hasSameEyes = (uint256(uint8(_shape >> 32)) % uint256(1000)) ==
            uint256(0);
        uint256 totalEyeType = 44;
        uint256 eyeType = uint256(uint8(_shape >> 40)) % totalEyeType;

        uint256 lx = 150;
        uint256 rx = 250;
        uint256 y = uint256(150) +
            (uint256(50) * uint256(uint8(_shape >> 48))) /
            uint256(255);
        uint256 eyeSize = uint256(20) +
            (uint256(20) * uint256(uint8(_shape >> 56))) /
            uint256(255);

        if (hasSameEyes) {
            return
                abi.encodePacked(
                    eye(eyeType, eyeSize, lx, y, true),
                    eye(eyeType, eyeSize, rx, y, false)
                );
        } else {
            uint256 eyeTypeAnother = uint256(uint8(_shape >> 64)) %
                totalEyeType;
            return
                abi.encodePacked(
                    eye(eyeType, eyeSize, lx, y, true),
                    eye(eyeTypeAnother, eyeSize, rx, y, false)
                );
        }
    }

    // generate single eye
    function eye(
        uint256 eyeType,
        uint256 eyeSize,
        uint256 x,
        uint256 y,
        bool isLeft
    ) private pure returns (bytes memory) {
        bytes memory emptyStringBytes = abi.encodePacked("");
        string memory eyeClass = isLeft ? "eye_l" : "eye_r";
        uint256 r = eyeSize / uint256(2);
        if (eyeType == 0) {
            return
                abi.encodePacked(
                    genCircle(x, y, r, eyeClass),
                    genCircle(x, y, uint256(3), eyeClass)
                );
        } else if (eyeType == 1) {
            return genHalfCircle(x, y, r, true, false, eyeClass);
        } else if (eyeType >= 2 && eyeType <= 4) {
            return
                abi.encodePacked(
                    genCircle(x, y, eyeSize / 2, eyeClass),
                    eyeType >= 3
                        ? genCircle(x, y, eyeSize / 4, eyeClass)
                        : emptyStringBytes,
                    eyeType == 4
                        ? genCircle(x, y, eyeSize / 8, "eye_c")
                        : emptyStringBytes
                );
        } else if (eyeType >= 5 && eyeType <= 7) {
            uint256 cornerRadius = uint256(eyeSize % 2 == 0 ? 0 : 3);
            return
                abi.encodePacked(
                    genRect(
                        x,
                        y,
                        eyeSize,
                        eyeSize,
                        cornerRadius,
                        cornerRadius,
                        eyeClass
                    ),
                    eyeType >= 6
                        ? genRect(
                            x,
                            y,
                            eyeSize / uint256(2),
                            eyeSize / uint256(2),
                            cornerRadius,
                            cornerRadius,
                            eyeClass
                        )
                        : emptyStringBytes,
                    eyeType >= 7
                        ? genRect(
                            x,
                            y,
                            eyeSize / uint256(4),
                            eyeSize / uint256(4),
                            1,
                            1,
                            "eye_c"
                        )
                        : emptyStringBytes
                );
        } else if (eyeType == 8 || eyeType == 9) {
            return
                abi.encodePacked(
                    genDownTriangle(x, y, r, eyeClass),
                    eyeType == 9
                        ? genLine(x, y + r, x, y - r, eyeClass)
                        : emptyStringBytes
                );
        } else if (eyeType == 10 || eyeType == 11) {
            return
                abi.encodePacked(
                    genUpTriangle(x, y, r, eyeClass),
                    eyeType == 11
                        ? genLine(x, y + r, x, y - r, eyeClass)
                        : emptyStringBytes
                );
        } else if (eyeType == 12) {
            uint256 rr = r - 5;
            return
                abi.encodePacked(
                    genCircle(x, y, r, eyeClass),
                    genRhombus(x, y, rr, eyeClass)
                );
        } else if (eyeType == 13 || eyeType == 14) {
            return
                abi.encodePacked(
                    eyeType == 14
                        ? genCircle(x, y, r, eyeClass)
                        : emptyStringBytes,
                    genLine(x, y + r, x, y - r, eyeClass),
                    genLine(x - r, y, x + r, y, eyeClass)
                );
        } else if (eyeType >= 15 && eyeType <= 17) {
            return
                abi.encodePacked(
                    eyeType == 15 || eyeType == 16
                        ? genUpArrow(x, y, r, "eye_opacity")
                        : emptyStringBytes,
                    eyeType == 17 || eyeType == 16
                        ? genDownArrow(x, y, r, "eye_opacity")
                        : emptyStringBytes
                );
        } else if (eyeType == 18 || eyeType == 19) {
            uint256 rr = r / uint256(2);
            return
                abi.encodePacked(
                    eyeType == 19
                        ? genCircle(x, y, r, eyeClass)
                        : emptyStringBytes,
                    genLine(x - rr, y - rr, x + rr, y + rr, eyeClass),
                    genLine(x - rr, y + rr, x + rr, y - rr, eyeClass)
                );
        } else if (eyeType == 20 || eyeType == 21) {
            uint256 rr = r / uint256(2);
            return
                abi.encodePacked(
                    genRect(x, y, eyeSize, eyeSize, 0, 0, "eye_opacity"),
                    eyeType == 20
                        ? genRect(x - rr, y - rr, r, r, 0, 0, "eye_opacity")
                        : genRect(x - rr, y + rr, r, r, 0, 0, "eye_opacity"),
                    eyeType == 20
                        ? genRect(x + rr, y + rr, r, r, 0, 0, "eye_opacity")
                        : genRect(x + rr, y - rr, r, r, 0, 0, "eye_opacity")
                );
        } else if (eyeType == 22 || eyeType == 23) {
            uint256 rr = r - uint256(5);
            return
                abi.encodePacked(
                    eyeType == 23
                        ? genCircle(x, y, r, eyeClass)
                        : emptyStringBytes,
                    genLine(x - rr, y, x + rr, y, eyeClass)
                );
        } else if (eyeType == 24) {
            uint256 rr = r / uint256(4);
            return
                abi.encodePacked(
                    genLine(x - r, y - rr, x + r, y - rr, eyeClass),
                    genLine(x - r, y + rr, x + r, y + rr, eyeClass),
                    genLine(x - rr, y - r, x - rr, y + r, eyeClass),
                    genLine(x + rr, y - r, x + rr, y + r, eyeClass)
                );
        } else if (eyeType >= 25 && eyeType <= 27) {
            return
                abi.encodePacked(
                    genRhombus(x, y, r, eyeClass),
                    eyeType == 25
                        ? genLine(x - r, y, x + r, y, eyeClass)
                        : emptyStringBytes,
                    eyeType == 25
                        ? genLine(x, y - r, x, y + r, eyeClass)
                        : emptyStringBytes,
                    eyeType == 26
                        ? genCircle(x, y, 3, eyeClass)
                        : emptyStringBytes,
                    eyeType == 27
                        ? genRhombus(x, y, r / uint256(2), eyeClass)
                        : emptyStringBytes
                );
        } else if (eyeType == 28 || eyeType == 29) {
            uint256 rr = r / uint256(2);
            return
                abi.encodePacked(
                    genCircle(x, y, r, eyeClass),
                    eyeType == 28
                        ? genRect(x, y, rr, rr, 0, 0, eyeClass)
                        : genUpTriangle(x, y, rr, eyeClass)
                );
        } else if (eyeType == 30 || eyeType == 31) {
            return genHeart(x, y, r, eyeType == 30, eyeClass);
        } else if (eyeType == 32 || eyeType == 33) {
            uint256 rr = r / uint256(2);
            return
                abi.encodePacked(
                    genRect(x, y, eyeSize, eyeSize, 0, 0, eyeClass),
                    eyeType == 32
                        ? genLine(x - rr, y, x + rr, y, eyeClass)
                        : genLine(x, y - rr, x, y + rr, eyeClass)
                );
        } else if (eyeType == 34) {
            uint256 rr = (r * uint256(3)) / uint256(4);
            return
                abi.encodePacked(
                    genUpTriangle(x, y, rr, "eye_opacity"),
                    genDownTriangle(x, y, rr, "eye_opacity")
                );
        } else if (eyeType == 35 || eyeType == 36) {
            uint256 rr = r / uint256(2);
            return
                abi.encodePacked(
                    genRhombus(x, y, r, eyeClass),
                    eyeType == 35
                        ? genLine(x - rr, y, x + rr, y, eyeClass)
                        : genLine(x, y - rr, x, y + rr, eyeClass)
                );
        } else if (eyeType == 37 || eyeType == 38) {
            uint256 rr = r / uint256(2);
            return
                abi.encodePacked(
                    eyeType == 37
                        ? genCircle(x, y, r, eyeClass)
                        : emptyStringBytes,
                    genLine(x, y - rr, x, y + rr, eyeClass)
                );
        } else if (eyeType == 39) {
            return genCircle(x, y, 3, eyeClass);
        } else if (eyeType == 40) {
            uint256 rr = r / uint256(2);
            return
                abi.encodePacked(
                    genLine(x - r, y, x + r, y, eyeClass),
                    genLine(x - rr, y - rr, x - rr, y + rr, eyeClass),
                    genLine(x + rr, y - rr, x + rr, y + rr, eyeClass)
                );
        } else if (eyeType == 41 || eyeType == 42) {
            return genHalfCircle(x, y, r, false, eyeType == 42, eyeClass);
        } else {
            // eyeType == 43
            return genHalfCircle(x, y, r, true, true, eyeClass);
        }
    }

    // generate mouth
    function mouth(uint256 id) private view returns (bytes memory) {
        uint256 _shape = shape[id];
        uint256 mouthType = uint256(uint8(_shape >> 72)) % 14;
        uint256 x = 200;
        uint256 y = 250 +
            ((uint256(30) * uint256(uint8(_shape >> 80))) / uint256(255));
        uint256 w = 20 +
            ((uint256(60) * uint256(uint8(_shape >> 88))) / uint256(255));
        uint256 h = 20 +
            ((uint256(30) * uint256(uint8(_shape >> 96))) / uint256(255));
        uint256 minSide = (w > h ? h : w);
        uint256 radius = minSide / uint256(2);

        string memory class = "mouth";
        mouthType = uint256(12) + (mouthType % uint256(2)); ////////
        if (mouthType == 0) {
            return genCircle(x, y, radius, class);
        } else if (mouthType == 1) {
            uint256 cornerRadius = ((radius / uint256(2)) *
                uint256(uint8(_shape >> 104))) / uint256(255);
            return genRect(x, y, w, h, cornerRadius, cornerRadius, class);
        } else if (mouthType == 2) {
            return genDownTriangle(x, y, radius, class);
        } else if (mouthType == 3) {
            return genUpTriangle(x, y, radius, class);
        } else if (mouthType == 4) {
            uint256 r = w / uint256(2);
            return
                abi.encodePacked(
                    genLine(
                        x - r,
                        y - uint256(5),
                        x + r,
                        y - uint256(5),
                        class
                    ),
                    genLine(x - r, y + uint256(5), x + r, y + uint256(5), class)
                );
        } else if (mouthType == 5) {
            uint256 r = w / uint256(2);
            return genLine(x - r, y, x + r, y, class);
        } else if (mouthType == 6) {
            uint256 r = radius / uint256(2);
            uint256 yy = y - r / uint256(2);
            class = "mouth_opacity";
            return
                abi.encodePacked(
                    genHalfCircle(x - r, y, r, false, false, class),
                    genHalfCircle(x + r, y, r, false, false, class),
                    genLine(x - r, yy, x + r, yy, class)
                );
        } else if (mouthType == 7) {
            uint256 ww = w / uint256(2);
            uint256 hh = h / uint256(2);
            return
                abi.encodePacked(
                    genLine(x - ww, y, x, y + hh, class),
                    genLine(x, y + hh, x + ww, y, class)
                );
        } else if (mouthType == 8) {
            return genEllipse(x, y, w / uint256(2), h / uint256(2), class);
        } else if (mouthType == 9 || mouthType == 10) {
            return genHalfCircle(x, y, radius, false, mouthType == 10, class);
        } else if (mouthType == 11) {
            uint256 rr = radius / uint256(2);
            uint256 rrr = 3;
            return
                abi.encodePacked(
                    genHalfCircle(x, y, radius, false, false, class),
                    genLine(
                        x - radius - rrr,
                        y - rr + rrr,
                        x - radius + rrr,
                        y - rr - rrr,
                        class
                    ),
                    genLine(
                        x + radius - rrr,
                        y - rr - rrr,
                        x + radius + rrr,
                        y - rr + rrr,
                        class
                    )
                );
        } else if (mouthType == 12) {
            uint256 hh = 8;
            uint256 ww = w / uint256(2);
            return
                abi.encodePacked(
                    genLine(x - ww, y - hh, x + ww, y - hh, class),
                    genLine(x - ww, y, x + ww, y, class),
                    genLine(x - ww, y + hh, x + ww, y + hh, class)
                );
        } else {
            // mouthType == 13
            uint256 hh = 8;
            uint256 w1 = w / uint256(2);
            uint256 w2 = w * uint(618) / uint(2000);
            uint256 w3 = w * uint(190962) / uint(1000000);
            return
                abi.encodePacked(
                    genLine(x - w1, y - hh, x + w1, y - hh, class),
                    genLine(x - w2, y, x + w2, y, class),
                    genLine(x - w3, y + hh, x + w3, y + hh, class)
                );
        }
    }

    ////// generate common object //////

    /// generate circle with center (cx, cy) and radius and the svg class.
    function genCircle(
        uint256 cx,
        uint256 cy,
        uint256 radius,
        string memory class
    ) private pure returns (bytes memory) {
        return
            abi.encodePacked(
                '<circle class="',
                class,
                '" cx="',
                cx.toString(),
                '" cy="',
                cy.toString(),
                '" r="',
                radius.toString(),
                '" />'
            );
    }

    /// generate rect with center (cx, cy), width, height, cornerRadiusX, cornerRadiusY and the svg class.
    function genRect(
        uint256 cx,
        uint256 cy,
        uint256 width,
        uint256 height,
        uint256 cornerRadiusX,
        uint256 cornerRadiusY,
        string memory class
    ) private pure returns (bytes memory) {
        return
            abi.encodePacked(
                '<rect class="',
                class,
                '" x="',
                (cx - width / uint256(2)).toString(),
                '" y="',
                (cy - height / uint256(2)).toString(),
                '" width="',
                width.toString(),
                '" height="',
                height.toString(),
                '" rx="',
                cornerRadiusX.toString(),
                '" ry="',
                cornerRadiusY.toString(),
                '" />'
            );
    }

    /// generate rhombus with center (cx, cy), radius and the svg class
    function genRhombus(
        uint256 cx,
        uint256 cy,
        uint256 radius,
        string memory class
    ) private pure returns (bytes memory) {
        return
            abi.encodePacked(
                '<polygon class="',
                class,
                '" points="',
                (cx - radius).toString(),
                ",",
                cy.toString(),
                " ",
                cx.toString(),
                ",",
                (cy - radius).toString(),
                " ",
                (cx + radius).toString(),
                ",",
                cy.toString(),
                " ",
                cx.toString(),
                ",",
                (cy + radius).toString(),
                '"/>'
            );
    }

    /// generate up triangle △ with center (cx, cy), radius and the svg class
    function genUpTriangle(
        uint256 cx,
        uint256 cy,
        uint256 radius,
        string memory class
    ) private pure returns (bytes memory) {
        return
            abi.encodePacked(
                '<polygon class="',
                class,
                '" points="',
                (cx - radius).toString(),
                ",",
                (cy + radius).toString(),
                " ",
                (cx + radius).toString(),
                ",",
                (cy + radius).toString(),
                " ",
                cx.toString(),
                ",",
                (cy - radius).toString(),
                '"/>'
            );
    }

    /// generate down triangle with center (cx, cy), radius and the svg class
    function genDownTriangle(
        uint256 cx,
        uint256 cy,
        uint256 radius,
        string memory class
    ) private pure returns (bytes memory) {
        return
            abi.encodePacked(
                '<polygon class="',
                class,
                '" points="',
                (cx - radius).toString(),
                ",",
                (cy - radius).toString(),
                " ",
                (cx + radius).toString(),
                ",",
                (cy - radius).toString(),
                " ",
                cx.toString(),
                ",",
                (cy + radius).toString(),
                '"/>'
            );
    }

    /// generate strait line from (x1, y1) to (x2, y2)
    function genLine(
        uint256 x1,
        uint256 y1,
        uint256 x2,
        uint256 y2,
        string memory class
    ) private pure returns (bytes memory) {
        return
            abi.encodePacked(
                '<path class="',
                class,
                '" d="M',
                x1.toString(),
                ",",
                y1.toString(),
                " L",
                x2.toString(),
                ",",
                y2.toString(),
                '"/>'
            );
    }

    /// generate up arrow with center (cx, cy), radius and the svg class.
    function genUpArrow(
        uint256 cx,
        uint256 cy,
        uint256 radius,
        string memory class
    ) private pure returns (bytes memory) {
        return
            abi.encodePacked(
                '<path class="',
                class,
                '" d="M',
                (cx - radius).toString(),
                ",",
                (cy + radius).toString(),
                " L",
                cx.toString(),
                ",",
                (cy - radius).toString(),
                " L",
                (cx + radius).toString(),
                ",",
                (cy + radius).toString(),
                '"/>'
            );
    }

    /// generate down arrow with center (cx, cy), radius and the svg class.
    function genDownArrow(
        uint256 cx,
        uint256 cy,
        uint256 radius,
        string memory class
    ) private pure returns (bytes memory) {
        return
            abi.encodePacked(
                '<path class="',
                class,
                '" d="M',
                (cx - radius).toString(),
                ",",
                (cy - radius).toString(),
                " L",
                cx.toString(),
                ",",
                (cy + radius).toString(),
                " L",
                (cx + radius).toString(),
                ",",
                (cy - radius).toString(),
                '"/>'
            );
    }

    /// generate heart with center (cx, cy), radius, top is flat param and the svg class.
    function genHeart(
        uint256 cx,
        uint256 cy,
        uint256 radius,
        bool isFlat,
        string memory class
    ) private pure returns (bytes memory) {
        uint256 ty = cy -
            (isFlat ? radius : ((uint256(4) * radius) / uint256(5)));
        uint256 rr = (radius * uint256(3)) / uint256(2);
        return
            abi.encodePacked(
                '<path class="',
                class,
                '" d="M',
                cx.toString(),
                ",",
                (cy + radius).toString(),
                " Q",
                (cx - rr).toString(),
                ",",
                (cy - radius).toString(),
                " ",
                cx.toString(),
                ",",
                ty.toString(),
                " Q",
                (cx + rr).toString(),
                ",",
                (cy - radius).toString(),
                " ",
                cx.toString(),
                ",",
                (cy + radius).toString(),
                ' Z"/>'
            );
    }

    /// generate half circle with center (cx, cy), radius and the svg class.
    function genHalfCircle(
        uint256 cx,
        uint256 cy,
        uint256 radius,
        bool isTop,
        bool closed,
        string memory class
    ) private pure returns (bytes memory) {
        string memory radiusString = radius.toString();
        uint256 rr = radius / uint256(2);
        string memory yString = (isTop ? (cy + rr) : (cy - rr)).toString();
        return
            abi.encodePacked(
                '<path class="',
                class,
                '" d="M ',
                (cx - radius).toString(),
                ",",
                yString,
                " A ",
                radiusString,
                " ",
                radiusString,
                isTop ? " 0 0 1 " : " 0 0 0 ",
                (cx + radius).toString(),
                " ",
                yString,
                closed ? ' Z"/>' : '"/>'
            );
    }

    /// generate ellipse with center (cx, cy), radius x, radius y and the svg class.
    function genEllipse(
        uint256 cx,
        uint256 cy,
        uint256 radiusX,
        uint256 radiusY,
        string memory class
    ) private pure returns (bytes memory) {
        return
            abi.encodePacked(
                '<ellipse class="',
                class,
                '" cx="',
                cx.toString(),
                '" cy="',
                cy.toString(),
                '" rx="',
                radiusX.toString(),
                '" ry="',
                radiusY.toString(),
                '"/>'
            );
    }
}
