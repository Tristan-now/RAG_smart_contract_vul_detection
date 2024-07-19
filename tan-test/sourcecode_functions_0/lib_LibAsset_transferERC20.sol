function transferERC20(
        address assetId,
        address recipient,
        uint256 amount
    ) internal returns (bool) {
        return LibERC20.transfer(assetId, recipient, amount);
    }