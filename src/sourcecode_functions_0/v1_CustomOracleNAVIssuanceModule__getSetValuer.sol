function _getSetValuer(ISetToken _setToken) internal view returns (ISetValuer) {
        ISetValuer customValuer =  navIssuanceSettings[_setToken].setValuer;
        return address(customValuer) == address(0) ? controller.getSetValuer() : customValuer;
    }