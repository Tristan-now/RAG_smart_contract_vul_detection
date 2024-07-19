function syncDeps(address _registry, uint _liquidationIncentive) public onlyGovernance {
        // protecting against setting a very high liquidation incentive. Max 10%
        require(_liquidationIncentive <= PRECISION / 10, "MA.syncDeps.LI_GT_10_percent");
        IRegistry registry = IRegistry(_registry);
        require(registry.marginAccount() == address(this), "Incorrect setup");

        clearingHouse = IClearingHouse(registry.clearingHouse());
        oracle = IOracle(registry.oracle());
        insuranceFund = IInsuranceFund(registry.insuranceFund());
        liquidationIncentive = _liquidationIncentive;
    }