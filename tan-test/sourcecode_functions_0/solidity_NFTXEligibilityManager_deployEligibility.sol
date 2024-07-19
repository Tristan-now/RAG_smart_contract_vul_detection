function deployEligibility(uint256 moduleIndex, bytes calldata configData)
        external
        virtual
        returns (address)
    {
        require(moduleIndex < modules.length, "Out of bounds");
        address eligImpl = modules[moduleIndex].implementation;
        address eligibilityClone = ClonesUpgradeable.clone(eligImpl);
        INFTXEligibility(eligibilityClone).__NFTXEligibility_init_bytes(
            configData
        );
        return eligibilityClone;
    }