function burnToken(bytes calldata params, bytes32) external onlySelf {
        (string memory symbol, bytes32 salt) = abi.decode(params, (string, bytes32));

        _burnToken(symbol, salt);
    }