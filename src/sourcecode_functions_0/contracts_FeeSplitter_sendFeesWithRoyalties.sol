function sendFeesWithRoyalties(
        address _royaltiesTarget,
        IERC20 _token,
        uint256 _amount
    ) external nonReentrant {
        require(_royaltiesTarget != address(0), "FeeSplitter: INVALID_ROYALTIES_TARGET_ADDRESS");

        _sendFees(_token, _amount, totalWeights);
        _addShares(_royaltiesTarget, _computeShareCount(_amount, royaltiesWeight, totalWeights), address(_token));
    }