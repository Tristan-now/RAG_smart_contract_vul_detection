function calSellAmount(address buyToken, address sellToken, uint24 buyTax, uint24 sellTax, uint buyAmount, bytes memory data) external view override returns (uint sellAmount){
        sellAmount = uniClassCalSellAmount(dexInfo[data.toDex()], buyToken, sellToken, buyAmount, buyTax, sellTax);
    }