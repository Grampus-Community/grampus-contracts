// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../base/Ownable.sol';
import '../base/IERC20.sol';
import './SyrupPool.sol';

contract SyrupPoolFactory is Ownable {
    event OnDeploySyrupPool(address indexed syrupPool);

    function deployPool(address stakedToken, address rewardToken, address admin) external onlyOwner returns(address) {
 
        IERC20 _stakedToken = IERC20(stakedToken);

        IERC20 _rewardToken = IERC20(rewardToken);

        bytes memory bytecode = type(SyrupPool).creationCode;

        bytes32 salt = keccak256(abi.encodePacked(_stakedToken, _rewardToken));

        address syrupPoolAddress;

        assembly {
            syrupPoolAddress := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }

        SyrupPool(syrupPoolAddress).initialize(
            _stakedToken,

            _rewardToken,

            admin
        );

        emit OnDeploySyrupPool(syrupPoolAddress);

        return syrupPoolAddress;
    }
}
