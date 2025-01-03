// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract messanger {
    address public owner;
    string public currentMessage = "NO MESSAGE YET";
    uint public messageCount;

    struct Message {
        address sender;
        string text;
        uint timestamp;
    }

    Message[] public messageHistory;
    mapping(address => bool) public allowedSenders;

    event MessageUpdated(address indexed sender, string message, uint timestamp);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event SenderPermissionUpdated(address indexed sender, bool isAllowed);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    modifier onlyAllowedSender() {
        require(msg.sender == owner || allowedSenders[msg.sender], "Not authorized to send messages");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Update the message
    function updateMessage(string memory _msg) public onlyAllowedSender {
        currentMessage = _msg;
        messageCount++;

        // Log message in history
        messageHistory.push(Message({
            sender: msg.sender,
            text: _msg,
            timestamp: block.timestamp
        }));

        emit MessageUpdated(msg.sender, _msg, block.timestamp);
    }

    // Add or remove allowed senders
    function setAllowedSender(address _sender, bool _isAllowed) public onlyOwner {
        allowedSenders[_sender] = _isAllowed;
        emit SenderPermissionUpdated(_sender, _isAllowed);
    }

    // Transfer ownership to a new owner
    function transferOwnership(address _newOwner) public onlyOwner {
        require(_newOwner != address(0), "New owner cannot be the zero address");
        emit OwnershipTransferred(owner, _newOwner);
        owner = _newOwner;
    }

    // Get all messages (read-only function)
    function getMessageHistory() public view returns (Message[] memory) {
        return messageHistory;
    }
}
