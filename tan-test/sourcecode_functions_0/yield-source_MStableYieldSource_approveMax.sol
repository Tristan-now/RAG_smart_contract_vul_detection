function approveMax() public {
        IERC20(savings.underlying()).safeApprove(address(savings), type(uint256).max);

        emit ApprovedMax(msg.sender);
    }