// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "ds-test/test.sol";

contract ContractTest is DSTest {
    
    struct PIXEL {
        uint8[2] index;
        uint8[3] RGB;
    }

    struct IMAGE {
        PIXEL[] pixels;
    }
    
    function setUp() public {}

    function testExample() public {
        assertTrue(true);
    }
}
