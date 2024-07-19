function setIsTrusted(address user, bool trusted) public virtual requiresTrust {
        isTrusted[user] = trusted;

        emit UserTrustUpdated(user, trusted);
    }