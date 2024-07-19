function _addPool(address _gauge, uint256 _stashVersion) internal{
        if(protectAddPool) {
            require(msg.sender == operator, "!auth");
        }
        //get lp token from gauge
        address lptoken = ICurveGauge(_gauge).lp_token();

        //gauge/lptoken address checks will happen in the next call
        IPools(pools).addPool(lptoken,_gauge,_stashVersion);
    }