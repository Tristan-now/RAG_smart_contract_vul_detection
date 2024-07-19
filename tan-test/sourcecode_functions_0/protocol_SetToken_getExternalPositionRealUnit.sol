function getExternalPositionRealUnit(address _component, address _positionModule) public view returns(int256) {
        return _convertVirtualToRealUnit(_externalPositionVirtualUnit(_component, _positionModule));
    }