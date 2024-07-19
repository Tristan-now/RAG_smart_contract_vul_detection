function distribute(address _token, uint256[] calldata _toPids, uint256[] calldata _amounts) external {
       require(msg.sender == operator, "!auth");

       for(uint256 i = 0; i < _toPids.length; i++){
        //get stash from pid
        (,,,,address stashAddress,bool shutdown) = IDeposit(depositor).poolInfo(_toPids[i]);

        //if sent to a shutdown pool, could get trapped
        require(shutdown==false,"pool closed");

        //transfer
        IERC20(_token).safeTransfer(stashAddress, _amounts[i]);
       }
    }