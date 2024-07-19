function blackListDigest(bytes32 _hash) external onlyOwner {
        usedDigests[_hash] = address(0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF);
    }