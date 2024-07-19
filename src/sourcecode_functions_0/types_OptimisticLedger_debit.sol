function debit(OptimisticLedger storage self, UFixed18 amount) internal {
        self.total = self.total.sub(amount);
    }