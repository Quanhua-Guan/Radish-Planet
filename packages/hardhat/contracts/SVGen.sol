pragma solidity ^0.8.0;
// SPDX-License-Identifier: MIT

import "./RDHStrings.sol";

library SVGen {
    using RDHStrings for uint256;

    ////// generate common object //////

    /// generate circle with center (cx, cy) and radius and the svg class.
    function genCircle(
        uint256 cx,
        uint256 cy,
        uint256 radius,
        string memory class
    ) public pure returns (bytes memory) {
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
    ) external pure returns (bytes memory) {
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
    ) external pure returns (bytes memory) {
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
    ) external pure returns (bytes memory) {
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
    ) external pure returns (bytes memory) {
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
    ) external pure returns (bytes memory) {
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
    ) external pure returns (bytes memory) {
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
    ) external pure returns (bytes memory) {
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
    ) external pure returns (bytes memory) {
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
    ) external pure returns (bytes memory) {
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
    ) external pure returns (bytes memory) {
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

    /// generate quad arc with (startX, startY), (controlX, controlY), (endX, endY) and the svg class.
    function genQuadArc(
        uint256 startX,
        uint256 startY,
        uint256 controlX,
        uint256 controlY,
        uint256 endX,
        uint256 endY,
        string memory class
    ) external pure returns (bytes memory) {
        return
            abi.encodePacked(
                '<path class="',
                class,
                '" d="M',
                startX.toString(),
                ",",
                startY.toString(),
                " Q",
                controlX.toString(),
                ",",
                controlY.toString(),
                " ",
                endX.toString(),
                ",",
                endY.toString(),
                '" />'
            );
    }
}
