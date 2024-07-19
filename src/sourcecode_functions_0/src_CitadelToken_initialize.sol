function initialize(
        string memory _name,
        string memory _symbol,
        address _gac
    ) public initializer {
        __ERC20_init(_name, _symbol);
        __GlobalAccessControlManaged_init(_gac);
    }