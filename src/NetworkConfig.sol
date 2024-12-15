// src/NetworkConfig.sol
pragma solidity ^0.8.17;

contract NetworkConfig {
     struct Network {
        string rpcUrl;
        address deployer;
        uint256 chainId;
    }

    mapping(string => Network) public networks;

    constructor() {
        // Add network configurations here:
        networks["mainnet"] = Network({
            rpcUrl: "https://mainnet.infura.io/v3/333",
            deployer: msg.sender,
            chainId: 1
        });

        networks["goerli"] = Network({
            rpcUrl: "https://goerli.infura.io/v3/333",
            deployer: msg.sender,
            chainId: 5
        });
    }

    function getNetworkConfig(string memory networkName) public view returns (Network memory) {
        return networks[networkName];
    }
}