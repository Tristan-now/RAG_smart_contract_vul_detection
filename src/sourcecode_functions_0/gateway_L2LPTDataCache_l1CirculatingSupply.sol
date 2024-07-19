function l1CirculatingSupply() public view returns (uint256) {
        // After the first update from L1, l1TotalSupply should always be >= l2SupplyFromL1
        // The below check is defensive to avoid reverting if this invariant for some reason violated
        return
            l1TotalSupply >= l2SupplyFromL1
                ? l1TotalSupply - l2SupplyFromL1
                : 0;
    }