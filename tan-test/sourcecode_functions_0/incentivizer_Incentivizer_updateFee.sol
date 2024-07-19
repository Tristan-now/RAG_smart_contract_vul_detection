function updateFee(UFixed18 newFee) onlyOwner external {
        fee = newFee;

        emit FeeUpdated(newFee);
    }