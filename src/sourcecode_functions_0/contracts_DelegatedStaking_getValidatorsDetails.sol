function getValidatorsDetails() public view returns (uint128[] memory commissionRates, uint128[] memory delegated) {
        commissionRates = new uint128[](validatorsN);
        delegated = new uint128[](validatorsN);
        for (uint128 i = 0; i < validatorsN; ++i){
            Validator storage v = validators[i];
            commissionRates[i] = v.commissionRate;
            delegated[i] = v.delegated - v.stakings[v._address].staked;
        }
        return (commissionRates, delegated);
    }