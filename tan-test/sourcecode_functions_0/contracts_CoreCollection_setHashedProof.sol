function setHashedProof(string calldata _proof) external onlyOwner {
        require(
            bytes(HASHED_PROOF).length == 0,
            "CoreCollection: Hashed Proof is set"
        );

        HASHED_PROOF = _proof;
        emit NewHashedProof(_proof);
    }