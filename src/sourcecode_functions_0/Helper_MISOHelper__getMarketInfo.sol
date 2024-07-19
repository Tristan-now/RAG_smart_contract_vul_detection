function _getMarketInfo(address _marketAddress) private view returns (MarketBaseInfo memory marketInfo) {
            uint64 templateId = market.getMarketTemplateId(_marketAddress);
            address auctionToken;
            uint64 startTime;
            uint64 endTime;
            bool finalized;
            (auctionToken, startTime, endTime, finalized) = IBaseAuction(_marketAddress)
                .getBaseInformation();
            TokenInfo memory tokenInfo = getTokenInfo(auctionToken);

            marketInfo.addr = _marketAddress;
            marketInfo.templateId = templateId;
            marketInfo.startTime = startTime;
            marketInfo.endTime = endTime;
            marketInfo.finalized = finalized;
            marketInfo.tokenInfo = tokenInfo;  
    }