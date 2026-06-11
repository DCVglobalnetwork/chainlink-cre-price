// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title ISnapshot
 * @notice Defines the standard data structure for oracle-derived asset snapshots
 * @dev Used to represent off-chain → on-chain verified data in CRE workflows
 */
interface ISnapshot {

    /**
     * @notice Oracle snapshot record representing a single asset state update
     * @param token Asset identifier (e.g. ETH, BTC)
     * @param price Latest USD price from Chainlink Data Feed
     * @param blockNumber Block number when oracle data was last updated
     * @param timestamp Timestamp when snapshot was written on-chain
     */
    struct Record {
        string token;
        uint256 price;
        uint256 blockNumber;
        uint256 timestamp;
    }
}

/**
 * @title Snapshot
 * @notice Minimal oracle ingestion contract for CRE demonstration
 * @dev Stores Chainlink Data Feed-derived values on-chain via authorized write access
 */
contract Snapshot {

    /// @notice Stores the most recent oracle snapshot
    ISnapshot.Record public lastRecord;

    /// @notice Contract owner (authorized writer for snapshot updates)
    address public owner;

    /**
     * @notice Restricts function execution to contract owner only
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    /**
     * @notice Sets deployer as contract owner
     * @dev Used to control write access for snapshot updates
     */
    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice Writes an oracle-derived price snapshot to storage
     * @dev Intended to be called by CRE workflow after:
     *      1. Reading Chainlink Data Feed (EVM Read)
     *      2. Extracting latest price + update block number
     *      3. Executing EVM Write step
     *
     * @param token Asset symbol (e.g. ETH)
     * @param price Latest Chainlink price feed value (USD)
     * @param blockNumber Block number from last Chainlink update
     */
    function snapshot(
        string memory token,
        uint256 price,
        uint256 blockNumber
    ) external onlyOwner {

        lastRecord = ISnapshot.Record({
            token: token,
            price: price,
            blockNumber: blockNumber,
            timestamp: block.timestamp
        });
    }
}
