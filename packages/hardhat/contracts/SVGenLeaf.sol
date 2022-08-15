pragma solidity ^0.8.0;

// SPDX-License-Identifier: MIT

import "./RDHStrings.sol";
import "./SVGen.sol";

library SVGenLeaf {
    using RDHStrings for uint256;

    /// create leaf
    function leaf(
        uint256 leafType,
        uint256 x,
        uint256 y,
        uint256 size,
        string memory class
    ) public pure returns (bytes memory) {
        uint256 r = size / uint256(2);
        if (leafType == 0) {
            return
                abi.encodePacked(
                    SVGen.genQuadArc(x, y, 200, 110, 200, 200, "branch"),
                    SVGen.genCircle(x, y, r, class)
                );
        } else if (leafType == 1) {
            return
                abi.encodePacked(
                    SVGen.genQuadArc(x, y, 200, 110, 200, 200, "branch"),
                    SVGen.genRhombus(x, y, r, class)
                );
        } else if (leafType == 2) {
            return
                abi.encodePacked(
                    SVGen.genQuadArc(x, y, 200, 110, 200, 200, "branch"),
                    SVGen.genRect(x, y, size, size, 0, 0, class)
                );
        } else if (leafType == 3) {
            return
                abi.encodePacked(
                    SVGen.genQuadArc(x, y, 200, 110, 200, 200, "branch"),
                    SVGen.genUpTriangle(x, y, r, class)
                );
        } else {
            // leafType == 4
            return
                abi.encodePacked(
                    SVGen.genQuadArc(x, y, 200, 110, 200, 200, "branch"),
                    SVGen.genDownTriangle(x, y, r, class)
                );
        }
    }

    /// create leafs
    function leafs(uint256 _shape) public pure returns (bytes memory) {
        uint256 leafCount = uint256(1) +
            (uint256(uint8(_shape >> 104)) % uint256(5));
        uint256 leafSize = uint256(20) +
            ((uint256(20) * uint256(uint8(_shape >> 112))) / uint256(255));

        uint256 leafType1 = uint256(uint8(_shape >> 120)) % uint256(5);
        string memory class = "leaf";
        if (leafCount == 1) {
            return leaf(leafType1, 200, 50, leafSize, class);
        } else {
            uint256 leafType2 = uint256(uint8(_shape >> 128)) % uint256(5);
            if (leafCount == 2) {
                return
                    abi.encodePacked(
                        leaf(leafType1, 150, 50, leafSize, class),
                        leaf(leafType2, 250, 50, leafSize, class)
                    );
            } else {
                uint256 leafType3 = uint256(uint8(_shape >> 136)) % uint256(5);
                if (leafCount == 3) {
                    return
                        abi.encodePacked(
                            leaf(leafType1, 100, 50, leafSize, class),
                            leaf(leafType2, 200, 50, leafSize, class),
                            leaf(leafType3, 300, 50, leafSize, class)
                        );
                } else {
                    uint256 leafType4 = uint256(uint8(_shape >> 144)) %
                        uint256(5);
                    if (leafCount == 4) {
                        return
                            abi.encodePacked(
                                leaf(leafType1, 50, 50, leafSize, class),
                                leaf(leafType2, 150, 50, leafSize, class),
                                leaf(leafType3, 250, 50, leafSize, class),
                                leaf(leafType4, 350, 50, leafSize, class)
                            );
                    } else {
                        uint256 leafType5 = uint256(uint8(_shape >> 152)) %
                            uint256(5);
                        return
                            abi.encodePacked(
                                leaf(leafType1, 50, 50, leafSize, class),
                                leaf(leafType2, 150, 50, leafSize, class),
                                leaf(leafType3, 250, 50, leafSize, class),
                                leaf(leafType4, 350, 50, leafSize, class),
                                leaf(leafType5, 350, 50, leafSize, class)
                            );
                    }
                }
            }
        }
    }
}
