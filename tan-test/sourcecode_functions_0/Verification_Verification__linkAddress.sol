function _linkAddress(address _linked, address _master) private {
        uint64 _linkedAddressActivatesAt = uint64(block.timestamp + activationDelay);
        linkedAddresses[_linked] = LinkedAddress(_linkedAddressActivatesAt, _master);
        emit AddressLinked(_linked, _master, _linkedAddressActivatesAt);
    }