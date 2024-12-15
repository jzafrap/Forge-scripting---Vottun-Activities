// scripts/deploy.s.sol
pragma solidity ^0.8.17;

import "../src/NetworkConfig.sol";
import "../src/PrivateBank.sol";
import {Vm} from "forge-std/Vm.sol";
import {Script, console} from "forge-std/Script.sol";


contract DeployScript is Script{
    NetworkConfig public networkConfig;
    
    

    constructor(NetworkConfig _networkConfig) {
        networkConfig = _networkConfig;

    }

    function deploy(string memory networkName) public {
         NetworkConfig.Network memory network = networkConfig.getNetworkConfig(networkName);

        
        // Set up the network
        //vm.setEnv("chain_id", string(abi.encodePacked(chainId)));
        vm.setEnv("chain_id", string(abi.encodePacked(network.chainId)));
        // Deploy the contract
        PrivateBank privateBank = new PrivateBank();
    }
}