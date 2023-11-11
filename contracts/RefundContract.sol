// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RefundContract {
    address public owner;
    mapping(address => uint256) public balances;

    event Deposit(address indexed sender, uint256 amount);
    event Withdrawal(address indexed recipient, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // Users can send funds to the contract
    function deposit() external payable {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    // Users can withdraw their funds
    function withdraw(uint256 amount) external {
    require(amount > 0, "Withdrawal amount must be greater than 0");
    require(amount <= balances[msg.sender], "Insufficient funds");

    balances[msg.sender] -= amount;
    payable(msg.sender).transfer(amount);
    emit Withdrawal(msg.sender, amount);
}
    
    // Owner can withdraw the contract balance
    function withdrawContractBalance() external onlyOwner {
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "Contract balance is empty");

        payable(owner).transfer(contractBalance);
        emit Withdrawal(owner, contractBalance);
    }
}
