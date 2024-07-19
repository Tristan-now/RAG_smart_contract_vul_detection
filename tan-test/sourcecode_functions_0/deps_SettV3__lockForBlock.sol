function _lockForBlock(address account) internal {
        blockLock[account] = block.number;
    }