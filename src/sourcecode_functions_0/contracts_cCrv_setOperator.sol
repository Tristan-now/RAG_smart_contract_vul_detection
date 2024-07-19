function setOperator(address _operator) external {
        require(msg.sender == operator, "!auth");
        operator = _operator;
    }