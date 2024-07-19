function _setState(bytes32 _claimIdentifier, State _state) internal returns (State _oldState) {
    // retrieves the Claim object
    Claim storage claim = claims_[_claimIdentifier];
    // retrieves the current state (which we preemptively set to the old state)
    _oldState = claim.state;

    emit ClaimStatusChanged(internalToPublicID[_claimIdentifier], _oldState, _state);

    // If the new state is NonExistent, then we clean up this claim (delete the claim effectively)
    // Else we update the state to the new state and record the last updated timestamp
    if (_state == State.NonExistent) {
      _cleanUpClaim(_claimIdentifier);
    } else {
      claims_[_claimIdentifier].state = _state;
      claims_[_claimIdentifier].updated = block.timestamp;
    }
  }