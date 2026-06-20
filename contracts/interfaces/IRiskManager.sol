// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IRiskManager {
    function minProfitBps() external view returns (uint256);

    function validateTrade(
        address baseToken,
        address buyRouter,
        address sellRouter,
        uint256 amountIn
    ) external view returns (bool);
}
