function ps() internal pure returns (Base storage psx) {
    bytes32 position = PAYOUT_STORAGE_POSITION;
    assembly {
      psx.slot := position
    }
  }