// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IERC20Flash {
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
}

interface IAavePool {
    function flashLoanSimple(
        address receiverAddress,
        address asset,
        uint256 amount,
        bytes calldata params,
        uint16 referralCode
    ) external;
}

interface IArbExecutor {
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
    ) external returns (uint256 profit);
}

contract FlashLoanExecutor {
    address public owner;
    address public aavePool;
    address public arbExecutor;

    bool private locked;

    event FlashLoanRequested(address indexed asset, uint256 amount);
    event FlashLoanExecuted(address indexed asset, uint256 amount, uint256 premium, uint256 profit);

    modifier onlyOwner() {
        require(msg.sender == owner, "FlashLoanExecutor: not owner");
        _;
    }

    modifier onlyAavePool() {
        require(msg.sender == aavePool, "FlashLoanExecutor: not pool");
        _;
    }

    modifier nonReentrant() {
        require(!locked, "FlashLoanExecutor: reentrant call");
        locked = true;
        _;
        locked = false;
    }

    constructor(address _aavePool, address _arbExecutor) {
        require(_aavePool != address(0), "FlashLoanExecutor: zero pool");
        require(_arbExecutor != address(0), "FlashLoanExecutor: zero arb executor");

        owner = msg.sender;
        aavePool = _aavePool;
        arbExecutor = _arbExecutor;
    }

    struct FlashParams {
        address buyRouter;
        address sellRouter;
        address[] buyPath;
        address[] sellPath;
        uint256 buyMinOut;
        uint256 sellMinOut;
        uint256 deadline;
    }

    function requestFlashLoan(
        address asset,
        uint256 amount,
        FlashParams calldata params
    ) external onlyOwner nonReentrant {
        require(asset != address(0), "FlashLoanExecutor: zero asset");
        require(amount > 0, "FlashLoanExecutor: zero amount");

        bytes memory encodedParams = abi.encode(params);

        IAavePool(aavePool).flashLoanSimple(
            address(this),
            asset,
            amount,
            encodedParams,
            0
        );

        emit FlashLoanRequested(asset, amount);
    }

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external onlyAavePool returns (bool) {
        require(initiator == address(this), "FlashLoanExecutor: invalid initiator");

        FlashParams memory decoded = abi.decode(params, (FlashParams));

        IERC20Flash(asset).transfer(arbExecutor, amount);

        uint256 profit = IArbExecutor(arbExecutor).executeArbitrage(
            asset,
            amount,
            decoded.buyRouter,
            decoded.sellRouter,
            decoded.buyPath,
            decoded.sellPath,
            decoded.buyMinOut,
            decoded.sellMinOut,
            decoded.deadline
        );

        uint256 totalDebt = amount + premium;
        uint256 currentBalance = IERC20Flash(asset).balanceOf(address(this));

        require(currentBalance >= totalDebt, "FlashLoanExecutor: insufficient repayment");

        IERC20Flash(asset).approve(aavePool, totalDebt);

        emit FlashLoanExecuted(asset, amount, premium, profit);

        return true;
    }

    function updateArbExecutor(address _arbExecutor) external onlyOwner {
        require(_arbExecutor != address(0), "FlashLoanExecutor: zero arb executor");
        arbExecutor = _arbExecutor;
    }

    function rescueToken(address token, address to, uint256 amount) external onlyOwner {
        require(to != address(0), "FlashLoanExecutor: zero address");
        IERC20Flash(token).transfer(to, amount);
    }
}
