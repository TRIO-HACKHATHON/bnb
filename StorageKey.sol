// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

contract SecretKeyStorage {
    mapping(address => mapping(string => address)) private secretKeys;
    mapping(address => address[]) private accessableAccounts;
    mapping(address => string[]) private allSecretKeys;
    mapping(address => address[]) private allSecretKeyValue;
    mapping(address => uint256) private startTime;

        
    function storeSecretKey(string memory key, address value) public {
        startTime[msg.sender] = block.timestamp;
        secretKeys[msg.sender][key] = value;
        allSecretKeys[msg.sender].push(key);
        allSecretKeyValue[msg.sender].push(value);
    }

    function getSecretKey(string memory key) public view returns (address) {
        return secretKeys[msg.sender][key];
    }

    function deleteSecretKey(string memory key) public {
        startTime[msg.sender] = block.timestamp;
        delete secretKeys[msg.sender][key];
        deleteStringFromArray(allSecretKeys[msg.sender], key);
        deleteAddressFromArray(allSecretKeyValue[msg.sender],msg.sender);
    }

    // function deleteAll(uint256 year) public {
    //     uint256 secondsInYear = year * 365 days;
    //     require(block.timestamp >= startTime[msg.sender] + 1, "The Function not available");
    //     startTime[msg.sender] = block.timestamp;
    //     string[] storage keys = allSecretKeys[msg.sender];
    //     for (uint256 i = 0; i < keys.length; i++) {
    //         delete secretKeys[msg.sender][keys[i]];
    //     }        
    //     delete allSecretKeys[msg.sender];
    //     delete allSecretKeyValue[msg.sender];
    // }

    function setAccessableAccounts(address account/*, uint256 year*/) public {
        // uint256 secondsInYear = year * 365 days;
        // require(block.timestamp >= startTime[msg.sender] + 1, "The Function not available");
        accessableAccounts[msg.sender].push(account);
        for(uint8 i = 0; i < allSecretKeys[msg.sender].length; i++){
            secretKeys[account][allSecretKeys[msg.sender][i]] = allSecretKeyValue[msg.sender][i];
            allSecretKeys[account].push(allSecretKeys[msg.sender][i]);
            allSecretKeyValue[account].push(allSecretKeyValue[msg.sender][i]);
        }
    }


    function getSecretKeys() public view returns (string[] memory) {
        return (allSecretKeys[msg.sender]);
    }

    function getAccessableAccounts() public view returns (address[] memory) {
        return (accessableAccounts[msg.sender]);
    }

    function deleteStringFromArray(string[] storage array, string memory key) private {
        for (uint256 i = 0; i < array.length; i++) {
            if (keccak256(bytes(array[i])) == keccak256(bytes(key))) {
                if (i != array.length - 1) {
                    array[i] = array[array.length - 1];
                }
                array.pop();
                break;
            }
        }
    }

    function deleteAddressFromArray(address[] storage array, address value) private {
        for (uint256 i = 0; i < array.length; i++) {
            if (array[i] == value) {
                if (i != array.length - 1) {
                    array[i] = array[array.length - 1];
                }
                array.pop();
                break;
            }
        }
    }
}
