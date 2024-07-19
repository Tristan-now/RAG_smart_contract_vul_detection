function trimToSize(bytes memory b, uint newLen)
    internal
    pure
  {
    require(b.length > newLen, "BytesLib: only shrinking");
    assembly {
      mstore(b, newLen)
    }
  }