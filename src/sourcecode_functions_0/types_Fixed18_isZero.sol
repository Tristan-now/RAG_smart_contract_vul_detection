function isZero(Fixed18 a) internal pure returns (bool) {
        return Fixed18.unwrap(a) == 0;
    }