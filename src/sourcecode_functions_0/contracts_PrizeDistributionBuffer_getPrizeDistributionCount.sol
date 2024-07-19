function getPrizeDistributionCount() external view override returns (uint32) {
        DrawRingBufferLib.Buffer memory buffer = bufferMetadata;

        if (buffer.lastDrawId == 0) {
            return 0;
        }

        uint32 bufferNextIndex = buffer.nextIndex;

        // If the buffer is full return the cardinality, else retun the nextIndex
        if (prizeDistributionRingBuffer[bufferNextIndex].matchCardinality != 0) {
            return buffer.cardinality;
        } else {
            return bufferNextIndex;
        }
    }