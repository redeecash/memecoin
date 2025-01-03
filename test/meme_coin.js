const MemeCoin = artifacts.require("MemeCoin");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("MemeCoin", function (accounts) {
  it("should assert true", async function () {
    await MemeCoin.deployed();
    return assert.isTrue(true);
  });
});
