function depositForMember(address synth, address member, uint amount) public {
        require((iFACTORY(FACTORY).isSynth(synth)), "Not Synth"); // Only Synths
        getFunds(synth, amount);
        _deposit(synth, member, amount);
    }