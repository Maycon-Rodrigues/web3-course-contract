// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct Course {
    uint256 courseId;
    string name;
    string description;
    uint256 price;
    bool isActive;
}

contract Web3Course {
    uint256 public id = 0;
    address public owner;
    mapping(uint256 => Course) public courses;
    mapping(address => uint256[]) myCourses;
    
    constructor() {
        owner = msg.sender;
    }

    function createCourse(string memory _name, string memory _description, uint256 _price) public {
        require(owner == msg.sender, "Just the contract owner can be create a course");
        
        bytes memory name = bytes(_name);
        bytes memory description = bytes(_description);
        
        if(name.length > 0 && description.length > 5) {
            id++;

            Course memory newCourse = Course({
                courseId: id,
                name: _name,
                description: _description,
                price: _price,
                isActive: true
            });

            courses[id] = newCourse;
        }else {
            revert("Course parameters can't be empty or zero");
        }

    }

    function getActiveCourses(uint256 _startId, uint256 _qtd) public view returns (Course[] memory) {
        Course[] memory _courses = new Course[](_qtd);
        uint256 _id = _startId;
        uint256 count = 0;

        do {
            if(courses[_id].isActive){
                _courses[count] = courses[_id];
                count++;
            }

            _id++;
        }
        while(count < _qtd && _id <= id);

        return _courses;
    }

    function buyCourse(uint256 _id) public payable  {
        require(msg.sender != owner, "Owner can't by course");
        require(courses[_id].isActive, "Course is not active");
        require(msg.value == courses[_id].price, "Price need to be igual");

        myCourses[msg.sender].push(_id);

        payable(owner).transfer(msg.value);
    }

    function getMyCourses(address _buyer) public view returns (uint256[] memory) {
        return myCourses[_buyer];
    }
}
