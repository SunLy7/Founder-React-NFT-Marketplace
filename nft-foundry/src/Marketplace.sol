// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "./NFT.sol";
import "openzeppelin-contracts/access/Ownable.sol";

contract Marketplace is Ownable {
    // 定义挂牌信息结构体
    struct Listing {
        uint256 tokenId;
        address seller;
        uint256 price;
        bool isActive;
    }

    // 定义一个映射，用于存储每个 TokenId 的挂牌信息
    mapping (uint256 => Listing) public listings;
    // 新增：用于追踪所有活跃挂牌的tokenId
    uint256[] private activeListingTokenIds; 
    // NFT 合约实例
    NFT public nftContract;

    constructor(NFT _nftContract) Ownable(msg.sender) {
        nftContract = _nftContract;
    }

    // 列出 NFT 待售
    function listNFT(uint256 tokenId, uint256 price) external {
        require(nftContract.ownerOf(tokenId) == msg.sender, "Not the owner!");
        require(price > 0, "Price must be greater than 0");
        
        // 确保该NFT当前未被挂牌
        require(!listings[tokenId].isActive, "NFT is already listed.");

        nftContract.transferFrom(msg.sender, address(this), tokenId);
        listings[tokenId] = Listing(tokenId, msg.sender, price, true);

        // 添加到活跃挂牌列表
        activeListingTokenIds.push(tokenId);
    }

    // 购买 NFT
    function buyNFT(uint256 tokenId) external payable {
        Listing storage listing = listings[tokenId];
        require(listing.isActive, "Listing does not exist or is inactive");
        require(msg.value >= listing.price, "Value sent is not enough");
        
        listing.isActive = false;
        
        // 从活跃列表中移除
        removeActiveListing(tokenId);
        
        nftContract.transferFrom(address(this), msg.sender, tokenId);
        payable(listing.seller).transfer(msg.value);
    }

    // 取消 NFT 挂牌
    function cancelListing(uint256 tokenId) external {
        Listing storage listing = listings[tokenId];
        require(listing.seller == msg.sender, "Not the seller!");
        require(listing.isActive, "Listing does not exist or is inactive");
        
        listing.isActive = false;

        // 从活跃列表中移除
        removeActiveListing(tokenId);

        nftContract.transferFrom(address(this), msg.sender, tokenId);
    }

    // 内部函数：从 activeListingTokenIds 数组中移除一个 tokenId
    function removeActiveListing(uint256 tokenId) private {
        // 找到 tokenId 在数组中的索引
        for (uint256 i = 0; i < activeListingTokenIds.length; i++) {
            if (activeListingTokenIds[i] == tokenId) {
                // 将最后一个元素移到当前位置
                activeListingTokenIds[i] = activeListingTokenIds[activeListingTokenIds.length - 1];
                // 缩短数组
                activeListingTokenIds.pop();
                return;
    }
        }
        // 如果代码执行到这里，说明发生了意外情况
        revert("Could not find token in active listings");
    }

    // 获取所有在售 NFT (高效版)
    function getActiveListings() external view returns (Listing[] memory) {
        // 创建一个 Listing 数组，长度为活跃挂牌的数量
        uint256 totalActive = activeListingTokenIds.length;
        Listing[] memory activeListings = new Listing[](totalActive);

        // 遍历活跃的 tokenId 列表来构建结果
        for (uint256 i = 0; i < totalActive; i++) {
            activeListings[i] = listings[activeListingTokenIds[i]];
            }
        
        return activeListings;
    }
}