// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "ds-test/test.sol";

import {png} from '../src/png.sol';
import {pixelImage} from "../src/pixelImage.sol";

contract PNGTest is DSTest {

    pixelImage pixels;

    bytes3[] public palette;
    bytes picture;

    function setUp() public {

        palette.push(png.rgbToPalette(bytes1(0xcc),bytes1(0x00),bytes1(0x44)));
        palette.push(png.rgbToPalette(bytes1(0x00),bytes1(0x44),bytes1(0xcc)));
        palette.push(png.rgbToPalette(bytes1(0x00),bytes1(0xcc),bytes1(0x44)));
        
        pixels = new pixelImage();


    }


    function testSimpleImage() public {
        uint32 width = 2;
        uint32 height = 2;

        picture =  abi.encodePacked(bytes1(0x00), bytes1(0x01), bytes1(0x03), bytes1(0x00), bytes1(0x02),bytes1(0x03));       

        emit log_bytes(png.rawPNG(width, height, palette, picture, false));
        emit log_string(png.encodedPNG(width, height, palette, picture, false));

    }

    function testComplexImage() public {
        uint32 width = 256;
        uint32 height = 256;

        picture = pixels.buildSquares(width, height);

        emit log_bytes(png.rawPNG(width, height, palette, picture, false));
        emit log_string(png.encodedPNG(width, height, palette, picture, false));


    }

    function testViewImage() public {

        emit log_string(pixels.viewImage());

    }


}