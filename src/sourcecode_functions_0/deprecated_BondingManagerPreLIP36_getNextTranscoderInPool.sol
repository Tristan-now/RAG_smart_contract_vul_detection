function getNextTranscoderInPool(address _transcoder) public view returns (address) {
        return transcoderPoolV2.getNext(_transcoder);
    }