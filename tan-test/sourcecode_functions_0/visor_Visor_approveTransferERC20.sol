function approveTransferERC20(address token, address delegate, uint256 amount) external onlyOwner {
      erc20Approvals[keccak256(abi.encodePacked(delegate, token))] = amount;
    }