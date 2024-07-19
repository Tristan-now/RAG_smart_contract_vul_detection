function calcShare( uint256 part, uint256 total, uint256 amount ) public pure returns (uint256 share) {
    if (part > total) {
        part = total; // Part cant be greater than the total
    }
    if (total > 0) {
        share = (amount * part) / total;
    }
}