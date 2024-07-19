function liquidationPrice(
        Info storage self,
        uint256 totalOi,
        uint256 totalOiShares,
        uint256 priceEntry,
        uint256 marginMaintenance
    ) internal view returns (
        uint256 liquidationPrice_
    ) {

        Info memory _self = self;

        liquidationPrice_ = _liquidationPrice(
            _self,
            totalOi,
            totalOiShares,
            priceEntry,
            marginMaintenance
        );

    }