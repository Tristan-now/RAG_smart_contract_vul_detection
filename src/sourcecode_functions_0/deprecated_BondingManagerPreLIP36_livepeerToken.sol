function livepeerToken() internal view returns (ILivepeerToken) {
        return ILivepeerToken(controller.getContract(keccak256("LivepeerToken")));
    }