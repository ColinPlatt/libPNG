// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "ds-test/test.sol";

import 'solidity-bytes-utils/BytesLib.sol';

import {PNGData} from '../src/PNGData.sol';

import {checkSums} from '../src/libCheckSums.sol';
import  '../src/libBuffer.sol';


contract PNGDataTest is DSTest {
    
    PNGData lib;

    uint256 currentCRC;

    function setUp() public {
        lib = new PNGData();
    }

    function _testIHDR() public {
        emit log_bytes(lib.getIHDRChunk(uint32(uint8(1)), uint32(uint8(1))));
        emit log_bytes(checkSums.getIHDRChunk(uint32(uint8(1)), uint32(uint8(1))));

    }

    function testCRC() public {

        assertEq(uint32(lib.writeCRC(abi.encodePacked('IEND'), 0, 4)), uint32(0xae426082));
        assertEq(uint32(checkSums.writeCRC(abi.encodePacked('IEND'), 0, 4)), uint32(0xae426082));

        bytes memory idhrTestData = lib.getIHDRChunk(uint32(uint8(1)), uint32(uint8(1)));

        assertEq(uint32(lib.writeCRC(idhrTestData, 2, 17)), uint32(3653058524));
        assertEq(uint32(checkSums.writeCRC(idhrTestData, 2, 17)), uint32(3653058524));


        bytes memory sRGB = abi.encodePacked(bytes5(0x7352474200));

        assertEq(uint32(lib.writeCRC(sRGB, 0, 5)), uint32(0xAECE1CE9));
        assertEq(uint32(checkSums.writeCRC(sRGB, 0, 5)), uint32(0xAECE1CE9));


    }

    function _testAdler() public {

        string memory testString = 'Wikipedia';

        bytes memory testStringBytes = abi.encodePacked(testString);

        emit log_bytes(testStringBytes);

        bytes1[] memory testData = new bytes1[](9);

        for (uint256 i = 0; i<testData.length; i++) {
            testData[i] = bytes1(BytesLib.slice(testStringBytes, i, 1));
            emit log_uint(uint8(testData[i]));
        }

        bytes4 testOutput = checkSums._adler32(testData, 9);

        emit log_bytes(abi.encodePacked(testOutput));

    }

    function _testRGB() public {

        bytes4 R = bytes4(uint32(255));
        bytes4 G = bytes4(uint32(0));
        bytes4 B = bytes4(uint32(0));
        bytes4 ALPHA = bytes4(uint32(0));

        bytes4 colour;

        colour = (((((ALPHA << 8) | R) << 8) | G) << 8) | B;

        emit log_bytes(abi.encodePacked(colour));


    }

    function _testLayout() public {

        emit log_bytes(lib.layOutData());

        uint16 header = ((uint16(8)+(uint16(7) << 4)) << 8) | (uint16(3) << 6);
        header += 31 - (header % 31);
        // 0x78da
        // 0x081D << from example

        int24 n = 3;

        // initialize deflate block headers
		for (int24 i = 0; (i << 16) - 1 < n; i++) {
			int24 size;
            bytes1 bits;

			if (i + 0xffff < n) {
				size = 0xffff;
				bits = 0x00;
			} else {
				size = n - (i << 16) - i;
				bits = 0x01;
			}
			emit log_bytes(abi.encodePacked(bits));
            emit log_bytes(abi.encodePacked(bytes2(uint16(uint24(size)))));
            emit log_bytes(abi.encodePacked(~bytes2(uint16(uint24(size)))));

            emit log_uint(2 + 1 + 5 * uint256(uint256(0xfffe + 1) / 0xffff) + 4);

            emit log_uint(uint24(i <<16));
            emit log_uint(uint24(i <<2));
		
		}


        emit log_bytes(abi.encodePacked(header));
    }

    function testAdlerCRC() public {

        bytes10 pixels = 0x00FF000000FF000000FF;
        bytes memory testStringBytes = abi.encodePacked(bytes10(pixels));

        bytes4 adler = checkSums._adler32(Buffer.toBytes1Array(testStringBytes), testStringBytes.length);

        //0x0EFB02FE
        assertEq(adler, bytes4(0x0EFB02FE));

        //header data to check less adler and colours
        bytes7 header = 0x081D010A00F5FF;

        bytes21 zlib = bytes21(abi.encodePacked(header, pixels, adler));

        assertEq(zlib, bytes21(0x081D010A00F5FF00FF000000FF000000FF0EFB02FE));

        bytes4 crcIdat = lib.writeCRC(abi.encodePacked('IDAT',zlib), 0, 25);

        assertEq(crcIdat, bytes4(0xE93261E5));

    }

    function testNewValue() public {

        bytes8 PNG_SIG = 0x89504E470D0A1A0A;

        bytes25 header = bytes25(0x0000000D4948445200000003000000010802000000948283E3);

        bytes10 pixels = bytes10(abi.encodePacked(bytes1(0x00), bytes3(0x00FF00), bytes3(0xFF0000), bytes3(0x0000FF)));
        bytes memory testStringBytes = abi.encodePacked(bytes10(pixels));

        bytes4 adler = checkSums._adler32(Buffer.toBytes1Array(testStringBytes), testStringBytes.length);

        //deflate data to check less adler and colours
        bytes7 deflate = 0x081D010A00F5FF;

        bytes21 zlib = bytes21(abi.encodePacked(deflate, pixels, adler));

        bytes4 crcIdat = lib.writeCRC(abi.encodePacked('IDAT', zlib), 0, 25);

        bytes12 iend = bytes12(0x0000000049454E44AE426082);

        bytes memory fullPNG = abi.encodePacked(PNG_SIG, header, uint32(21), 'IDAT', zlib, crcIdat, iend);

        emit log_bytes(fullPNG);
    }


}
