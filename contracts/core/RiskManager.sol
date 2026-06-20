// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract RiskManager {
    address public owner;
    bool public tradingEnabled = true;

    uint256 public maxTradeSize;
    uint256 public minProfitBps;
    uint256 public maxSlippageBps;

    mapping(address => bool) public approvedToken;
    mapping(address => bool) public approvedRouter;
    mapping(address => bool) public operator;

    event TradingStatusChanged(bool enabled);
    event TokenApproved(address token, bool status);
    event RouterApproved(address router, bool status);
    event OperatorUpdated(address operator, bool status);
    event LimitsUpdated(uint256 maxTradeSize, uint256 minProfitBps, uint256 maxSlippageBps);

    modifier onlyOwner() {
        require(msg.sender == owner, "RiskManager: not owner");
        _;
    }

    modifier onlyOperatorOrOwner() {
        require(msg.sender == owner || operator[msg.sender], "RiskManager: not operator");
        _;
    }

    constructor(
        uint256 _maxTradeSize,
        uint256 _minProfitBps,
        uint256 _maxSlippageBps
    ) {
        owner = msg.sender;
        maxTradeSize = _maxTradeSize;
        minProfitBps = _minProfitBps;
        maxSlippageBps = _maxSlippageBps;
    }

    function setTradingEnabled(bool enabled) external onlyOwner {
        tradingEnabled = enabled;
        emit TradingStatusChanged(enabled);
    }

    function setOperator(address account, bool status) external onlyOwner {
        operator[account] = status;
        emit OperatorUpdated(account, status);
    }

    function setApprovedToken(address token, bool status) external onlyOwner {
        approvedToken[token] = status;
        emit TokenApproved(token, status);
    }

    function setApprovedRouter(address router, bool status) external onlyOwner {
        approvedRouter[router] = status;
        emit RouterApproved(router, status);
    }

    function updateLimits(
        uint256 _maxTradeSize,
        uint256 _minProfitBps,
        uint256 _maxSlippageBps
    ) external onlyOwner {
        require(_maxSlippageBps <= 1000, "RiskManager: slippage too high");
        require(_minProfitBps <= 5000, "RiskManager: profit too high");

        maxTradeSize = _maxTradeSize;
        minProfitBps = _minProfitBps;
        maxSlippageBps = _maxSlippageBps;

        emit LimitsUpdated(_maxTradeSize, _minProfitBps, _maxSlippageBps);
    }

    function validateTrade(
        address token,
        address buyRouter,
        address sellRouter,
        uint256 amount
    ) external view returns (bool) {
        require(tradingEnabled, "RiskManager: trading disabled");
        require(approvedToken[token], "RiskManager: token not approved");
        require(approvedRouter[buyRouter], "RiskManager: buy router not approved");
        require(approvedRouter[sellRouter], "RiskManager: sell router not approved");
        require(amount > 0, "RiskManager: zero amount");
        require(amount <= maxTradeSize, "RiskManager: trade too large");

        return true;
    }
}
