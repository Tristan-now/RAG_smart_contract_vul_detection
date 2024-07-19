function setFactories(address _rfactory, address _sfactory, address _tfactory) external {
        require(msg.sender == owner, "!auth");

        //stash factory should be considered more safe to change
        //updating may be required to handle new types of gauges
        stashFactory = _sfactory;

        //reward factory only allow this to be called once even if owner
        //removes ability to inject malicious staking contracts
        //token factory can also be immutable
        if(rewardFactory == address(0)){
            rewardFactory = _rfactory;
            tokenFactory = _tfactory;

            emit FactoriesUpdated(_rfactory, _sfactory, _tfactory);
        } else {
            emit FactoriesUpdated(address(0), _sfactory, address(0));
        }
    }