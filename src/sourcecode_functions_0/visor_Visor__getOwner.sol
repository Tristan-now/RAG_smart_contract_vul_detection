function _getOwner() internal view override(ERC1271) returns (address ownerAddress) {
        return OwnableERC721.owner();
    }