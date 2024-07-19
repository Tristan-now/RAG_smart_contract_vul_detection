function setHalted()
        external
        notHalted
        onlyStrategist
    {
        halted = true;
        emit Halted();
    }