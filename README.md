# MEMECOIN
Creating a memecoin in Solidity that complies with Regulation SHO under an existing exemption involves understanding both the technical and legal requirements. Regulation SHO primarily governs short selling and applies to securities. A "memecoin," typically a token created for fun or community engagement, would not inherently qualify as a security unless structured in a way that involves investment contracts or securities-like features.

### Key Considerations
1. **Regulatory Compliance**: 
   - **Exemption Strategy**: Identify an existing exemption (e.g., Regulation D, Regulation A+, or intrastate offering exemption under Section 3(a)(11)).
   - **Legal Framework**: Work with legal counsel to draft terms ensuring compliance with Regulation SHO if the token could be considered a security.
   
2. **Token Features**:
   - Implement mechanisms for compliance, such as tracking ownership, implementing lock-up periods, and ensuring only eligible investors participate.

3. **Technology Implementation**:
   - Use Solidity to enforce the regulatory requirements programmatically within the token's smart contract.

Here's an example of a basic Solidity smart contract for a memecoin incorporating compliance features:

### Solidity Implementation

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title MemCoin with Compliance Features
/// @dev Implements basic tokenomics with compliance for exempt offerings.
contract MemCoin {
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

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event InvestorApproved(address indexed investor);
    event LockupSet(address indexed investor, uint256 unlockTime);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    modifier onlyApproved(address investor) {
        require(approvedInvestors[investor], "Investor not approved");
        _;
    }

    constructor(uint256 initialSupply) {
        owner = msg.sender;
        totalSupply = initialSupply * (10 ** uint256(decimals));
        balances[owner] = totalSupply;
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

    function transfer(address to, uint256 value) external onlyApproved(msg.sender) returns (bool) {
        require(block.timestamp >= lockupPeriods[msg.sender], "Tokens are locked");
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
```

### Explanation:
1. **Approval Mechanism**: Investors need to be approved by the contract owner before engaging in transfers.
2. **Lock-Up Periods**: Enforces time-based restrictions to comply with certain securities exemptions.
3. **Ownership Transfer**: Only approved investors can transfer tokens.
4. **Regulatory Features**: The owner can implement additional compliance mechanisms as needed.

### Next Steps
- **Legal Counsel**: Confirm that the token structure satisfies the chosen exemption.
- **Audit**: Perform a smart contract audit to ensure security and compliance.
- **Deployment**: Deploy on Ethereum or another EVM-compatible blockchain.

Would you like further customization or integration into an existing ecosystem?

# Merket Integrity
The factors that ensure market integrity accrdoing to [FINRA](https://www.finra.org/rules-guidance/guidance/reports/2023-finras-examination-and-risk-monitoring-program/market-integrity)

1. Consolidated Audit Trail (CAT)
2. Best Execution
3. Disclosure of Routing Information
4. Fixed Income - Fair Pricing
5. Fractional Shares: Rwpoering and Order Handling
6. Eegulation SHO
