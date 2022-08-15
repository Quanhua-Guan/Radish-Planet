pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT

import "./RDHStrings.sol";

library SVGenBody {
    
    using RDHStrings for uint256;

    // create body part
    function body(uint256 _shape) external pure returns (bytes memory) {
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
}
