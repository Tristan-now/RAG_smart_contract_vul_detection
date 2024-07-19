function setGuestList(address _guestList) external whenNotPaused {
        _onlyGovernance();
        guestList = BadgerGuestListAPI(_guestList);
    }