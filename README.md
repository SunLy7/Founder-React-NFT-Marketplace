# NFT市场项目

这是一个基于以太坊的NFT市场应用，允许用户铸造、上架和交易NFT。

## 项目结构

项目由两部分组成：

1. **智能合约 (hello_foundry)**：
   - 使用Foundry框架开发
   - 包含NFT合约和市场合约
   - 支持铸造、上架和购买NFT功能

2. **前端应用 (nft-marketplace)**：
   - 使用React开发
   - 集成了Web3和以太坊钱包
   - 提供用户友好的界面进行NFT交易

## 功能特点

- 铸造NFT（需支付0.05 ETH）
- 查看自己拥有的NFT
- 将NFT上架到市场
- 浏览并购买他人上架的NFT
- 支持测试模式，无需连接真实钱包

## 技术栈

- **智能合约**：
  - Solidity
  - Foundry (Forge, Anvil)
  - OpenZeppelin & Solmate库

- **前端**：
  - React
  - Material-UI
  - ethers.js
  - Web3Context

## 安装与运行

### 智能合约

```bash
cd hello_foundry
forge build
forge test
```

### 前端应用

```bash
cd nft-marketplace
npm install
npm start
```

## 测试

项目支持两种测试模式：

1. **真实区块链测试**：
   - 连接MetaMask钱包
   - 部署合约到测试网或本地区块链
   - 使用真实交易进行测试

2. **模拟数据测试**：
   - 点击"使用模拟数据"按钮
   - 无需连接钱包
   - 可以测试所有UI功能

## 许可证

MIT 