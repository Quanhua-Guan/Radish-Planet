pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT

import "./RDHStrings.sol";
import "./SVGen.sol";

library SVGenMouth {
    using RDHStrings for uint256;

    // create mouth
    function mouth(uint256 _shape) public pure returns (bytes memory) {
        uint256 mouthType = uint256(uint8(_shape >> 72)) % uint256(14);
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
        if (mouthType == 0) {
            return SVGen.genCircle(x, y, radius, class);
        } else if (mouthType == 1) {
            uint256 cornerRadius = uint256(5) +
                ((radius / uint256(2)) * uint256(uint8(_shape >> 104))) /
                uint256(255);
            return SVGen.genRect(x, y, w, h, cornerRadius, cornerRadius, class);
        } else if (mouthType == 2) {
            return SVGen.genDownTriangle(x, y, radius, class);
        } else if (mouthType == 3) {
            return SVGen.genUpTriangle(x, y, radius, class);
        } else if (mouthType == 4) {
            uint256 r = w / uint256(2);
            return
                abi.encodePacked(
                    SVGen.genLine(
                        x - r,
                        y - uint256(5),
                        x + r,
                        y - uint256(5),
                        class
                    ),
                    SVGen.genLine(
                        x - r,
                        y + uint256(5),
                        x + r,
                        y + uint256(5),
                        class
                    )
                );
        } else if (mouthType == 5) {
            uint256 r = w / uint256(2);
            return SVGen.genLine(x - r, y, x + r, y, class);
        } else if (mouthType == 6) {
            uint256 r = radius / uint256(2);
            uint256 yy = y - r / uint256(2);
            class = "mouth_opacity";
            return
                abi.encodePacked(
                    SVGen.genHalfCircle(x - r, y, r, false, false, class),
                    SVGen.genHalfCircle(x + r, y, r, false, false, class),
                    SVGen.genLine(x - r, yy, x + r, yy, class)
                );
        } else if (mouthType == 7) {
            uint256 ww = w / uint256(2);
            uint256 hh = h / uint256(2);
            return
                abi.encodePacked(
                    SVGen.genLine(x - ww, y, x, y + hh, class),
                    SVGen.genLine(x, y + hh, x + ww, y, class)
                );
        } else if (mouthType == 8) {
            return
                SVGen.genEllipse(x, y, w / uint256(2), h / uint256(2), class);
        } else if (mouthType == 9 || mouthType == 10) {
            return
                SVGen.genHalfCircle(
                    x,
                    y,
                    radius,
                    false,
                    mouthType == 10,
                    class
                );
        } else if (mouthType == 11) {
            uint256 rr = radius / uint256(2);
            uint256 rrr = 3;
            return
                abi.encodePacked(
                    SVGen.genHalfCircle(x, y, radius, false, false, class),
                    SVGen.genLine(
                        x - radius - rrr,
                        y - rr + rrr,
                        x - radius + rrr,
                        y - rr - rrr,
                        class
                    ),
                    SVGen.genLine(
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
                    SVGen.genLine(x - ww, y - hh, x + ww, y - hh, class),
                    SVGen.genLine(x - ww, y, x + ww, y, class),
                    SVGen.genLine(x - ww, y + hh, x + ww, y + hh, class)
                );
        } else {
            // mouthType == 13
            uint256 hh = 8;
            uint256 w1 = w / uint256(2);
            uint256 w2 = (w * uint256(618)) / uint256(2000);
            uint256 w3 = (w * uint256(190962)) / uint256(1000000);
            return
                abi.encodePacked(
                    SVGen.genLine(x - w1, y - hh, x + w1, y - hh, class),
                    SVGen.genLine(x - w2, y, x + w2, y, class),
                    SVGen.genLine(x - w3, y + hh, x + w3, y + hh, class)
                );
        }
    }
}
