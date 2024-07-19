function deposit(IERC4626 safe, address to, uint256 amount, uint256 minSharesOut) 
        public 
        payable 
        override 
        authenticate(address(safe)) 
        returns (uint256) 
    {
        return super.deposit(safe, to, amount, minSharesOut);
    }