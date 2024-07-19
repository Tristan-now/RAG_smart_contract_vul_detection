function _computeNextTwab(
        ObservationLib.Observation memory _currentTwab,
        uint224 _currentBalance,
        uint32 _time
    ) private pure returns (ObservationLib.Observation memory) {
        // New twab amount = last twab amount (or zero) + (current amount * elapsed seconds)
        return
            ObservationLib.Observation({
                amount: _currentTwab.amount +
                    _currentBalance *
                    (_time.checkedSub(_currentTwab.timestamp, _time)),
                timestamp: _time
            });
    }