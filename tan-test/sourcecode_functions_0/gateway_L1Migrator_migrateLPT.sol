function migrateLPT(
        uint256 _maxGas,
        uint256 _gasPriceBid,
        uint256 _maxSubmissionCost
    ) external payable whenNotPaused {
        uint256 amount = IBridgeMinter(bridgeMinterAddr)
            .withdrawLPTToL1Migrator();

        // Approve L1LPTGateway to pull tokens
        ApproveLike(tokenAddr).approve(l1LPTGatewayAddr, amount);
        // Trigger cross-chain transfer with L1LPTGateway which will pull and escrow tokens
        // Forward msg.value to outboundTransfer() to be used for cross-chain tx
        IL1LPTGateway(l1LPTGatewayAddr).outboundTransfer{value: msg.value}(
            tokenAddr,
            l2MigratorAddr,
            amount,
            _maxGas,
            _gasPriceBid,
            abi.encode(_maxSubmissionCost, "")
        );
    }