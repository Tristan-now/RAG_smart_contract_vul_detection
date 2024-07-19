function getStatusAndUpdate(uint256 _id) public override returns (PooledCreditLineStatus) {
        PooledCreditLineStatus currentStatus = pooledCreditLineVariables[_id].status;
        if (currentStatus == PooledCreditLineStatus.ACTIVE && pooledCreditLineConstants[_id].endsAt <= block.timestamp) {
            if (pooledCreditLineVariables[_id].principal != 0) {
                currentStatus = PooledCreditLineStatus.EXPIRED;
            } else {
                currentStatus = PooledCreditLineStatus.CLOSED;
            }
            pooledCreditLineVariables[_id].status = currentStatus;
        }
        return currentStatus;
    }