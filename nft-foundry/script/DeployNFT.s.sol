// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/NFT.sol";
import "../src/Marketplace.sol";

contract DeployScript is Script {
    NFT public nft;
    Marketplace public marketplace;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        // 部署NFT合约
        nft = new NFT(
            "Sun-NFT",
            "SNFT",
            "https://example.com/nft/"
        );
        console.log("NFT合约已部署到地址:", address(nft));

        // 部署市场合约
        marketplace = new Marketplace(nft);
        console.log("市场合约已部署到地址:", address(marketplace));

        vm.stopBroadcast();
    }
} 