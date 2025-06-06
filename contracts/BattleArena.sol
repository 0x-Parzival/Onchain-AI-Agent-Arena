// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./AgentNFT.sol"; // Assuming AgentNFT.sol is in the same directory

contract BattleArena is Ownable {
    AgentNFT public agentNFT; // Address of the AgentNFT contract

    enum BattleOutcome { NONE, WIN, LOSE, DRAW }

    struct BattleRecord {
        uint256 agent1Id;
        uint256 agent2Id;
        address challenger;
        address opponent;
        BattleOutcome outcomeAgent1;
        uint256 timestamp;
    }

    uint256 public battleCounter;
    mapping(uint256 => BattleRecord) public battleHistory;

    event BattleInitiated(uint256 indexed battleId, uint256 indexed agent1Id, uint256 indexed agent2Id, address challenger);
    event BattleConcluded(uint256 indexed battleId, BattleOutcome outcomeAgent1, BattleOutcome outcomeAgent2);

    // Modifier to ensure the caller owns the agent
    modifier onlyAgentOwner(uint256 _agentId) {
        require(agentNFT.ownerOf(_agentId) == msg.sender, "Caller does not own the agent");
        _;
    }

    constructor(address _agentNFTAddress) Ownable(initialOwner()) {
        agentNFT = AgentNFT(_agentNFTAddress);
    }

    // Function to initiate a battle (basic version)
    // More complex logic (e.g., Rock-Paper-Scissors, skill comparison) will be added later.
    function initiateBattle(uint256 _agent1Id, uint256 _agent2Id, address _opponent)
        public
        onlyAgentOwner(_agent1Id)
        returns (uint256 battleId)
    {
        require(_agent1Id != _agent2Id, "Cannot battle an agent against itself");
        require(agentNFT.ownerOf(_agent2Id) == _opponent, "Opponent does not own the second agent");

        battleCounter++;
        battleId = battleCounter;

        battleHistory[battleId] = BattleRecord({
            agent1Id: _agent1Id,
            agent2Id: _agent2Id,
            challenger: msg.sender,
            opponent: _opponent,
            outcomeAgent1: BattleOutcome.NONE, // Outcome to be determined by a separate function
            timestamp: block.timestamp
        });

        emit BattleInitiated(battleId, _agent1Id, _agent2Id, msg.sender);
        return battleId;
    }

    // Function to simulate and record a battle outcome (placeholder)
    // This will be expanded with actual battle logic (e.g., comparing AgentSkills from AgentNFT)
    function recordBattleOutcome(uint256 _battleId, BattleOutcome _outcomeAgent1) public onlyOwner {
        BattleRecord storage battle = battleHistory[_battleId];
        require(battle.challenger != address(0), "Battle not found"); // Basic check
        require(battle.outcomeAgent1 == BattleOutcome.NONE, "Battle outcome already recorded");

        battle.outcomeAgent1 = _outcomeAgent1;

        BattleOutcome outcomeAgent2;
        if (_outcomeAgent1 == BattleOutcome.WIN) {
            outcomeAgent2 = BattleOutcome.LOSE;
        } else if (_outcomeAgent1 == BattleOutcome.LOSE) {
            outcomeAgent2 = BattleOutcome.WIN;
        } else if (_outcomeAgent1 == BattleOutcome.DRAW) {
            outcomeAgent2 = BattleOutcome.DRAW;
        } else {
            revert("Invalid outcome for agent 1");
        }

        emit BattleConcluded(_battleId, _outcomeAgent1, outcomeAgent2);
        // Potential: Update agent scores/stats in AgentNFT contract here or via a separate mechanism
    }

    // OwnableUpgradeable requires initialOwner to be implemented
    function initialOwner() internal view returns (address) {
        return msg.sender;
    }
}
