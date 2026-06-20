// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library RouteLib {
    error InvalidPath();
    error PathMismatch();

    function validateBuyPath(
        address baseToken,
        address[] calldata path
    ) internal pure {
        if (path.length < 2) revert InvalidPath();
        if (path[0] != baseToken) revert PathMismatch();
    }

    function validateSellPath(
        address baseToken,
        address[] calldata path
    ) internal pure {
        if (path.length < 2) revert InvalidPath();
        if (path[path.length - 1] != baseToken) revert PathMismatch();
    }
}
