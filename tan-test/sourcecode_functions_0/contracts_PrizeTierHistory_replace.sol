function replace(PrizeTier calldata newPrizeTier) external override onlyOwner {
        _replace(newPrizeTier);
    }