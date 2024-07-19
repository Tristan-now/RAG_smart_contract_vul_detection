function setEndpoint(ILayerZeroEndpoint _endpoint) external onlyOwner {
        require(address(_endpoint) != address(0), "ZeroAddress");
        endpoint = _endpoint;
    }