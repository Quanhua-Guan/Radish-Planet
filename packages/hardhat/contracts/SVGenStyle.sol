pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT

import "./Colors.sol";

library SVGenStyle {
    using Colors for bytes3;

    function style(uint256 shape_) public pure returns (bytes memory) {
        bytes32 _shape = bytes32(shape_);
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
                ".branch{fill:#e8d0d4;stroke:white;stroke-width:4;fill-opacity:0.5}",
                // leaf
                ".leaf{fill:#efbbb6; stroke:white; stroke-width:5}",
                // bottom
                ".bottom{stroke:white;stroke-width:3}",
                "]]></style>"
            );
    }
}
