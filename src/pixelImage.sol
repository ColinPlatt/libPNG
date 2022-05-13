// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import "solidity-trigonometry/Trigonometry.sol";
import "solidity-bytes-utils/BytesLib.sol";

contract pixelImage {
    using Trigonometry for uint256;
    
    function replaceBytesAtIndex(bytes32 original, uint8 position, bytes1 toInsert) public pure returns (bytes32) {
        bytes32 mask = bytes32(bytes1(0xff)) >> (position * 8);

        return (~mask & original) | (bytes32(toInsert) >> (position * 8));
    }

    function buildImage() public pure returns (bytes memory) {

        uint256 width = 16;
        uint256 height = 16;

        uint256 pixels = (width+1) * height;
        uint256 arraySize;

        if(pixels%32 != 0) {
            arraySize = pixels/32+1;
        } else {
            arraySize = pixels/32;
        }

        bytes32[] memory pixelArray = new bytes32[](arraySize);

        uint256 y;

        for (uint256 x = 0; x <= width; x++) {
            
            y = uint256((((x*10**18).sin()**2)/10**18)*2+(4*10**18)) / 10**18;
            
            pixelArray[(y * 16 + x)/32] = replaceBytesAtIndex(pixelArray[(y * 16 + x)/32], uint8((y * 16 + x)%32), bytes1(0x01));
            
        }

        bytes memory completeArray;

        if(pixels%32 != 0) {
            for (uint256 i = 0; i<arraySize-1; i++) {
                completeArray = bytes.concat(completeArray, pixelArray[i]);
            }
            completeArray = bytes.concat(completeArray, BytesLib.slice(abi.encodePacked(pixelArray[arraySize-1]),0,pixels%32));
        } else {
            for (uint256 i = 0; i<arraySize; i++) {
                completeArray = bytes.concat(completeArray, pixelArray[i]);
            }
        }

        return completeArray;

    }

    function toIndex(uint256 _x, uint256 _y, uint256 _width) public pure returns (uint256 index){
        index = _y * (_width +1) + _x + 1;
    }

    function buildSquares(uint32 width, uint32 height) public pure returns (bytes memory) {

        bytes memory pixelArray = new bytes((width+1) * height);

        for (uint256 i = 0; i < 40; i++) {
            for (uint256 j = 0; j < 40; j++) {
                pixelArray[toIndex(i + 20, j+10, width)] = bytes1(0x01);
                pixelArray[toIndex(i + 15, j+15, width)] = bytes1(0x02);
                pixelArray[toIndex(i + 10, j+20, width)] = bytes1(0x03);
                }
        }

        return pixelArray;

    }





}

