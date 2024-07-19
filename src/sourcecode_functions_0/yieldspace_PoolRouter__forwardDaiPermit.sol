function _forwardDaiPermit(PoolAddresses memory addresses, address spender, uint256 nonce, uint256 deadline, bool allowed, uint8 v, bytes32 r, bytes32 s)
        private
    {
        // Only the base token would ever be Dai
        DaiAbstract(addresses.base).permit(msg.sender, spender, nonce, deadline, allowed, v, r, s);
    }