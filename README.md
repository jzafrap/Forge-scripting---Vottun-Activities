## Forge fuzzy logic test and scripting samples -  Vottun activities 
This repo is a complete example of how to using fuzzy logic in forge tests applied to full coverage tests.
The repo contains:
- src/[PrivateBank.sol](https://github.com/jzafrap/Forge-scripting---Vottun-Activities/blob/main/src/PrivateBank.sol): example smart contract implementing a private bank, target for full coverage tests.
- src/[NetworkConfig.sol](https://github.com/jzafrap/Forge-scripting---Vottun-Activities/blob/main/src/NetworkConfig.sol): utility smart contract for easy deployment of the smart contract in different chains.
- test/[privateBank.t.sol](https://github.com/jzafrap/Forge-scripting---Vottun-Activities/blob/main/test/PrivateBank.t.sol): full coverage test of PrivateBank smart contract, implemented in solidity
- script/[deploy.s.sol](https://github.com/jzafrap/Forge-scripting---Vottun-Activities/blob/main/script/deploy.s.sol): script for deployment the smart contract in different chains from forge line command.

## PrivateBank.sol
```solidity
pragma solidity 0.8.20;

// SPDX-License-Identifier: MIT

contract PrivateBank {
    mapping(address => uint256) private balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint256 balance = getUserBalance(msg.sender);

        require(balance > 0, "Insufficient balance");

        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Failed to send Ether");

        balances[msg.sender] = 0;
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function getUserBalance(address _user) public view returns (uint256) {
        return balances[_user];
    }
}

```
## PrivateBank.t.sol
```solidity
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Vm} from "forge-std/Vm.sol";
import {PrivateBank} from "../src/PrivateBank.sol";

contract PrivateBankTest is Test {
    address DEPOSITOR_ADDRESS = address(0x1234567890abcdef1234567890abcdef);
    PrivateBank public privateBank;

    function setUp() public {
        privateBank = new PrivateBank();
        vm.deal(DEPOSITOR_ADDRESS, 1000 ether); 
        
    }

    function test_Deposit() public {
        uint256 amount = 1 ether;
        vm.startPrank(DEPOSITOR_ADDRESS);
        privateBank.deposit{value: amount}();
        assertEq(privateBank.getUserBalance(DEPOSITOR_ADDRESS), amount);
    }

    function testFuzz_Deposit(uint256 x) public {
        vm.startPrank(DEPOSITOR_ADDRESS);
        vm.deal(DEPOSITOR_ADDRESS, x); 
        privateBank.deposit{value:x}();
        assertEq(privateBank.getUserBalance(DEPOSITOR_ADDRESS), x);
       
    }

    

    function testWithdraw() public {
        address USER_ADDRESS = address(0x01234567890abcdef1234567890abcde);
        vm.deal(USER_ADDRESS, 1000 ether); 
        uint256 amount = 1 ether;
        vm.startPrank(USER_ADDRESS);
         uint256 userBalanceBeforeDeposit = USER_ADDRESS.balance;
        //deposit 1 ether
        privateBank.deposit{ value: amount}();
       
        uint256 checkpointGasLeft1 = gasleft();

        //withdraw 
        privateBank.withdraw();

        uint256 userBalanceAfterWithdraw = USER_ADDRESS.balance;
        
        //gas used in call is decreased gas left
        uint256 checkpointGasLeft2 = gasleft();    
        uint256 gasUsed = checkpointGasLeft1 - checkpointGasLeft2;
        uint costInWei = gasUsed * tx.gasprice;
        uint costInEther = costInWei / 10**18;
   
        assertEq(userBalanceBeforeDeposit,userBalanceAfterWithdraw+costInEther);
    }

    function testFuzz_Withdraw(uint256 x) public {
        address USER_ADDRESS = address(0x001234567890abcdef1234567890abcd);
        vm.startPrank(USER_ADDRESS);
        vm.assume(x < 10 ether);
        vm.assume(x > 0 ether);
        vm.deal(USER_ADDRESS, 10 ether); //we will be plenty of gas

        uint256 userBalanceBeforeDeposit = USER_ADDRESS.balance;
        privateBank.deposit{ value: x}();
        uint256 checkpointGasLeft1 = gasleft();

        //withdraw 
        privateBank.withdraw();

        uint256 userBalanceAfterWithdraw = USER_ADDRESS.balance;
        
        
        //dealing with gas usage
        uint256 checkpointGasLeft2 = gasleft();
        uint256 gasUsed = checkpointGasLeft1 - checkpointGasLeft2;
        uint costInWei = gasUsed * tx.gasprice;
        uint costInEther = costInWei / 10**18;

        assertEq(userBalanceBeforeDeposit,userBalanceAfterWithdraw+costInEther);
    }

}



```
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


