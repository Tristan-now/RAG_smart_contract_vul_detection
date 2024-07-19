function _getPoints(uint256 amount_, uint256 duration_) internal view returns (uint256 points_) {
        return amount_ * (duration_ + _zeroDurationPointBase);
    }