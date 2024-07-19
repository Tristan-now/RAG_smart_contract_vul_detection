function _setUniqueEligibilities(
        uint256[] memory tokenIds,
        bool _isEligible
    ) internal virtual {
        uint256 cachedWord = eligibleBitMap[0];
        uint256 cachedIndex = 0;
        for (uint256 i = 0; i < tokenIds.length; i++) {
            uint256 tokenId = tokenIds[i];
            uint256 eligibilityWordIndex = tokenId / 256;
            if (eligibilityWordIndex != cachedIndex) {
                // Save the cached word.
                eligibleBitMap[cachedIndex] = cachedWord;
                // Cache the new one.
                cachedWord = eligibleBitMap[eligibilityWordIndex];
                cachedIndex = eligibilityWordIndex;
            }
            // Modify the cached word.
            cachedWord = _setBit(cachedWord, tokenId, _isEligible);
        }
        // Assign the last word since the loop is done.
        eligibleBitMap[cachedIndex] = cachedWord;
        emit UniqueEligibilitiesSet(tokenIds, _isEligible);
    }