function createStream(
        address rewardToken,
        address depositToken,
        uint32 startTime,
        uint32 streamDuration,
        uint32 depositLockDuration,
        uint32 rewardLockDuration,
        bool isSale
    )
        public
        returns (Stream)
    {
        // perform checks

        {
            require(startTime >= block.timestamp, "past");
            require(streamDuration >= streamParams.minStreamDuration && streamDuration <= streamParams.maxStreamDuration, "stream");
            require(depositLockDuration <= streamParams.maxDepositLockDuration, "lock");
            require(rewardLockDuration <= streamParams.maxRewardLockDuration, "reward");
        }
        

        // TODO: figure out sane salt, i.e. streamid + x? streamid guaranteed to be unique
        uint64 that_stream = currStreamId;
        currStreamId += 1;
        bytes32 salt = bytes32(uint256(that_stream));

        Stream stream = new Stream{salt: salt}(
            that_stream,
            msg.sender,
            isSale,
            rewardToken,
            depositToken,
            startTime,
            streamDuration,
            depositLockDuration,
            rewardLockDuration,
            feeParams.feePercent,
            feeParams.feeEnabled
        );

        emit StreamCreated(that_stream, address(stream));

        return stream;
    }