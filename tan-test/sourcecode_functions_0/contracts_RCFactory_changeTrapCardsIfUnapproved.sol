function changeTrapCardsIfUnapproved() external onlyOwner {
        trapIfUnapproved = !trapIfUnapproved;
    }