function withdrawTokens(
        address _tokenAddress,
        uint256 _index,
        uint256 _id,
        uint256 _amount
    )
        external
    {
        require(_amount > 0, 'token amount is Zero');
        uint256 id = users[msg.sender].lockToItems[_tokenAddress][_index];
        Item storage userItem = lockedItem[id];
        require(id == _id && userItem.owner == msg.sender, 'LOCK MISMATCH');
        require(userItem.unlockTime < block.timestamp, 'Not unlocked yet');
        userItem.amount = userItem.amount.sub(_amount);

        if(userItem.amount == 0) {
            uint256[] storage userItems = users[msg.sender].lockToItems[_tokenAddress];
            userItems[_index] = userItems[userItems.length -1];
            userItems.pop();
        }

        _safeTransfer(_tokenAddress, msg.sender, _amount);

        emit onUnlock(_tokenAddress, _amount);
    }