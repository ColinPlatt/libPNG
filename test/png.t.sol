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

    function testtRNS() public {
        emit log_bytes(png._tRNS(4, 3));
        emit log_bytes(abi.encodePacked(png._CRC(png._tRNS(4, 3),4)));

    }

    function _testSimpleImage() public {
        uint32 width = 2;
        uint32 height = 2;

        picture =  abi.encodePacked(bytes1(0x00), bytes1(0x01), bytes1(0x03), bytes1(0x00), bytes1(0x02),bytes1(0x03));       

        emit log_bytes(png.rawPNG(width, height, palette, picture, false));
        emit log_string(png.encodedPNG(width, height, palette, picture, false));

    }

    function testComplexImage() public {
        uint32 width = 64;
        uint32 height = 64;

        picture = pixels.buildSquares(width, height);

        emit log_bytes(png.rawPNG(width, height, palette, picture, false));
        emit log_string(png.encodedPNG(width, height, palette, picture, false));


    }

    function toIndex(uint256 _x, uint256 _y, uint256 _width) public pure returns (uint256 index){
        index = _y * (_width +1) + _x + 1;

    }

    function testBuildPixelArray() public {

        uint256 width = 256;
        uint256 height = 256;

        bytes memory pixelArray = new bytes((width+1) * height);

        for (uint256 i = 0; i < 200; i++) {
            for (uint256 j = 0; j < 200; j++) {
                pixelArray[toIndex(i + 40, j+20, width)] = bytes1(0x01);
                pixelArray[toIndex(i + 30, j+30, width)] = bytes1(0x02);
                pixelArray[toIndex(i + 20, j+40, width)] = bytes1(0x03);
                }
        }

        emit log_bytes(pixelArray);



    }



}