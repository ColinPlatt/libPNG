// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.13;

import {png} from '../src/png.sol';

contract pixelImage {
    
    function viewImage() public pure returns (string memory) {
        
        bytes3[] memory palette = new bytes3[](3);

        palette[0] = png.rgbToPalette(bytes1(0xcc),bytes1(0x00),bytes1(0x44));
        palette[1] = png.rgbToPalette(bytes1(0x00),bytes1(0x44),bytes1(0xcc));
        palette[2] = png.rgbToPalette(bytes1(0x00),bytes1(0xcc),bytes1(0x44));
        
        uint32 width = 64;
        uint32 height = 64;

        bytes memory picture = buildSquares(width, height);

        return png.encodedPNG(width, height, palette, picture, false);

    }

    function toIndex(uint256 _x, uint256 _y, uint256 _width) public pure returns (uint256 index){
        index = _y * (_width +1) + _x + 1;
    }

    function buildSquares(uint32 width, uint32 height) public pure returns (bytes memory) {

        bytes memory pixelArray = new bytes((width+1) * height);

        unchecked{
            for (uint256 i = 0; i < 40; i++) {
                for (uint256 j = 0; j < 40; j++) {
                    pixelArray[toIndex(i + 20, j+10, width)] = bytes1(0x01);
                    pixelArray[toIndex(i + 15, j+15, width)] = bytes1(0x02);
                    pixelArray[toIndex(i + 10, j+20, width)] = bytes1(0x03);
                    }
            }
        }

        return pixelArray;

    }





}

