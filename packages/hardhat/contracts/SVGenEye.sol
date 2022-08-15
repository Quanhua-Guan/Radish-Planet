pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT

import "./RDHStrings.sol";
import "./SVGen.sol";

library SVGenEye {
    using RDHStrings for uint256;

    // create single eye
    function eye(
        uint256 eyeType,
        uint256 eyeSize,
        uint256 x,
        uint256 y,
        bool isLeft
    ) public pure returns (bytes memory) {
        bytes memory emptyStringBytes = abi.encodePacked("");
        string memory eyeClass = isLeft ? "eye_l" : "eye_r";
        uint256 r = eyeSize / uint256(2);
        if (eyeType == 0) {
            return
                abi.encodePacked(
                    SVGen.genCircle(x, y, r, eyeClass),
                    SVGen.genCircle(x, y, uint256(3), eyeClass)
                );
        } else if (eyeType == 1) {
            return SVGen.genHalfCircle(x, y, r, true, false, eyeClass);
        } else if (eyeType >= 2 && eyeType <= 4) {
            return
                abi.encodePacked(
                    SVGen.genCircle(x, y, eyeSize / 2, eyeClass),
                    eyeType >= 3
                        ? SVGen.genCircle(x, y, eyeSize / 4, eyeClass)
                        : emptyStringBytes,
                    eyeType == 4
                        ? SVGen.genCircle(x, y, eyeSize / 8, "eye_c")
                        : emptyStringBytes
                );
        } else if (eyeType >= 5 && eyeType <= 7) {
            uint256 cornerRadius = uint256(eyeSize % 2 == 0 ? 0 : 3);
            return
                abi.encodePacked(
                    SVGen.genRect(
                        x,
                        y,
                        eyeSize,
                        eyeSize,
                        cornerRadius,
                        cornerRadius,
                        eyeClass
                    ),
                    eyeType >= 6
                        ? SVGen.genRect(
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
                        ? SVGen.genRect(
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
                    SVGen.genDownTriangle(x, y, r, eyeClass),
                    eyeType == 9
                        ? SVGen.genLine(x, y + r, x, y - r, eyeClass)
                        : emptyStringBytes
                );
        } else if (eyeType == 10 || eyeType == 11) {
            return
                abi.encodePacked(
                    SVGen.genUpTriangle(x, y, r, eyeClass),
                    eyeType == 11
                        ? SVGen.genLine(x, y + r, x, y - r, eyeClass)
                        : emptyStringBytes
                );
        } else if (eyeType == 12) {
            uint256 rr = r - 5;
            return
                abi.encodePacked(
                    SVGen.genCircle(x, y, r, eyeClass),
                    SVGen.genRhombus(x, y, rr, eyeClass)
                );
        } else if (eyeType == 13 || eyeType == 14) {
            return
                abi.encodePacked(
                    eyeType == 14
                        ? SVGen.genCircle(x, y, r, eyeClass)
                        : emptyStringBytes,
                    SVGen.genLine(x, y + r, x, y - r, eyeClass),
                    SVGen.genLine(x - r, y, x + r, y, eyeClass)
                );
        } else if (eyeType >= 15 && eyeType <= 17) {
            return
                abi.encodePacked(
                    eyeType == 15 || eyeType == 16
                        ? SVGen.genUpArrow(x, y, r, "eye_opacity")
                        : emptyStringBytes,
                    eyeType == 17 || eyeType == 16
                        ? SVGen.genDownArrow(x, y, r, "eye_opacity")
                        : emptyStringBytes
                );
        } else if (eyeType == 18 || eyeType == 19) {
            uint256 rr = r / uint256(2);
            return
                abi.encodePacked(
                    eyeType == 19
                        ? SVGen.genCircle(x, y, r, eyeClass)
                        : emptyStringBytes,
                    SVGen.genLine(x - rr, y - rr, x + rr, y + rr, eyeClass),
                    SVGen.genLine(x - rr, y + rr, x + rr, y - rr, eyeClass)
                );
        } else if (eyeType == 20 || eyeType == 21) {
            uint256 rr = r / uint256(2);
            return
                abi.encodePacked(
                    SVGen.genRect(x, y, eyeSize, eyeSize, 0, 0, "eye_opacity"),
                    eyeType == 20
                        ? SVGen.genRect(
                            x - rr,
                            y - rr,
                            r,
                            r,
                            0,
                            0,
                            "eye_opacity"
                        )
                        : SVGen.genRect(
                            x - rr,
                            y + rr,
                            r,
                            r,
                            0,
                            0,
                            "eye_opacity"
                        ),
                    eyeType == 20
                        ? SVGen.genRect(
                            x + rr,
                            y + rr,
                            r,
                            r,
                            0,
                            0,
                            "eye_opacity"
                        )
                        : SVGen.genRect(
                            x + rr,
                            y - rr,
                            r,
                            r,
                            0,
                            0,
                            "eye_opacity"
                        )
                );
        } else if (eyeType == 22 || eyeType == 23) {
            uint256 rr = r - uint256(5);
            return
                abi.encodePacked(
                    eyeType == 23
                        ? SVGen.genCircle(x, y, r, eyeClass)
                        : emptyStringBytes,
                    SVGen.genLine(x - rr, y, x + rr, y, eyeClass)
                );
        } else if (eyeType == 24) {
            uint256 rr = r / uint256(4);
            return
                abi.encodePacked(
                    SVGen.genLine(x - r, y - rr, x + r, y - rr, eyeClass),
                    SVGen.genLine(x - r, y + rr, x + r, y + rr, eyeClass),
                    SVGen.genLine(x - rr, y - r, x - rr, y + r, eyeClass),
                    SVGen.genLine(x + rr, y - r, x + rr, y + r, eyeClass)
                );
        } else if (eyeType >= 25 && eyeType <= 27) {
            return
                abi.encodePacked(
                    SVGen.genRhombus(x, y, r, eyeClass),
                    eyeType == 25
                        ? SVGen.genLine(x - r, y, x + r, y, eyeClass)
                        : emptyStringBytes,
                    eyeType == 25
                        ? SVGen.genLine(x, y - r, x, y + r, eyeClass)
                        : emptyStringBytes,
                    eyeType == 26
                        ? SVGen.genCircle(x, y, 3, eyeClass)
                        : emptyStringBytes,
                    eyeType == 27
                        ? SVGen.genRhombus(x, y, r / uint256(2), eyeClass)
                        : emptyStringBytes
                );
        } else if (eyeType == 28 || eyeType == 29) {
            uint256 rr = r / uint256(2);
            return
                abi.encodePacked(
                    SVGen.genCircle(x, y, r, eyeClass),
                    eyeType == 28
                        ? SVGen.genRect(x, y, rr, rr, 0, 0, eyeClass)
                        : SVGen.genUpTriangle(x, y, rr, eyeClass)
                );
        } else if (eyeType == 30 || eyeType == 31) {
            return SVGen.genHeart(x, y, r, eyeType == 30, eyeClass);
        } else if (eyeType == 32 || eyeType == 33) {
            uint256 rr = r / uint256(2);
            return
                abi.encodePacked(
                    SVGen.genRect(x, y, eyeSize, eyeSize, 0, 0, eyeClass),
                    eyeType == 32
                        ? SVGen.genLine(x - rr, y, x + rr, y, eyeClass)
                        : SVGen.genLine(x, y - rr, x, y + rr, eyeClass)
                );
        } else if (eyeType == 34) {
            uint256 rr = (r * uint256(3)) / uint256(4);
            return
                abi.encodePacked(
                    SVGen.genUpTriangle(x, y, rr, "eye_opacity"),
                    SVGen.genDownTriangle(x, y, rr, "eye_opacity")
                );
        } else if (eyeType == 35 || eyeType == 36) {
            uint256 rr = r / uint256(2);
            return
                abi.encodePacked(
                    SVGen.genRhombus(x, y, r, eyeClass),
                    eyeType == 35
                        ? SVGen.genLine(x - rr, y, x + rr, y, eyeClass)
                        : SVGen.genLine(x, y - rr, x, y + rr, eyeClass)
                );
        } else if (eyeType == 37 || eyeType == 38) {
            uint256 rr = r / uint256(2);
            return
                abi.encodePacked(
                    eyeType == 37
                        ? SVGen.genCircle(x, y, r, eyeClass)
                        : emptyStringBytes,
                    SVGen.genLine(x, y - rr, x, y + rr, eyeClass)
                );
        } else if (eyeType == 39) {
            return SVGen.genCircle(x, y, 3, eyeClass);
        } else if (eyeType == 40) {
            uint256 rr = r / uint256(2);
            return
                abi.encodePacked(
                    SVGen.genLine(x - r, y, x + r, y, eyeClass),
                    SVGen.genLine(x - rr, y - rr, x - rr, y + rr, eyeClass),
                    SVGen.genLine(x + rr, y - rr, x + rr, y + rr, eyeClass)
                );
        } else if (eyeType == 41 || eyeType == 42) {
            return SVGen.genHalfCircle(x, y, r, false, eyeType == 42, eyeClass);
        } else {
            // eyeType == 43
            return SVGen.genHalfCircle(x, y, r, true, true, eyeClass);
        }
    }

    // create eyes
    function eyes(uint256 _shape) external pure returns (bytes memory) {
        bool hasSameEyes = (uint256(uint8(_shape >> 32)) % uint256(1000)) !=
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
}
