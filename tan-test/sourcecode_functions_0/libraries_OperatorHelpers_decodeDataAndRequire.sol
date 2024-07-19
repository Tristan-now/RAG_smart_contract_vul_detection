function decodeDataAndRequire(
        bytes memory _data,
        address _inputToken,
        address _outputToken
    ) internal returns (uint256[] memory amounts, address[] memory tokens) {
        (amounts, tokens) = abi.decode(_data, (uint256[], address[]));
        require(tokens[0] == _outputToken, "OperatorHelpers::getDecodeDataAndRequire: Wrong output token");
        require(tokens[1] == _inputToken, "OperatorHelpers::getDecodeDataAndRequire: Wrong input token");
    }