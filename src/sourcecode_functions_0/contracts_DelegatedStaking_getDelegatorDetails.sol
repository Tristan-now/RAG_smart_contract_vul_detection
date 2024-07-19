function getDelegatorDetails(address delegator) public view returns( uint128[] memory delegated,  uint128[] memory rewardsAvailable, uint128[] memory commissionRewards) {
       delegated = new uint128[](validatorsN);
       rewardsAvailable = new uint128[](validatorsN);
       commissionRewards = new uint128[](validatorsN);
       uint256 currentEpoch = block.number < endEpoch? block.number: endEpoch;
       uint128 newGlobalExchangeRate = uint128((uint256(allocatedTokensPerEpoch) * divider/totalGlobalShares)*(currentEpoch - lastUpdateEpoch)) + globalExchangeRate;
       Validator storage v;
       Staking storage s;
        for (uint128 i = 0; i < validatorsN; ++i){
            v = validators[i];
            s = v.stakings[delegator];
            delegated[i] = s.staked;
            if (v.disabledEpoch == 0){
                uint128 newTokensGiven = _sharesToTokens(v.globalShares, newGlobalExchangeRate - v.lastUpdateGlobalRate);
                uint128 commissionPaid = uint128(uint256(newTokensGiven) * uint256(v.commissionRate) /  divider);
                uint128 rateIncrease = uint128(uint256(newTokensGiven - commissionPaid) * divider / v.totalShares);
                rewardsAvailable[i] = _sharesToTokens(s.shares, v.exchangeRate + rateIncrease) - s.staked;
                if(delegator == v._address)
                    commissionRewards[i] = v.commissionAvailableToRedeem + commissionPaid;
            }
            else {
                rewardsAvailable[i] = _sharesToTokens(s.shares, v.exchangeRate) - s.staked;
                if(delegator == v._address)
                    commissionRewards[i] = v.commissionAvailableToRedeem;
            }
        }
        return (delegated, rewardsAvailable, commissionRewards);
    }