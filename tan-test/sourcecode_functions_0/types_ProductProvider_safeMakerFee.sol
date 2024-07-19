function safeMakerFee(IProductProvider self) internal view returns (UFixed18) {
        return self.makerFee().min(UFixed18Lib.ONE);
    }