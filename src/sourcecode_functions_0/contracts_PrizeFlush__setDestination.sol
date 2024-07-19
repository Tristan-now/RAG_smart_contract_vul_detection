function _setDestination(address _destination) internal {
        require(_destination != address(0), "Flush/destination-not-zero-address");
        destination = _destination;
    }