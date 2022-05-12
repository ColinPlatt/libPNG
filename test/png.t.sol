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

    function _testPixelArray() public {

        bytes32[] memory array = pixels.buildSquaresArray(32, 32);

        for(uint256 i = 0; i<array.length; i++) {
            emit log_bytes32(array[i]);
        }
        

    }

    function _testComplexImage() public {
        uint32 width = 32;
        uint32 height = 32;

        picture = pixels.buildSquares(width, height);

        emit log_bytes(png.rawPNG(width, height, palette, picture, false));
        emit log_string(png.encodedPNG(width, height, palette, picture, false));


    }

    function toIndex(uint256 _x, uint256 _y, uint256 _width) public pure returns (uint256 index){
        index = _y * _width + _x;

    }

    function testBuildPixelArray() public {

        uint256 width = 8;
        uint256 height = 8;

        uint256 pixels = (width+1) * height;
        uint256 arraySize;

        if(pixels%32 != 0) {
            arraySize = pixels/32+1;
        } else {
            arraySize = pixels/32;
        }

        bytes32[] memory pixelArray = new bytes32[](arraySize);

        emit log_uint(arraySize);
        emit log_uint(pixels);



    }



}