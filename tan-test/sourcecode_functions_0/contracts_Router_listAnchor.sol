function listAnchor(address token) external {
        require(arrayAnchors.length < anchorLimit); // Limit
        require(iPOOLS(POOLS).isAnchor(token));     // Must be anchor
        arrayAnchors.push(token);                   // Add
        arrayPrices.push(iUTILS(UTILS()).calcValueInBase(token, one));
        _isCurated[token] = true; 
        updateAnchorPrice(token);
    }