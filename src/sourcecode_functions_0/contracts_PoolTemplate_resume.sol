function resume() external {
        require(
            marketStatus == MarketStatus.Payingout &&
                pendingEnd < block.timestamp,
            "ERROR: UNABLE_TO_RESUME"
        );

        uint256 _debt = vault.debts(address(this));
        uint256 _totalCredit = totalCredit;
        uint256 _deductionFromIndex = (_debt * _totalCredit * MAGIC_SCALE_1E6) /
            totalLiquidity();
        uint256 _actualDeduction;
        for (uint256 i = 0; i < indexList.length; i++) {
            address _index = indexList[i];
            uint256 _credit = indicies[_index].credit;
            if (_credit > 0) {
                uint256 _shareOfIndex = (_credit * MAGIC_SCALE_1E6) /
                    _totalCredit;
                uint256 _redeemAmount = _divCeil(
                    _deductionFromIndex,
                    _shareOfIndex
                );
                _actualDeduction += IIndexTemplate(_index).compensate(
                    _redeemAmount
                );
            }
        }

        uint256 _deductionFromPool = _debt -
            _deductionFromIndex /
            MAGIC_SCALE_1E6;
        uint256 _shortage = _deductionFromIndex /
            MAGIC_SCALE_1E6 -
            _actualDeduction;

        if (_deductionFromPool > 0) {
            vault.offsetDebt(_deductionFromPool, address(this));
        }

        vault.transferDebt(_shortage);

        marketStatus = MarketStatus.Trading;
        emit MarketStatusChanged(MarketStatus.Trading);
    }