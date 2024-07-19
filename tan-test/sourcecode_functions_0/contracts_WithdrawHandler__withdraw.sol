function _withdraw(WithdrawParameter memory parameters) private {
        ctrl.eoaOnly(msg.sender);
        require(buoy.safetyCheck(), "!safetyCheck");

        uint256 deductUsd;
        uint256 returnUsd;
        uint256 lpAmountFee;
        uint256[N_COINS] memory tokenAmounts;
        // If it's a "withdraw all" action
        uint256 virtualPrice = buoy.getVirtualPrice();
        if (parameters.all) {
            deductUsd = ctrl.getUserAssets(parameters.pwrd, parameters.account);
            returnUsd = deductUsd.sub(deductUsd.mul(withdrawalFee(parameters.pwrd)).div(PERCENTAGE_DECIMAL_FACTOR));
            lpAmountFee = returnUsd.mul(DEFAULT_DECIMALS_FACTOR).div(virtualPrice);
            // If it's a normal withdrawal
        } else {
            uint256 userAssets = ctrl.getUserAssets(parameters.pwrd, parameters.account);
            uint256 lpAmount = parameters.lpAmount;
            uint256 fee = lpAmount.mul(withdrawalFee(parameters.pwrd)).div(PERCENTAGE_DECIMAL_FACTOR);
            lpAmountFee = lpAmount.sub(fee);
            returnUsd = lpAmountFee.mul(virtualPrice).div(DEFAULT_DECIMALS_FACTOR);
            deductUsd = lpAmount.mul(virtualPrice).div(DEFAULT_DECIMALS_FACTOR);
            require(deductUsd <= userAssets, "!withdraw: not enough balance");
        }
        uint256 hodlerBonus = deductUsd.sub(returnUsd);

        bool whale = ctrl.isValidBigFish(parameters.pwrd, false, returnUsd);

        // If it's a balanced withdrawal
        if (parameters.balanced) {
            (returnUsd, tokenAmounts) = _withdrawBalanced(
                parameters.account,
                parameters.pwrd,
                lpAmountFee,
                parameters.minAmounts,
                returnUsd
            );
            // If it's a single asset withdrawal
        } else {
            (returnUsd, tokenAmounts[parameters.index]) = _withdrawSingle(
                parameters.account,
                parameters.pwrd,
                lpAmountFee,
                parameters.minAmounts[parameters.index],
                parameters.index,
                returnUsd,
                whale
            );
        }

        ctrl.burnGToken(parameters.pwrd, parameters.all, parameters.account, deductUsd, hodlerBonus);

        emit LogNewWithdrawal(
            parameters.account,
            ctrl.referrals(parameters.account),
            parameters.pwrd,
            parameters.balanced,
            parameters.all,
            deductUsd,
            returnUsd,
            lpAmountFee,
            tokenAmounts
        );
    }