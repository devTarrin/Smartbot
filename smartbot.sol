// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;



interface IBlast {
    function configureClaimableYield() external;
    function configureClaimableGas() external;
    function claimYield(address contractAddress, address recipientOfYield, uint256 amount) external returns (uint256);
    function claimAllYield(address contractAddress, address recipientOfYield) external returns (uint256);
    function claimAllGas(address contractAddress, address recipient) external returns (uint256);
    function claimMaxGas(address contractAddress, address recipient) external returns (uint256);

}


contract SmartBot {
    address public owner;
    mapping(address => uint256) public balances;
    bool private locked;
    bool public emergencyStop;

    // strategyParams
    struct StrategyParams {
        string token_selection;
        uint256 stop_loss;
        uint256 take_profit;
        uint256 position_size;
        uint256 max_drawdown_limit;
    }

    address public constant blastContract = 0x4300000000000000000000000000000000000002;

    event Deposit(address indexed sender, uint256 amount);
    event Withdrawal(address indexed receiver, uint256 amount);
    event StrategyExecuted(address indexed executor, uint256 indexed strategyId, StrategyParams params);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    modifier noReentrancy() {
        require(!locked, "No reentrancy");
        locked = true;
        _;
        locked = false;
    }

    modifier stopInEmergency() {
        require(!emergencyStop, "Emergency stop activated");
        _;
    }

    constructor() {
        owner = msg.sender;
        locked = false;
        emergencyStop = false;
        IBlast(blastContract).configureClaimableYield();
        IBlast(blastContract).configureClaimableGas();


    }

    function deposit() external payable stopInEmergency {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdrawETH(uint256 _amount) public noReentrancy stopInEmergency {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "Failed to send ETH");
        emit Withdrawal(msg.sender, _amount);
    }

    function withdrawAll() public onlyOwner noReentrancy {
        uint256 amount = address(this).balance;
        (bool sent, ) = owner.call{value: amount}("");
        require(sent, "Failed to send ETH");
    }

    function strategy_1(string memory token_selection, uint256 stop_loss, uint256 take_profit, uint256 position_size, uint256 max_drawdown_limit) external onlyOwner {
        StrategyParams memory params = StrategyParams(token_selection, stop_loss, take_profit, position_size, max_drawdown_limit);
        emit StrategyExecuted(msg.sender, 1, params);
        // This place is for strategy code
    }

    function strategy_2(string memory token_selection, uint256 stop_loss, uint256 take_profit, uint256 position_size, uint256 max_drawdown_limit) external onlyOwner {
        StrategyParams memory params = StrategyParams(token_selection, stop_loss, take_profit, position_size, max_drawdown_limit);
        emit StrategyExecuted(msg.sender, 1, params);
        // This place is for strategy code
    }

    function strategy_3(string memory token_selection, uint256 stop_loss, uint256 take_profit, uint256 position_size, uint256 max_drawdown_limit) external onlyOwner {
        StrategyParams memory params = StrategyParams(token_selection, stop_loss, take_profit, position_size, max_drawdown_limit);
        emit StrategyExecuted(msg.sender, 1, params);
        // This place is for strategy code
    }

    function strategy_4(string memory token_selection, uint256 stop_loss, uint256 take_profit, uint256 position_size, uint256 max_drawdown_limit) external onlyOwner {
        StrategyParams memory params = StrategyParams(token_selection, stop_loss, take_profit, position_size, max_drawdown_limit);
        emit StrategyExecuted(msg.sender, 1, params);
        // This place is for strategy code
    }

    function strategy_5(string memory token_selection, uint256 stop_loss, uint256 take_profit, uint256 position_size, uint256 max_drawdown_limit) external onlyOwner {
        StrategyParams memory params = StrategyParams(token_selection, stop_loss, take_profit, position_size, max_drawdown_limit);
        emit StrategyExecuted(msg.sender, 1, params);
        // This place is for strategy code
    }

    function strategy_6(string memory token_selection, uint256 stop_loss, uint256 take_profit, uint256 position_size, uint256 max_drawdown_limit) external onlyOwner {
        StrategyParams memory params = StrategyParams(token_selection, stop_loss, take_profit, position_size, max_drawdown_limit);
        emit StrategyExecuted(msg.sender, 1, params);
        // This place is for strategy code
    }

    function toggleEmergencyStop() public onlyOwner {
        emergencyStop = !emergencyStop;
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function claimAllGas() external onlyOwner {
        IBlast(blastContract).claimAllGas(address(this), msg.sender);
    }

    function claimMaxGas() external onlyOwner {
        IBlast(blastContract).claimMaxGas(address(this), msg.sender);
    }


    function claimAllYield(address recipient) external onlyOwner {
		IBlast(blastContract).claimAllYield(address(this), recipient);
  }

    function claimYield(address recipient,uint256 amount) external onlyOwner {
        IBlast(blastContract).claimYield(address(this), recipient, amount);
    }

}