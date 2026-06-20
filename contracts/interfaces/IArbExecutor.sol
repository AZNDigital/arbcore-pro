// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IArbExecutor {
    struct ArbParams {
        address baseToken;
        uint256 amountIn;
        address buyRouter;
        address sellRouter;
        address[] buyPath;
        address[] sellPath;
        uint256 buyMinOut;
        uint256 sellMinOut;
        uint256 deadline;
    }

    function executeArbitrage(
        ArbParams calldata params
    ) external returns (uint256 profit);
}
