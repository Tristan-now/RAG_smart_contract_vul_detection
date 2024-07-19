function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external view returns (bytes4) {
        IVaultRegistry registry = _internalParams.registry;
        require(msg.sender == address(registry), ExceptionsLibrary.NFT_VAULT_REGISTRY);
        return this.onERC721Received.selector;
    }