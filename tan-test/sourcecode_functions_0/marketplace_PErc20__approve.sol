function _approve(address o, address s, uint256 a) internal virtual {
        require(o != address(0), "erc20 approve from the zero address");
        require(s != address(0), "erc20 approve to the zero address");

        allowances[o][s] = a;
        emit Approval(o, s, a);
    }