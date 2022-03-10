// SPDX-License-Identifier: MIT
pragma solidity  ^0.5.6;

contract Interview {

    // 면접관 
    address private owner;

    // 총 면접 수
    uint256 public numOfInterview = 0;

    // 면접자 정보
    struct User {
        uint256 time;
        bool result;
        string position;
        uint256 sallary;
        uint8 flag;
    }
    
    // 인터뷰 참가자 맵
    mapping (uint32=>User) interviewerMap;

    // 이벤트
    event StartInterview(uint32 userKey);
    event EndInterview(uint32 userKey, bool result);

    // 생성자
    constructor() public {
        owner = msg.sender;
    }

    // 컨트랙트 소유주인지 확인하는 함수
    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not owner!!!");
        _;
    }

    // 면접 시작
    function startInterview(uint32 _userKey) public onlyOwner {
        require(interviewerMap[_userKey].flag == 0, "Interview has already started!");
        User memory user = User({
                time: uint64(now),
                result: false,
                position: '',
                sallary: 0,
                flag: 1
            }
        );
        numOfInterview = numOfInterview + 1;
        interviewerMap[_userKey] = user;

        emit StartInterview(_userKey);
    }

    // 면접 종료
    function endInterview(uint32 _userKey, bool _result, string memory _position) public onlyOwner {
        require(interviewerMap[_userKey].flag == 1, "User key is wrong. Please check it and retry!!");
        interviewerMap[_userKey].result = _result;
        interviewerMap[_userKey].position = _position;

        emit EndInterview(_userKey, _result);
    }

    // 면접 결과 보기
    function getInterviewResult(uint32 _userKey) public view returns(bool, string memory){
        return (interviewerMap[_userKey].result, interviewerMap[_userKey].position);
    }

}