function balanceOf(address account) public view returns (uint256) {
        return deposits.balanceOf(account);
    }