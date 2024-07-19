function batchAddDex(address[] calldata _dexs) external {
        LibDiamond.enforceIsContractOwner();

        for (uint256 i; i < _dexs.length; i++) {
            if (s.dexWhitelist[_dexs[i]] == true) {
                continue;
            }
            s.dexWhitelist[_dexs[i]] = true;
            s.dexs.push(_dexs[i]);
        }
    }