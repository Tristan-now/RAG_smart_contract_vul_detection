function setCurvePercentThreshold(uint256 _curvePercentThreshold) external onlyOwner {
        curvePercentThreshold = _curvePercentThreshold;
        emit LogNewCurveThreshold(_curvePercentThreshold);
    }