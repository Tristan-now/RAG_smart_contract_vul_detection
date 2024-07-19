function setMintingFee(uint256 _newMintingFee)
        external
        override
        onlyOwner
    {
        require(_newMintingFee <= FEE_LIMIT, "Exceeds fee limit");
        _mintingFee = _newMintingFee;
        emit MintingFeeChanged(_newMintingFee);
    }