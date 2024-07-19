function hashOperationBatch(
        address[] memory targets,
        uint256[] memory values,
        bytes[] memory datas,
        bytes32 predecessor,
        bytes32 salt
    ) public pure virtual returns (bytes32 hash) {
        return keccak256(abi.encode(targets, values, datas, predecessor, salt));
    }