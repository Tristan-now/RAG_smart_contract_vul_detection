function from(int256 a) internal pure returns (Fixed18) {
        return Fixed18.wrap(a * BASE);
    }