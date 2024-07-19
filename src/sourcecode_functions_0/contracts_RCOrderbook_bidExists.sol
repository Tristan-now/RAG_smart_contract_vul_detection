function bidExists(
        address _user,
        address _market,
        uint256 _card
    ) public view override returns (bool) {
        if (user[_user].length != 0) {
            //some bids exist
            if (index[_user][_market][_card] != 0) {
                // this bid exists
                return true;
            } else {
                // check bid isn't index 0
                if (
                    user[_user][0].market == _market &&
                    user[_user][0].token == _card
                ) {
                    return true;
                }
            }
        }
        return false;
    }