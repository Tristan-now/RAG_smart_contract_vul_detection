function rampA2(
        Swap storage self,
        uint256 futureA2_,
        uint256 futureTime_
    ) external {
        require(
            block.timestamp >= self.initialA2Time.add(1 days),
            "Wait 1 day before starting ramp"
        );
        require(
            futureTime_ >= block.timestamp.add(MIN_RAMP_TIME),
            "Insufficient ramp time"
        );
        require(
            futureA2_ >= 0 && futureA2_ <= MAX_A,
            "futureA2_ must be >= 0 and <= MAX_A"
        );

        uint256 initialA2Precise = _getA2Precise(self);
        uint256 futureA2Precise = futureA2_.mul(A_PRECISION);

        if (futureA2Precise < initialA2Precise) {
            require(
                futureA2Precise.mul(MAX_A_CHANGE) >= initialA2Precise,
                "futureA2_ is too small"
            );
        } else {
            require(
                futureA2Precise <= initialA2Precise.mul(MAX_A_CHANGE),
                "futureA2_ is too large"
            );
        }

        self.initialA2 = initialA2Precise;
        self.futureA2 = futureA2Precise;
        self.initialA2Time = block.timestamp;
        self.futureA2Time = futureTime_;

        emit RampA2(
            initialA2Precise,
            futureA2Precise,
            block.timestamp,
            futureTime_
        );
    }