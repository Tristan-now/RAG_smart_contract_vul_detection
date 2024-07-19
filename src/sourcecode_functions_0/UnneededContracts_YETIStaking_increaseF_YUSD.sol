function increaseF_YUSD(uint _YUSDFee) external override {
         _requireCallerIsBOOrTM();
         uint YUSDFeePerYETIStaked;
        
         if (totalYETIStaked != 0) {YUSDFeePerYETIStaked = _YUSDFee.mul(DECIMAL_PRECISION).div(totalYETIStaked);}
        
         F_YUSD = F_YUSD.add(YUSDFeePerYETIStaked);
         emit F_YUSDUpdated(F_YUSD);
     }