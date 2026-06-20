// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IERC20Arb {
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
}

interface IUniswapV2RouterLike {
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
}

interface IRiskManager {
    function minProfitBps() external view returns (uint256);

    function validateTrade(
        address token,
        address buyRouter,
        address sellRouter,
        uint256 amount
    ) external view returns (bool);
}

contract ArbExecutor {
    address public owner;
    address public treasury;
    IRiskManager public riskManager;

    bool private locked;

    event ArbitrageExecuted(
        address indexed baseToken,
        address indexed buyRouter,
        address indexed sellRouter,
        uint256 amountIn,
        uint256 profit
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "ArbExecutor: not owner");
        _;
    }

    modifier nonReentrant() {
        require(!locked, "ArbExecutor: reentrant call");
        locked = true;
        _;
        locked = false;
    }

    constructor(address _riskManager, address _treasury) {
        require(_riskManager != address(0), "ArbExecutor: zero risk manager");
        require(_treasury != address(0), "ArbExecutor: zero treasury");

        owner = msg.sender;
        riskManager = IRiskManager(_riskManager);
        treasury = _treasury;
    }

    function executeArbitrage(
        address baseToken,
        uint256 amountIn,
        address buyRouter,
        address sellRouter,
        address[] calldata buyPath,
        address[] calldata sellPath,
        uint256 buyMinOut,
        uint256 sellMinOut,
        uint256 deadline
    ) external onlyOwner nonReentrant returns (uint256 profit) {
        riskManager.validateTrade(baseToken, buyRouter, sellRouter, amountIn);

        require(buyPath.length >= 2, "ArbExecutor: invalid buy path");
        require(sellPath.length >= 2, "ArbExecutor: invalid sell path");
        require(buyPath[0] == baseToken, "ArbExecutor: buy path mismatch");
        require(sellPath[sellPath.length - 1] == baseToken, "ArbExecutor: sell path mismatch");
        require(deadline >= block.timestamp, "ArbExecutor: expired");

        uint256 balanceBefore = IERC20Arb(baseToken).balanceOf(address(this));
        require(balanceBefore >= amountIn, "ArbExecutor: insufficient balance");

        IERC20Arb(baseToken).approve(buyRouter, amountIn);

        uint256[] memory buyAmounts = IUniswapV2RouterLike(buyRouter).swapExactTokensForTokens(
            amountIn,
            buyMinOut,
            buyPath,
            address(this),
            deadline
        );

        address intermediateToken = buyPath[buyPath.length - 1];
        uint256 intermediateAmount = buyAmounts[buyAmounts.length - 1];

        IERC20Arb(intermediateToken).approve(sellRouter, intermediateAmount);

        IUniswapV2RouterLike(sellRouter).swapExactTokensForTokens(
            intermediateAmount,
            sellMinOut,
            sellPath,
            address(this),
            deadline
        );

        uint256 balanceAfter = IERC20Arb(baseToken).balanceOf(address(this));

        require(balanceAfter > balanceBefore, "ArbExecutor: no profit");

        profit = balanceAfter - balanceBefore;

        uint256 minProfit = (amountIn * riskManager.minProfitBps()) / 10_000;
        require(profit >= minProfit, "ArbExecutor: profit below minimum");

        IERC20Arb(baseToken).transfer(treasury, profit);

        emit ArbitrageExecuted(baseToken, buyRouter, sellRouter, amountIn, profit);
    }

    function rescueToken(address token, address to, uint256 amount) external onlyOwner {
        require(to != address(0), "ArbExecutor: zero address");
        IERC20Arb(token).transfer(to, amount);
    }

    function updateTreasury(address _treasury) external onlyOwner {
        require(_treasury != address(0), "ArbExecutor: zero treasury");
        treasury = _treasury;
    }
}
