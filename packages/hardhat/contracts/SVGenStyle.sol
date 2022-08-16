pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT

import "./RDHStrings.sol";

library SVGenStyle {
    using RDHStrings for uint256;

    function hslColor(
        uint256 hue,
        uint256 saturation,
        uint256 lightness
    ) internal pure returns (bytes memory) {
        return
            abi.encodePacked(
                "hsl(",
                hue.toString(),
                ",",
                saturation.toString(),
                "%,",
                lightness.toString(),
                "%)"
            );
    }

    function style(uint256 _shape, uint256 _age)
        external
        pure
        returns (bytes memory)
    {
        uint256 hue = (uint256(359) * uint256(uint16(_shape))) / 65535;
        uint256 saturation = (uint256(100) * uint256(uint16(_shape >> 8))) /
            65535;
        uint256 lightness = uint256(40) +
            (uint256(15) * uint256(uint16(_shape >> 16))) /
            65535;

        bytes memory color = hslColor(hue, saturation, lightness);

        hue = (hue + 30) % 360;
        lightness += 10;
        bytes memory mouth = hslColor(hue, saturation, lightness);
        lightness += 10;
        bytes memory eye = hslColor(hue, saturation, lightness);
        lightness += 10;
        bytes memory leaf = hslColor(hue, saturation, lightness);
        lightness += 10;
        bytes memory branch = hslColor(hue, saturation, lightness);

        unchecked {
            hue = (hue + (_age / (1 days)) * uint256(30)) % uint256(360);
        }
        bytes memory leafVar = hslColor(hue, saturation, lightness);

        return
            abi.encodePacked(
                '<style type="text/css"><![CDATA[',
                // background
                ".background{fill:",
                color,
                ";stroke:white;stroke-width:1;fill-opacity:0.2}",
                // body
                ".body{fill:",
                color,
                ";stroke:white;stroke-width:5}",
                // eye
                ".eye_l{fill:",
                eye,
                ";stroke:white;stroke-width:3}",
                ".eye_r{fill:",
                eye,
                ";stroke:white;stroke-width:3}",
                ".eye_c{fill:",
                eye,
                ";stroke:white;stroke-width:1}",
                ".eye_opacity{fill:",
                eye,
                ";stroke:white;stroke-width:3;fill-opacity:0.3}",
                // mouth
                ".mouth{fill:",
                mouth,
                ";stroke:white;stroke-width:3}",
                ".mouth_opacity{fill:",
                mouth,
                ";stroke:white;stroke-width:3;fill-opacity:0.3}",
                // branch
                ".branch{fill:",
                branch,
                ";stroke:white;stroke-width:4;fill-opacity:0.5}",
                // leaf
                ".leaf{fill:",
                leaf,
                "; stroke:white; stroke-width:5}",
                // leaf_var
                ".leaf_var{fill:",
                leafVar,
                "; stroke:white; stroke-width:5}",
                "]]></style>"
            );
    }
}
