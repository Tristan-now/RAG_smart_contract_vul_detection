function initialize(
        address _owner,
        uint256 _protocolFeeFraction,
        address _protocolFeeCollector,
        uint256 _liquidatorRewardFraction
    ) external initializer {
        OwnableUpgradeable.__Ownable_init();
        OwnableUpgradeable.transferOwnership(_owner);
        ReentrancyGuardUpgradeable.__ReentrancyGuard_init();

        _updateProtocolFeeFraction(_protocolFeeFraction);
        _updateProtocolFeeCollector(_protocolFeeCollector);
        _updateLiquidatorRewardFraction(_liquidatorRewardFraction);
    }