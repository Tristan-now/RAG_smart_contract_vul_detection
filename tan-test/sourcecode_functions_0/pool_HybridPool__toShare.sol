function _toShare(address token, uint256 input) internal view returns (uint256 output) {
        // @dev toShare(address,uint256,bool).
        (, bytes memory _output) = bento.staticcall(abi.encodeWithSelector(IBentoBoxMinimal.toShare.selector,
            token, input, false));
        output = abi.decode(_output, (uint256));
    }