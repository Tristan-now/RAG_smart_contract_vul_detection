function setBorrowAmountCap(uint256 _borrowAmountCap)
        external
        onlyRole(DAO_ROLE)
    {
        settings.borrowAmountCap = _borrowAmountCap;
    }