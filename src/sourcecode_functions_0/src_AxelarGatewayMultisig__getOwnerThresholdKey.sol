function _getOwnerThresholdKey(uint256 epoch) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(PREFIX_OWNER_THRESHOLD, epoch));
    }