// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import  "forge-std/src/Test.sol";
import  "../src/NFT.sol";


contract NFTTest is Test {
    NFT private nft;

    function setUp() public {
        nft = new NFT("NFT_tutorial", "TUT", "baseUri");
    }

    // 测试用例：基本铸造功能
    function test_BasicMint() public {
        nft.mintTo{value: 0.05 ether}(address(1));
        assertEq(nft.ownerOf(1), address(1));
    }

    // 测试用例：铸造 NFT 时，不能将地址设置为零地址
    function test_RevertMintToZeroAddress() public {
        vm.expectRevert("INVALID_RECIPIENT");
        nft.mintTo{value: 0.05 ether}(address(0));
    }
    
    // 测试用例：铸造 NFT 时，必须支付足够的ETH
    function test_RevertMintPriceNotPaid() public {
        // 不支付ETH
        vm.expectRevert(MintPriceNotPaid.selector);
        nft.mintTo(address(1));
        
        // 支付不足的ETH
        vm.expectRevert(MintPriceNotPaid.selector);
        nft.mintTo{value: 0.04 ether}(address(1));
        
        // 支付过多的ETH
        vm.expectRevert(MintPriceNotPaid.selector);
        nft.mintTo{value: 0.06 ether}(address(1));
    }
    
    // 测试用例：超过最大供应量时铸造失败 - 修改为使用mock方法
    function test_RevertMintMaxSupply() public {
        // 创建一个mock的合约，覆盖currentTokenId以模拟达到最大供应
        MockNFT mockNft = new MockNFT("NFT_tutorial", "TUT", "baseUri");
        
        // 模拟已达到最大供应
        mockNft.setCurrentTokenId(mockNft.MAX_CAPACITY());
        
        // 下一次铸造应该失败
        vm.expectRevert(MaxSupply.selector);
        mockNft.mintTo{value: 0.05 ether}(address(1));
    }
}

// 创建一个Mock版本的NFT合约，允许我们设置currentTokenId
contract MockNFT is NFT {
    constructor(string memory _name, string memory _symbol, string memory _baseURI) 
        NFT(_name, _symbol, _baseURI) {}
    
    // 添加一个函数来直接设置currentTokenId
    function setCurrentTokenId(uint256 _tokenId) public {
        currentTokenId = _tokenId;
    }
}