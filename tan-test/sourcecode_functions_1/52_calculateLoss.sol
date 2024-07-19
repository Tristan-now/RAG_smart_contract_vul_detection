function calculateLoss( uint256 originalVader, uint256 originalAsset, uint256 releasedVader, uint256 releasedAsset ) public pure returns (uint256 loss) {
        //
        // TODO: Vader Formula Differs https://github.com/vetherasset/vaderprotocol-contracts/blob/main/contracts/Utils.sol#L347-L356
        //

        // [(A0 * P1) + V0]
        uint256 originalValue = ((originalAsset * releasedVader) /
            releasedAsset) + originalVader;

        // [(A1 * P1) + V1]
        uint256 releasedValue = ((releasedAsset * releasedVader) /
            releasedAsset) + releasedVader;

        // [(A0 * P1) + V0] - [(A1 * P1) + V1]
        if (originalValue > releasedValue) loss = originalValue - releasedValue;
    }