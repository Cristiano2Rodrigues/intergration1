const { ethers } = require("ethers");

// Este script simula a interação exigida na Etapa 5 [cite: 51]
async function main() {
    const provider = new ethers.JsonRpcProvider("SUA_RPC_URL_SEPOLIA");
    const wallet = new ethers.Wallet("SUA_CHAVE_PRIVADA", provider);

    // Endereços após o deploy na Sepolia [cite: 61, 64]
    const tokenAddr = "0x..."; 
    const stakingAddr = "0x...";

    const stakingAbi = ["function stake(uint256 amount) public", "function vote(uint256 id) public"];
    const stakingContract = new ethers.Contract(stakingAddr, stakingAbi, wallet);

    console.log("Iniciando demonstração: Stake e Votação [cite: 58, 59]");
    
    // 1. Stake
    const tx = await stakingContract.stake(ethers.parseUnits("10", 18));
    await tx.wait();
    console.log("Stake de 10 ECO realizado!");

    // 2. Voto
    const voteTx = await stakingContract.vote(1);
    await voteTx.wait();
    console.log("Votação na DAO concluída!");
}
