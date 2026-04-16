// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Importações diretas do GitHub que o Remix reconhece automaticamente
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Interface manual da Chainlink (evita erros de importação de arquivo)
interface AggregatorV3Interface {
    function latestRoundData() external view returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    );
}

interface IEcoToken is IERC20 {
    function mintRewards(address to, uint256 amount) external;
}

contract StakingVault is ReentrancyGuard, Ownable {
    IEcoToken public rewardsToken;
    AggregatorV3Interface internal priceFeed;

    mapping(address => uint256) public stakedBalance;
    uint256 public rewardRate = 100;
    mapping(uint256 => uint256) public proposals;

    // Construtor atualizado para o dono atual
    constructor(address _tokenAddress, address _priceFeed) Ownable(msg.sender) {
        rewardsToken = IEcoToken(_tokenAddress);
        priceFeed = AggregatorV3Interface(_priceFeed);
    }

    function getLatestPrice() public view returns (int) {
        // Tenta buscar o preço, se falhar (em rede local), retorna 0
        try priceFeed.latestRoundData() returns (uint80, int256 answer, uint256, uint256, uint80) {
            return answer;
        } catch {
            return 0;
        }
    }

    function stake(uint256 amount) external nonReentrant {
        require(amount > 0, "Valor insuficiente");
        // Transfere os tokens do usuário para este contrato
        rewardsToken.transferFrom(msg.sender, address(this), amount);
        stakedBalance[msg.sender] += amount;
    }

    function vote(uint256 proposalId) external {
        require(stakedBalance[msg.sender] > 0, "Sem poder de voto");
        proposals[proposalId] += stakedBalance[msg.sender];
    }
}