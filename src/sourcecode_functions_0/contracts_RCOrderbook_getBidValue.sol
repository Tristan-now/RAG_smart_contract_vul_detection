function getBidValue(address _user, uint256 _card)
        external
        view
        override
        returns (uint256)
    {
        address _market = msgSender();
        if (bidExists(_user, _market, _card)) {
            return user[_user][index[_user][_market][_card]].price;
        } else {
            return 0;
        }
    }