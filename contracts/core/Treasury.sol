// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IERC20Treasury {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
}

contract Treasury {
    address public owner;

    mapping(address => bool) public controller;

    event ControllerUpdated(address controller, bool status);
    event NativeReceived(address from, uint256 amount);
    event NativeWithdrawn(address to, uint256 amount);
    event TokenWithdrawn(address token, address to, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Treasury: not owner");
        _;
    }

    modifier onlyControllerOrOwner() {
        require(msg.sender == owner || controller[msg.sender], "Treasury: not controller");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        emit NativeReceived(msg.sender, msg.value);
    }

    function setController(address account, bool status) external onlyOwner {
        controller[account] = status;
        emit ControllerUpdated(account, status);
    }

    function withdrawNative(address payable to, uint256 amount) external onlyOwner {
        require(to != address(0), "Treasury: zero address");
        require(address(this).balance >= amount, "Treasury: insufficient balance");

        to.transfer(amount);
        emit NativeWithdrawn(to, amount);
    }

    function withdrawToken(address token, address to, uint256 amount) external onlyControllerOrOwner {
        require(token != address(0), "Treasury: zero token");
        require(to != address(0), "Treasury: zero address");

        bool success = IERC20Treasury(token).transfer(to, amount);
        require(success, "Treasury: token transfer failed");

        emit TokenWithdrawn(token, to, amount);
    }

    function tokenBalance(address token) external view returns (uint256) {
        return IERC20Treasury(token).balanceOf(address(this));
    }
}
