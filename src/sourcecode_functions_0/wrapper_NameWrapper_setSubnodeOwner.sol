function setSubnodeOwner(
        bytes32 parentNode,
        string calldata label,
        address newOwner,
        uint32 fuses,
        uint64 expiry
    )
        public
        onlyTokenOwner(parentNode)
        canCallSetSubnodeOwner(parentNode, keccak256(bytes(label)))
        returns (bytes32 node)
    {
        bytes32 labelhash = keccak256(bytes(label));
        node = _makeNode(parentNode, labelhash);
        (, , expiry) = _getDataAndNormaliseExpiry(parentNode, node, expiry);

        if (ens.owner(node) != address(this)) {
            ens.setSubnodeOwner(parentNode, labelhash, address(this));
            _addLabelAndWrap(parentNode, node, label, newOwner, fuses, expiry);
        } else {
            _transferAndBurnFuses(node, newOwner, fuses, expiry);
        }
    }