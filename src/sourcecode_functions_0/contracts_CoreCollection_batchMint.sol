function batchMint(
        address _to,
        uint256 _amount,
        bool _isClaim
    ) private {
        for (uint256 i = 0; i < _amount; i++) {
            uint256 tokenId = mint(_to);
            if (_isClaim) {
                emit NewClaim(msg.sender, _to, tokenId);
            }
        }
    }