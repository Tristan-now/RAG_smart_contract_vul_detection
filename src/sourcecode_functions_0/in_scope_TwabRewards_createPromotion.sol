function createPromotion(
        address _ticket,
        IERC20 _token,
        uint216 _tokensPerEpoch,
        uint32 _startTimestamp,
        uint32 _epochDuration,
        uint8 _numberOfEpochs
    ) external override returns (uint256) {
        _requireTicket(_ticket);

        uint256 _nextPromotionId = _latestPromotionId + 1;
        _latestPromotionId = _nextPromotionId;

        _promotions[_nextPromotionId] = Promotion(
            msg.sender,
            _ticket,
            _token,
            _tokensPerEpoch,
            _startTimestamp,
            _epochDuration,
            _numberOfEpochs
        );

        _token.safeTransferFrom(msg.sender, address(this), _tokensPerEpoch * _numberOfEpochs);

        emit PromotionCreated(_nextPromotionId);

        return _nextPromotionId;
    }