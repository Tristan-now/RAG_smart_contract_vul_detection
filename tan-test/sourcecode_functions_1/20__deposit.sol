function _deposit(address _synth, address _member, uint256 _amount) internal {
    if (!isStakedSynth[_synth]) {
        isStakedSynth[_synth] = true; // Record as a staked synth
        stakedSynthAssets.push(_synth); // Add to staked synth array
    }
    mapMemberSynth_lastTime[_member][_synth] =
        block.timestamp +
        minimumDepositTime; // Record deposit time (scope: member -> synth)
    mapMember_depositTime[_member] = block.timestamp + minimumDepositTime; // Record deposit time (scope: member)
    mapMemberSynth_deposit[_member][_synth] += _amount; // Record balance for member
    uint256 _weight = iUTILS(_DAO().UTILS()).calcSpotValueInBase(
        iSYNTH(_synth).LayerONE(),
        _amount
    ); // Get the SPARTA weight of the deposit
    mapMemberSynth_weight[_member][_synth] += _weight; // Add the weight to the user (scope: member -> synth)
    mapMemberTotal_weight[_member] += _weight; // Add to the user's total weight (scope: member)
    totalWeight += _weight; // Add to the total weight (scope: vault)
    isSynthMember[_member][_synth] = true; // Record user as a member
    emit MemberDeposits(_synth, _member, _amount, _weight, totalWeight);
}