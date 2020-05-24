pragma solidity ^0.4.21;
contract AcademicService {

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
 if(msg.sender == school && courseId > 0 &&
 courseId < courses.length &&
 courses[courseId].professor != 0 &&
 now < (start + 1 weeks)) {

 courses[courseId].professor = professor;
 }
 }
 function registerNewStudent(address studentAddress) public {
 if(msg.sender == school && now < (start + 4 weeks) &&
 students[studentAddress] == ) {

 students[studentAddress] = Student(studentAddress,0,0);
 }
 }

 function registerOnCourse(uint8 courseId) public payable {
 uint256 cost;
 if(courseId > 0 && courseId < courses.length) {
 if(students[msg.sender].registeredCredits >= 60) {
 cost = courses[courseId].credits*(0.1 ether);
 } else {
 cost = (courses[courseId].credits -
 (60-students[msg.sender].registeredCredits))*
 (0.1 ether);
 }

 if(cost <= 0 || msg.value >= cost) {
 courses[courseId].grades[msg.sender] = -1;
 students[msg.sender].registeredCredits +=
 courses[courseId].credits;

 school.transfer(cost);
 }
 }
 }

}