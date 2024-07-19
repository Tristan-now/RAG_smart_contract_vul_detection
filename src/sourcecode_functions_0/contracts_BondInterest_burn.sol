function burn(address from, uint128 amount) external override onlyConvenience {
        _burn(from, amount);
    }