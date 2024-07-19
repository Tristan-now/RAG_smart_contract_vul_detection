function addReserve(address _reserveHolder, uint256 _amount) internal {
        reserves[_reserveHolder].funds = reserves[_reserveHolder].funds.add(_amount);

        emit ReserveFunded(_reserveHolder, _amount);
    }