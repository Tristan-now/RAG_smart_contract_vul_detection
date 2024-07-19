function _removeKeeperGauge(address pool) internal {
        address keeperGauge = _keeperGauges.get(pool);
        bytes32 key = _getKeeperGaugeKey(pool);
        _prepare(key, 0);
        _executeKeeperPoolWeight(key, pool, true);
        _keeperGauges.remove(pool);
        IKeeperGauge(keeperGauge).kill();
        // Do not delete from the gauges map to allow claiming of remaining balances
        emit KeeperGaugeDelisted(pool, keeperGauge);
    }