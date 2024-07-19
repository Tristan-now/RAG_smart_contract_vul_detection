function approve(address spender, uint256 tokenId) external {
        address owner = ownerOf[tokenId];
        require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "NOT_APPROVED");
        getApproved[tokenId] = spender;
        emit Approval(owner, spender, tokenId);
    }