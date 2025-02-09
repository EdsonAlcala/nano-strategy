// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.26;

contract TReentrancyGuard {
    error ReentrancyForbidden();

    modifier nonreentrant() {
        assembly {
            if tload(0) {
                mstore(0x00, 0x2636fdca) // `ReentrancyForbidden()`.
                revert(0x1c, 0x04)
            }
            tstore(0, 1)
        }
        _;
        // Unlocks the guard, making the pattern composable.
        // After the function exits, it can be called again, even in the same transaction.
        assembly {
            tstore(0, 0)
        }
    }
}
