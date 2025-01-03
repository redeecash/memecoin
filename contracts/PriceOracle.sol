// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract PriceOracle {
  address public admin;

  // Mapping to store token prices (in a specified unit, e.g., USD with 8 decimals)
  mapping(string => uint256) private tokenPrices;

  // Events for logging price updates
  event PriceUpdated(string indexed tokenName, uint256 price, address indexed updatedBy);
  event AdminChanged(address indexed previousAdmin, address indexed newAdmin);

  modifier onlyAdmin() {
      require(msg.sender == admin, "Not authorized");
      _;
  }

  constructor() {
      admin = msg.sender; // Set the deployer as the initial admin
  }

  /// @notice Updates the price of a token by its name.
  /// @param tokenName The name of the token.
  /// @param price The price to set, in smallest units (e.g., USD with 8 decimals).
  function updatePrice(string calldata tokenName, uint256 price) external onlyAdmin {
      require(bytes(tokenName).length > 0, "Token name is required");
      require(price > 0, "Price must be greater than zero");

      tokenPrices[tokenName] = price;
      emit PriceUpdated(tokenName, price, msg.sender);
  }

  /// @notice Retrieves the current price of a token by its name.
  /// @param tokenName The name of the token.
  /// @return The price of the token in smallest units (e.g., USD with 8 decimals).
  function getPrice(string calldata tokenName) external view returns (uint256) {
      require(bytes(tokenName).length > 0, "Token name is required");

      uint256 price = tokenPrices[tokenName];
      require(price > 0, "Price not available");

      return price;
  }

  /// @notice Transfers the admin role to a new address.
  /// @param newAdmin The address of the new admin.
  function transferAdminRole(address newAdmin) external onlyAdmin {
      require(newAdmin != address(0), "New admin address cannot be zero");

      address previousAdmin = admin;
      admin = newAdmin;

      emit AdminChanged(previousAdmin, newAdmin);
  }
}
