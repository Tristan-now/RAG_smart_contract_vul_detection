function push(
        Token18 self,
        address recipient,
        UFixed18 amount
    ) internal {
        isEther(self)
            ? Address.sendValue(payable(recipient), toTokenAmount(self, amount))
            : IERC20(Token18.unwrap(self)).safeTransfer(recipient, toTokenAmount(self, amount));
    }