function unstakeMulti(UnstakeRequest[] calldata requests) external {
        for (uint256 index = 0; index < requests.length; index++) {
            UnstakeRequest calldata request = requests[index];
            IHypervisor(request.hypervisor).unstakeAndClaim(
                request.vault,
                request.amount,
                request.permission
            );
        }
    }