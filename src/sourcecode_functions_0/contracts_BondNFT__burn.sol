function _burn(
        uint256 _id
    ) internal override {
        delete _idToBond[_id];
        super._burn(_id);
    }