function pricePerShare() external view returns (uint) {
        return ICore(core).pricePerShare();
    }