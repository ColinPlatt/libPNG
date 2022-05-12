// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "ds-test/test.sol";
import "solidity-trigonometry/Trigonometry.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";

import {pixelImage} from "../src/pixelImage.sol";

contract testImage is DSTest {
    using Trigonometry for uint256;

    pixelImage pixels;

    function setUp() public logs_gas {

        pixels = new pixelImage();

    }

    function testImagePixelsOutput() public {

        emit log_bytes(pixels.buildImage());

    }


    

}