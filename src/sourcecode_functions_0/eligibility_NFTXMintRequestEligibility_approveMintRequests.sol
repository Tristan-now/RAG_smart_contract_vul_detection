function approveMintRequests(
        uint256[] calldata tokenIds,
        address[] calldata addresses,
        bool mint
    ) external virtual {
        // Add here? Allow approval if finalized?
        require(!finalized(), "Finalized");
        if (!allowTrustedApprovals || !isGuardian[msg.sender]) {
            onlyPrivileged();
        }
        require(tokenIds.length == addresses.length);
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uint256 tokenId = tokenIds[i];
            uint256 amount = mintRequests[addresses[i]][tokenId];
            require(amount > 0, "No requests");
            if (mint) {
                approvedMints[addresses[i]][tokenId] = false;
                mintRequests[addresses[i]][tokenId] = 0;
                uint256[] memory _tokenIds;
                uint256[] memory _amounts;
                _tokenIds[0] = tokenId;
                _amounts[0] = amount;
                vault.mintTo(_tokenIds, _amounts, addresses[i]);
            } else {
                approvedMints[addresses[i]][tokenId] = true;
            }
        }
        return;
    }