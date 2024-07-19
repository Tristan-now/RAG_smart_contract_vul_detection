function redeemWinningTicketNoRevert(
        Ticket memory _ticket,
        bytes memory _sig,
        uint256 _recipientRand
    ) internal returns (bool success) {
        // ABI encode calldata for `redeemWinningTicket()`
        // A tuple type is used to represent the Ticket struct in the function signature
        bytes memory redeemWinningTicketCalldata = abi.encodeWithSignature(
            "redeemWinningTicket((address,address,uint256,uint256,uint256,bytes32,bytes),bytes,uint256)",
            _ticket,
            _sig,
            _recipientRand
        );

        // Call `redeemWinningTicket()`
        // solium-disable-next-line
        (success, ) = address(this).call(redeemWinningTicketCalldata);
    }