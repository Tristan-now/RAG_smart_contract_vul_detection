function mint(address account, uint256 amount)
        external
        override
        onlyMinter
        whenNotPaused
    {
        _mint(account, amount);
        emit Minting(account, msg.sender, amount);
    }