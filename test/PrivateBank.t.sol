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





