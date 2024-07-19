function tryCatch(address to, uint value, bytes calldata data)
		external
	{
		require(msg.sender == address(this), 'ONLY_IDENTITY_CAN_CALL');
		(bool success, bytes memory returnData) = to.call{value: value, gas: gasleft()}(data);
		if (!success) emit LogErr(to, value, data, returnData);
	}