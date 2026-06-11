// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title Snapshot
 * @notice Minimal oracle snapshot storage for CRE workflows
 * @dev Designed to accept writes only from a trusted workflow/forwarder
 */
contract Snapshot {

    struct Record {
        string token;
        uint256 price;
        uint256 blockNumber;
        uint256 timestamp;
    }

    /// @notice Latest oracle snapshot stored on-chain
    Record public lastRecord;

    /// @notice Address authorized to write snapshots (CRE forwarder / workflow)
    address public trustedForwarder;

    /**
     * @notice Restricts access to CRE workflow/forwarder only
     */
    modifier onlyForwarder() {
        require(msg.sender == trustedForwarder, "Not authorised");
        _;
    }

    /**
     * @notice Sets the trusted forwarder at deployment
     * @dev In CRE this would be the workflow execution identity
     */
    constructor(address _trustedForwarder) {
        trustedForwarder = _trustedForwarder;
    }

    /**
     * @notice Stores oracle-derived snapshot data
     * @param token Asset symbol (e.g. ETH)
     * @param price Chainlink price feed value (USD)
     * @param blockNumber Block number of oracle update
     */
    function snapshot(
        string memory token,
        uint256 price,
        uint256 blockNumber
    ) external onlyForwarder {

        lastRecord = Record({
            token: token,
            price: price,
            blockNumber: blockNumber,
            timestamp: block.timestamp
        });
    }
}
