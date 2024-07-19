function _sortArray(LockedInfo[] memory arr, bool isPositive) private pure returns (LockedInfo[] memory) {
        uint256 length = arr.length;

        for (uint256 i = 0; i < length; i++) {
            for (uint256 j = i + 1; j < length; j++) {
                if (isPositive) {
                    if (arr[i].vouchingAmount < arr[j].vouchingAmount) {
                        LockedInfo memory temp = arr[j];
                        arr[j] = arr[i];
                        arr[i] = temp;
                    }
                } else {
                    if (arr[i].vouchingAmount > arr[j].vouchingAmount) {
                        LockedInfo memory temp = arr[j];
                        arr[j] = arr[i];
                        arr[i] = temp;
                    }
                }
            }
        }

        return arr;
    }