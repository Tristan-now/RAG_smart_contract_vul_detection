function initToken(
        bytes calldata _data
    ) public override {
        (string memory _name,
        string memory _symbol,
        address _owner,
        uint256 _initialSupply) = abi.decode(_data, (string, string, address, uint256));

        initToken(_name,_symbol,_owner,_initialSupply);
    }