function allowance(address owner, address spender) external view returns (uint256) {
        return a[owner][spender];
    }