function calculate(
        address user,
        uint32[] calldata drawIds,
        bytes calldata data
    ) external view override returns (uint256[] memory, bytes memory) {
        Timelock memory _timelock = timelock;

        for (uint256 i = 0; i < drawIds.length; i++) {
            // if draw id matches timelock and not expired, revert
            if (drawIds[i] == _timelock.drawId) {
                _requireTimelockElapsed(_timelock);
            }
        }

        return calculator.calculate(user, drawIds, data);
    }