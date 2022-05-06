// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "ds-test/test.sol";

import 'solidity-bytes-utils/BytesLib.sol';

import  '../src/libBuffer.sol';


contract BufferTest is DSTest {

    function testSlice() public {

        bytes memory testByteData = abi.encodePacked('testing out how many');

        bytes1[] memory testData = new bytes1[](testByteData.length);

        for (uint256 i = 0; i<testData.length; i++) {
            testData[i] = bytes1(Buffer.slice(testByteData, i, 1));
        }

    }

    function testFunction() public {

        bytes memory testByteData = abi.encodePacked('testing out how many');

        bytes1[] memory testData;

        testData = Buffer.toBytes1Array(testByteData);
    }

    function testResult() public {

        bytes memory testByteData = abi.encodePacked('testing out how many');

        bytes1[] memory testDataFunction;

        testDataFunction = Buffer.toBytes1Array(testByteData);

        for (uint256 i = 0; i<testDataFunction.length; i++) {
            assertEq(testDataFunction[i],bytes1(Buffer.slice(testByteData, i, 1)));
        }

    }
    

}
    