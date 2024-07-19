function delegates(address delegator)
        external
        view
        returns (address)
    {
        return _delegates[delegator];
    }