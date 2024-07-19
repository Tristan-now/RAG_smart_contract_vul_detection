function getBufferCardinality() external view override returns (uint32) {
        return bufferMetadata.cardinality;
    }