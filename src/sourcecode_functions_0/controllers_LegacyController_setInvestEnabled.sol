function setInvestEnabled(
        bool _investEnabled
    )
        external
        onlyStrategist
    {
        investEnabled = _investEnabled;
    }