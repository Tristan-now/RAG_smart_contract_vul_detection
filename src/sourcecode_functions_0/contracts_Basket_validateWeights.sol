function validateWeights(address[] memory _tokens, uint256[] memory _weights) public override pure {
        require(_tokens.length > 0);
        require(_tokens.length == _weights.length);
        uint256 length = _tokens.length;
        address[] memory tokenList = new address[](length);

        // check uniqueness of tokens and not token(0)

        for (uint i = 0; i < length; i++) {
            require(_tokens[i] != address(0));
            require(_weights[i] > 0);

            for (uint256 x = 0; x < tokenList.length; x++) {
                require(_tokens[i] != tokenList[x]);
            }

            tokenList[i] = _tokens[i];
        }
    }