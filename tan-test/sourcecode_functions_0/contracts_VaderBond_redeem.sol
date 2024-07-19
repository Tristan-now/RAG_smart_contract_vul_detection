function redeem(address _depositor) external nonReentrant returns (uint) {
        Bond memory info = bondInfo[_depositor];
        uint percentVested = percentVestedFor(_depositor); // (blocks since last interaction / vesting term remaining)

        if (percentVested >= MAX_PERCENT_VESTED) {
            // if fully vested
            delete bondInfo[_depositor]; // delete user info
            emit BondRedeemed(_depositor, info.payout, 0); // emit bond data
            payoutToken.transfer(_depositor, info.payout);
            return info.payout;
        } else {
            // if unfinished
            // calculate payout vested
            uint payout = info.payout.mul(percentVested) / MAX_PERCENT_VESTED;

            // store updated deposit info
            bondInfo[_depositor] = Bond({
                payout: info.payout.sub(payout),
                vesting: info.vesting.sub(block.number.sub(info.lastBlock)),
                lastBlock: block.number
            });

            emit BondRedeemed(_depositor, payout, bondInfo[_depositor].payout);
            payoutToken.transfer(_depositor, payout);
            return payout;
        }
    }