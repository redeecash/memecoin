// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

interface IPriceOracle {
    function getLatestPrice(string calldata tokenName) external view returns (int256);
    function updatePrice(string calldata tokenName, uint256 price) external;
}

contract MemeCoin {
  string public name = "MemCoin";
    string public symbol = "MEME";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    address public owner;
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;

    // Compliance mappings
    mapping(address => bool) public approvedInvestors;
    mapping(address => uint256) public lockupPeriods;

    // Price-related state
    IPriceOracle public priceOracle;
    uint256 public referencePrice; // Stored in the same units as the oracle

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event InvestorApproved(address indexed investor);
    event LockupSet(address indexed investor, uint256 unlockTime);
    event ReferencePriceUpdated(uint256 newPrice);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    modifier onlyApproved(address investor) {
        require(approvedInvestors[investor], "Investor not approved");
        _;
    }

    constructor(uint256 initialSupply, address priceOracleAddress, uint256 initialPrice) {
        owner = msg.sender;
        totalSupply = initialSupply * (10 ** uint256(decimals));
        balances[owner] = totalSupply;
        priceOracle = IPriceOracle(priceOracleAddress);
        priceOracle.updatePrice(symbol, initialPrice);
        referencePrice = uint256(priceOracle.getLatestPrice(symbol));
        emit Transfer(address(0), owner, totalSupply);
    }

    function approveInvestor(address investor) external onlyOwner {
        approvedInvestors[investor] = true;
        emit InvestorApproved(investor);
    }

    function setLockup(address investor, uint256 unlockTime) external onlyOwner {
        lockupPeriods[investor] = unlockTime;
        emit LockupSet(investor, unlockTime);
    }

    function updateReferencePrice() external onlyOwner {
        referencePrice = uint256(priceOracle.getLatestPrice(symbol));
        emit ReferencePriceUpdated(referencePrice);
    }

    function checkPrice() public view returns (bool) {
        uint256 currentPrice = uint256(priceOracle.getLatestPrice(symbol));
        return currentPrice >= (referencePrice * 20) / 100; // Ensure price is at least 20% of reference
    }

    function transfer(address to, uint256 value) external onlyApproved(msg.sender) returns (bool) {
        require(block.timestamp >= lockupPeriods[msg.sender], "Tokens are locked");
        require(checkPrice(), "Price too low to allow transfer");
        require(balances[msg.sender] >= value, "Insufficient balance");
        balances[msg.sender] -= value;
        balances[to] += value;
        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) external returns (bool) {
        allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) external onlyApproved(from) returns (bool) {
        require(block.timestamp >= lockupPeriods[from], "Tokens are locked");
        require(checkPrice(), "Price too low to allow transfer");
        require(balances[from] >= value, "Insufficient balance");
        require(allowances[from][msg.sender] >= value, "Allowance exceeded");
        balances[from] -= value;
        balances[to] += value;
        allowances[from][msg.sender] -= value;
        emit Transfer(from, to, value);
        return true;
    }

    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }

    function allowance(address owner_, address spender) external view returns (uint256) {
        return allowances[owner_][spender];
    }
}
