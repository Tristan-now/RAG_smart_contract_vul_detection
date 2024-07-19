function _processRentCollection(
        address _user,
        uint256 _card,
        uint256 _timeOfCollection
    ) internal {
        uint256 _rentOwed =
            (cardPrice[_card] *
                (_timeOfCollection - timeLastCollected[_card])) / 1 days;
        treasury.payRent(_rentOwed);
        uint256 _timeHeldToIncrement =
            (_timeOfCollection - timeLastCollected[_card]);

        // if the user has a timeLimit, adjust it as necessary
        if (cardTimeLimit[_card] != 0) {
            orderbook.reduceTimeHeldLimit(_user, _card, _timeHeldToIncrement);
            cardTimeLimit[_card] -= _timeHeldToIncrement;
        }
        timeHeld[_card][_user] += _timeHeldToIncrement;
        totalTimeHeld[_card] += _timeHeldToIncrement;
        rentCollectedPerUser[_user] += _rentOwed;
        rentCollectedPerCard[_card] += _rentOwed;
        rentCollectedPerUserPerCard[_user][_card] += _rentOwed;
        totalRentCollected += _rentOwed;
        timeLastCollected[_card] = _timeOfCollection;

        // longest owner tracking
        if (timeHeld[_card][_user] > longestTimeHeld[_card]) {
            longestTimeHeld[_card] = timeHeld[_card][_user];
            longestOwner[_card] = _user;
        }
        emit LogRentCollection(_rentOwed, timeHeld[_card][_user], _card, _user);
    }