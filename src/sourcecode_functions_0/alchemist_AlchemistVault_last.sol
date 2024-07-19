function last(List storage _self) internal view returns (Data storage) {
        return _self.elements[_self.lastIndex()];
    }