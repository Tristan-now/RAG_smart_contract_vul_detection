function request() external validRequest {
        if (!isWhitelisted[msg.sender]) {
            nextValidRequest[msg.sender] = block.timestamp + requestWait * 1 hours;
        }

        token.transfer(msg.sender, requestAmount);

        emit Request(msg.sender, requestAmount);
    }