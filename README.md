## Forge fuzzy logic test and scripting samples -  Vottun activities 
This repo is a complete example of how to using fuzzy logic in forge tests applied to full coverage tests.
The repo contains:
- src/[PrivateBank.sol](https://github.com/jzafrap/Forge-scripting---Vottun-Activities/src/PrivateBank.sol): example smart contract implementing a private bank, target for full coverage tests.
- src/NetworkConfig.sol: utility smart contract for easy deployment of the smart contract in different chains.
- test/privateBank.t.sol: full coverage test of PrivateBank smart contract, implemented in solidity
- script/deploy.s.sol: script for deployment the smart contract in different chains from forge line command.

## Usage

### Build: compile the smart contracts

```shell
$ forge build
```

### Test: execute full coverage tests, including fuzzy logic tests.

```shell
$ forge test
```
```
[⠊] Compiling...
No files changed, compilation skipped

Ran 4 tests for test/PrivateBank.t.sol:PrivateBankTest
[PASS] testFuzz_Deposit(uint256) (runs: 256, μ: 41014, ~: 41430)
[PASS] testFuzz_Withdraw(uint256) (runs: 256, μ: 33576, ~: 33578)
[PASS] testWithdraw() (gas: 32980)
[PASS] test_Deposit() (gas: 40835)
Suite result: ok. 4 passed; 0 failed; 0 skipped; finished in 17.00ms (26.25ms CPU time)

Ran 1 test suite in 17.54ms (17.00ms CPU time): 4 tests passed, 0 failed, 0 skipped (4 total tests)
```

### Deploy: execute script for deployment of smart contract in any of preconfigured chains

```shell
$ forge script deploy --network  goerly --private-key <your_private_key>
```


