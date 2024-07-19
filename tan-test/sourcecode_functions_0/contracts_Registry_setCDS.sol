function setCDS(address _address, address _cds)
        external
        override
        onlyOwner
    {
        require(_cds != address(0), "ERROR: ZERO_ADDRESS");

        cds[_address] = _cds;
        emit CDSSet(_address, _cds);
    }