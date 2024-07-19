function requestAndBorrow(
        uint256 tokenId,
        address lender,
        address recipient,
        TokenLoanParams memory params,
        bool skimCollateral,
        bool anyTokenId,
        SignatureParams memory signature
    ) public {
        if (signature.v == 0 && signature.r == bytes32(0) && signature.s == bytes32(0)) {
            require(ILendingClub(lender).willLend(tokenId, params), "NFTPair: LendingClub does not like you");
        } else {
            require(block.timestamp <= signature.deadline, "NFTPair: signature expired");
            uint256 nonce = nonces[lender]++;
            bytes32 dataHash = keccak256(
                abi.encode(
                    LEND_SIGNATURE_HASH,
                    address(this),
                    anyTokenId ? 0 : tokenId,
                    anyTokenId,
                    params.valuation,
                    params.duration,
                    params.annualInterestBPS,
                    params.ltvBPS,
                    params.oracle,
                    nonce,
                    signature.deadline
                )
            );
            require(ecrecover(_getDigest(dataHash), signature.v, signature.r, signature.s) == lender, "NFTPair: signature invalid");
        }
        _requestLoan(msg.sender, tokenId, params, recipient, skimCollateral);
        _lend(lender, tokenId, params, false);
    }