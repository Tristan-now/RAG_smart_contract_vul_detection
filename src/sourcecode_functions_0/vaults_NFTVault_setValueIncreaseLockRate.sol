function setValueIncreaseLockRate(Rate memory _valueIncreaseLockRate)
        external
        onlyRole(DAO_ROLE)
    {
        _validateRate(_valueIncreaseLockRate);
        settings.valueIncreaseLockRate = _valueIncreaseLockRate;
    }