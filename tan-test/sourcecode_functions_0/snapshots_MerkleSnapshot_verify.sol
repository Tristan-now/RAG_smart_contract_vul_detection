function verify(
        bytes32 _id,
        bytes32[] calldata _proof,
        bytes32 _leaf
    ) external view returns (bool) {
        return MerkleProof.verify(_proof, snapshot[_id], _leaf);
    }