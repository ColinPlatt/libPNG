// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import 'solidity-bytes-utils/BytesLib.sol';

contract PNGData {

    bytes8 constant PNG_SIG = 0x89504E470D0A1A0A;
    bytes4 constant IHDR = 0x49484452;
    bytes4 constant IDAT = 0x49444154;
    bytes4 constant PLTE = 0x504C5445;
    bytes4 constant tRNS = 0x74524E53;
    bytes4 constant IEND = 0x49454E44;

    bytes4 constant initialCRC = 0xffffffff;

    struct PIXEL {
        bytes1 Red;
        bytes1 Green;
        bytes1 Blue;
        bytes1 Alpha;
    }

    struct IMAGE {
        uint8 width;
        uint8 height;
        PIXEL[] pixels;
    }

    function getIHDRChunk(uint32 width, uint32 height) public pure returns (bytes memory) {
        // returns data in the following: IHDRlength, IHDR, width, height, bitDepth(8), colourType(6: True RGB with alpha), compressionMethod(0), filterMethod(0), interlaceMethod(0)
        bytes memory chunkNoCRC = abi.encodePacked(
                IHDR,
                width,
                height,
                uint8(8),
                uint8(3),
                uint8(0),
                uint8(0),
                uint8(0)
            );
        
        return abi.encodePacked(
                uint32(13),
                chunkNoCRC,
                writeCRC(chunkNoCRC, 0, 17)
        );
    }

    function bytesToByteArray(bytes memory _chunk, uint256 _offset, uint256 _length) public pure returns (bytes1[] memory) {
        bytes1[] memory byteArray = new bytes1[](_length);

        require(_length+_offset >= byteArray.length, 'length insufficient.');

        for (uint256 i = 0; i<byteArray.length; i++) {
            if (i >= (_length - _offset)) {
                byteArray[i] = bytes1(0);
            } else {
                byteArray[i] = bytes1(BytesLib.slice(_chunk,i+_offset,1));
            }
        }

        return byteArray;
    }

    function calcCrcTable() public pure returns (uint256[256] memory crcTable) {
        uint256 c;

        for(uint256 n = 0; n < 256; n++) {
            c = n;
            for (uint256 k = 0; k < 8; k++) {
                if(c & 1 == 1) {
                    c = 0xedb88320 ^ (c >>1);
                } else {
                    c = c >> 1;
                }
            }
            crcTable[n] = c;
        }
    }

    function writeCRC(bytes memory chunk, uint256 offset, uint256 len) public pure returns (bytes4) {

        uint256[256] memory crcTable = calcCrcTable();

        bytes1[] memory data = bytesToByteArray(chunk, offset, len);

        uint32 c = uint32(initialCRC);

        for(uint256 n = 0; n < len; n++) {
            c = uint32(crcTable[(c^uint8(data[n])) & 0xff] ^ (c >> 8));
        }
        return bytes4(c)^initialCRC;

    }

    function layOutData() public pure returns (bytes memory) {
        bytes memory output = abi.encodePacked(PNG_SIG);

        bytes memory idhr = getIHDRChunk(uint32(1),uint32(1));

        bytes memory idat = getIDATChunk(0x01, 0x02, 0x03, 0x04);
        

        return output = bytes.concat(output, idhr, idat);

    }

    function getIDATChunk(bytes1 _red, bytes1 _green, bytes1 _blue, bytes1 _alpha) public pure returns (bytes memory) {
        // returns data in the following: IDATlength, IDAT
        bytes memory chunkNoCRC = abi.encodePacked(
                IDAT,
                bytes2(0x78da)
            );
        
        return abi.encodePacked(
                uint32(13),
                chunkNoCRC
                //writeCRC(chunkNoCRC, 0, 17)
        );
    }




    function adler32(uint32 _adler, bytes1[] memory _buf, uint256 _len, uint256 _pos) public pure returns (bytes4) {
        uint32 s1 = (_adler & 0xffff);
        uint32 s2 = ((_adler >> 16) & 0xffff);
        uint256 n = 0;

        while (_len != 0) {
            // s2 (or all) need to be int32?
            n = _len > 2000 ? 2000 : _len;
            _len -= n;

            do {
                 s1 = (s1 + uint8(_buf[_pos++]));
                 s2 = (s2 + s1);
            } while (--n != 0);

            s1 %= 65521;
            s2 %= 65521;

        }

        return bytes4(s1 | (s2 << 16));

    }

    function _adler32(bytes1[] memory _data, uint256 _len) public pure returns (bytes4) {
        uint32 a = 1;
        uint32 b = 0;

        for (uint256 i = 0; i < _len; i++) {
            a = (a + uint8(_data[i])) % 65521; //may need to convert to uint32
            b = (b + a) % 65521;
        }

        return bytes4((b << 16) | a);

    }

}
