// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "ds-test/test.sol";
import "solidity-trigonometry/Trigonometry.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";

contract testImage is DSTest {
    using Trigonometry for uint256;

    //mapping(uint256 => uint8) public pixels; 

    function coordinatesToIndex(uint256 _x, uint256 _y, uint256 _width) internal pure returns (uint256 index) {
            index = _y * _width + _x;
	}

    function _testBuffer() public view {

        uint256 y;

        bytes1[40200] memory pixels;

        for (uint256 x = 0; x <= 200; x++) {
            y = uint256((((x*10**18).sin()**2)/10**18)*50+(50*10**18)) / 10**18;
            pixels[(y * 200 + x)] = bytes1(0x01);
            pixels[((y-10) * 200 + x)] = bytes1(0x02);
            pixels[((y+20) * 200 + x)] = bytes1(0x03);
        }

        for (uint256 i = 0; i < 50; i++) {
            for (uint256 j = 0; j < 50; j++) {
                pixels[((i+90) * 200 + (j+135))] = bytes1(0x01);
                pixels[((i+80) * 200 + (j+120))] = bytes1(0x02);
                pixels[((i+100) * 200 + (j+130))] = bytes1(0x03);
            }

        } 

        bytes memory pixelData;
        bytes memory temp;

        for (uint256 i = 0; i < (40200-32); i+= 32) {
            
            pixelData = bytes.concat(pixelData, temp);

        } 



               

    }

    function testIndex() public {

        uint256 width = 200;
        uint256 height = 200;

        uint256 pixels = (width+1) * height;
        uint256 arraySize;

        if(pixels%32 != 0) {
            arraySize = pixels/32+1;
        } else {
            arraySize = pixels/32;
        }

        bytes32[] memory pixelArray = new bytes32[](arraySize);

        uint256 y;

        for (uint256 x = 0; x <= 200; x++) {
            
            y = uint256((((x*10**18).sin()**2)/10**18)*50+(50*10**18)) / 10**18;
            
            pixelArray[(y * 200 + x)/32] = replaceBytesAtIndex(pixelArray[(y * 200 + x)/32], uint8((y * 200 + x)%32), bytes1(0x01));
            pixelArray[((y-10) * 200 + x)/32] = replaceBytesAtIndex(pixelArray[((y-10) * 200 + x)/32], uint8(((y-10) * 200 + x)%32), bytes1(0x02));
            pixelArray[((y+10) * 200 + x)/32] = replaceBytesAtIndex(pixelArray[((y+10) * 200 + x)/32], uint8(((y+10) * 200 + x)%32), bytes1(0x03));
            
        }

        for (uint256 i = 0; i < 50; i++) {
            for (uint256 j = 0; j < 50; j++) {
                pixelArray[((i+90) * 200 + (j+135))/32] = replaceBytesAtIndex(pixelArray[((i+90) * 200 + (j+135))/32], uint8(((i+90) * 200 + (j+135))%32), bytes1(0x01));
                pixelArray[((i+80) * 200 + (j+120))/32] = replaceBytesAtIndex(pixelArray[((i+80) * 200 + (j+120))/32], uint8(((i+80) * 200 + (j+120))%32), bytes1(0x02));
                pixelArray[((i+100) * 200 + (j+130))/32] = replaceBytesAtIndex(pixelArray[((i+100) * 200 + (j+130))/32], uint8(((i+100) * 200 + (j+130))%32), bytes1(0x03));
            }
        } 

    }


    function _testIndex2() public {

        uint256 x2 = 10;
        int256 y2;
        y2 = ((((x2*10**18).sin()**2)/10**18)*50+(50*10**18)) / 10**18;
        emit log_int(y2);


    }

    function replaceBytesAtIndex(bytes32 original, uint8 position, bytes1 toInsert) public pure returns (bytes32) {
        bytes32 mask = bytes32(bytes1(0xff)) >> (position * 8);

        return (~mask & original) | (bytes32(toInsert) >> (position * 8));
    }



}