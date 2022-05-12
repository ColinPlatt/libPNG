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
        palette.push(png.rgbToPalette(bytes1(0x00),bytes1(0x44),bytes1(0xcc)));
        palette.push(png.rgbToPalette(bytes1(0xcc),bytes1(0x00),bytes1(0x44)));
        palette.push(png.rgbToPalette(bytes1(0x00),bytes1(0xcc),bytes1(0x44)));
        
        pixels = new pixelImage();


    }

    function testtRNS() public {
        emit log_bytes(png._tRNS(4, 3));
        emit log_bytes(abi.encodePacked(png._CRC(png._tRNS(4, 3),4)));

    }

    function testReadPalette() public {

        picture = pixels.buildImage();

        //emit log_uint(palette.length);
        //emit log_bytes(picture);

        emit log_uint(false ? 256 : png.calculateBitDepth(palette.length));

        

        assertEq(bytes4(0xdb9c973e), png._CRC(png.formatPalette(palette, true),4));

        //rawPNG(uint256 width, uint256 height, bytes3[] memory palette, bytes memory pixels)
        emit log_bytes(png.rawPNG(uint32(16), uint32(16), palette, picture, false));
        emit log_string(png.encodedPNG(uint32(16), uint32(16), palette, picture, false));


    }



}