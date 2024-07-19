function scryRollers (
        Roller[60] storage rollers,
        uint _cycloid,
        uint _target
    ) internal view returns (
        Roller memory beforeOrAt_,
        Roller memory atOrAfter_
    ) {

        beforeOrAt_ = rollers[_cycloid];

        // if the target is at or after the newest roller, we can return early
        if (beforeOrAt_.time <= _target) {

            if (beforeOrAt_.time == _target) {

                // if newest roller equals target, we're in the same block, so we can ignore atOrAfter
                return ( beforeOrAt_, atOrAfter_ );

            } else {

                atOrAfter_.time = block.timestamp;
                atOrAfter_.ying = beforeOrAt_.ying;
                atOrAfter_.yang = beforeOrAt_.yang;

                return ( beforeOrAt_, atOrAfter_ );

            }
        }

        // now, set before to the oldest roller
        _cycloid = ( _cycloid + 1 ) % CHORD;

        beforeOrAt_ = rollers[_cycloid];

        if ( beforeOrAt_.time <= 1 ) {

            beforeOrAt_ = rollers[0];

        }

        if (_target <= beforeOrAt_.time) return ( beforeOrAt_, beforeOrAt_ );
        else return binarySearch(
            rollers,
            uint32(_target),
            uint16(_cycloid)
        );

    }