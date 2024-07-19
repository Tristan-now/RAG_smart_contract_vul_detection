function getIndex(uint32 id) external view returns (uint32) {
        return history.binarySearch(id);
    }