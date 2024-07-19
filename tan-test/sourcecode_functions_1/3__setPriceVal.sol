function _setPriceVal( TokenPrice storage tokenPrice, uint256 inAmount, uint256 outAmount, uint256 weightPerMil ) internal {
    uint256 updatePer1k = (1000 ether * inAmount) / (outAmount + 1);
    tokenPrice.tokenPer1k =
        (tokenPrice.tokenPer1k *
            (1000 - weightPerMil) +
            updatePer1k *
            weightPerMil) /
        1000;
}