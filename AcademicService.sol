pragma solidity ^0.4.21;
contract AcademicService {
    
event GradeUpdate(address _from, string _message, address _student);

 //a student not yet available has grade = -1
 struct Course {
 uint8 credits;
 address professor;
 mapping(address => int) grades;
 }
 struct Student {
 address student;
 uint8 registeredCredits;
 uint8 approvedCredits;
 }

 address public school;
 uint256 public start;
 Course[] public courses;
 mapping(address => Student) students;

 event AcquiredDegree(address who);


 // This is the constructor whose code is
 // run only when the contract is created.
 function AcademicService(address[] studentAddresses, uint8[] courseCredits) public {
 school = msg.sender;
 start = now;

 for(uint i=0; i<courseCredits.length; i++) {
 courses.push(Course(courseCredits[i],0));
 }

 for(i=0; i<studentAddresses.length; i++) {
 students[studentAddresses[i]] = Student(studentAddresses[i],0,0);
 }
 }

 function assignProfessor(uint8 courseId, address professor) public {
 if(msg.sender == school && courseId >= 0 &&
 courseId < courses.length &&
 now < (start + 2 days)) {

 courses[courseId].professor = professor;
 }
 }
 function registerNewStudent(address studentAddress) public {
 if(msg.sender == school && now < (start + 1 weeks) &&
 students[studentAddress].student != studentAddress  ){

 students[studentAddress] = Student(studentAddress,0,0);
 }
 }

 function registerOnCourse(uint8 courseId) public payable {
 uint256 cost;
 if(courseId >= 0 && courseId < courses.length &&  now < (start + 2 weeks) && students[msg.sender].student == msg.sender) {
    if(students[msg.sender].registeredCredits + courses[courseId].credits <= 18) {
        cost = 0;
     } else {
       cost = courses[courseId].credits*(0.001 ether);
    } 

    if(cost <= 0 || msg.value >= cost) {
        courses[courseId].grades[msg.sender] = -1;
        students[msg.sender].registeredCredits += courses[courseId].credits;

        school.transfer(cost);
    }
    }
 }

function unregisterFromCourse(uint8 courseId) public payable {
     uint256 cost;
    if(courseId >= 0 && courseId < courses.length &&  now < (start + 4 weeks)) {
        if(students[msg.sender].registeredCredits - courses[courseId].credits >= 18) {
            cost = courses[courseId].credits*(0.001 ether);
        } else {
            cost = 0;
        
    } 

    if(cost <= 0 || msg.value >= cost) {
        courses[courseId].grades[msg.sender] = -2;
        students[msg.sender].registeredCredits -= courses[courseId].credits;

        students[msg.sender].student.transfer(cost);
    }
    }
    }
    
    
function assignGrade(uint8 grade, address studentAddress, uint8 courseId) public{
    
    if(grade >= 0 && grade <= 20 && courses[courseId].professor == msg.sender){
        courses[courseId].grades[studentAddress] = grade;
        emit GradeUpdate(msg.sender, "new grades was assigned to ",studentAddress);
        
        if(grade >= 10){
            students[studentAddress].approvedCredits += courses[courseId].credits;
        }
        if(students[studentAddress].approvedCredits >= 15)
            emit AcquiredDegree(studentAddress);
    }
    

    
}

function specialEvaluation(uint8 courseId) public payable{
    uint256 cost;
    if(courses[courseId].grades[msg.sender] < 10){
        cost = 0.005 ether;
        school.transfer(cost);
        
        
    }
}

function acceptSpecialEvaluation(uint8 courseId, address studentAddress, uint8 newGrade) public payable{
    
    if(courses[courseId].professor == msg.sender){
        courses[courseId].grades[studentAddress] = newGrade;
        school.transfer(0.001 ether);
        
        if(newGrade >= 10){
            students[studentAddress].approvedCredits += courses[courseId].credits;
        }
        if(students[studentAddress].approvedCredits >= 15)
            emit AcquiredDegree(studentAddress);
    }
}


}
