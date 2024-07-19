function initialize(
        string memory name_,
        address underlying_,
        uint256 depositCap_,
        address vault_
    ) public override returns (bool) {
        require(underlying_ != address(0), Error.ZERO_ADDRESS_NOT_ALLOWED);
        _underlying = underlying_;
        return _initialize(name_, depositCap_, vault_);
    }