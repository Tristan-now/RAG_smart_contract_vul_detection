function setCvxCommunityReserveShare(uint256 cvxCommunityReserveShare_)
        external
        onlyGovernance
        returns (bool)
    {
        require(cvxCommunityReserveShare_ <= ScaledMath.ONE, Error.INVALID_AMOUNT);
        require(communityReserve != address(0), "Community reserve must be set");
        cvxCommunityReserveShare = cvxCommunityReserveShare_;
        emit SetCvxCommunityReserveShare(cvxCommunityReserveShare_);
        return true;
    }