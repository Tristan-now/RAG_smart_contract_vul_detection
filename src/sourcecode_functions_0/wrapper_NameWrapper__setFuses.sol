function _setFuses(
        bytes32 node,
        address owner,
        uint32 fuses,
        uint64 expiry
    ) internal {
        _setData(node, owner, fuses, expiry);
        emit FusesSet(node, fuses, expiry);
    }