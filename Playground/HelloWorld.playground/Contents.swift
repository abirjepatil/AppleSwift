//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"



//See how variables and constants are declared

var count = 10
print(count)

//Declare count as an integer variable
var countExplicit:Int = 50
print(countExplicit)


//Loop through an integer array
var arrayInt = [10,12,12,44]

for value in arrayInt
{
    if value < 44
    {
        print(value)
    }
}

//Switch Case in Apple Swift
let option =  "CASES"

switch option{
    case "CASES":
        print("Will enter here");
    case "NOCASEMATCH":
        print("Will Not Enter Here")
default:
    print("Nothing");
}
/*A switch case in swift requires the default clause*/


/*Hands on with Functions*/

//func keyword is used to declare functions
// Arguments to the function as variable name : variable type
// return type after the arguments
func Message(message: String) ->String
{
    return "Hello \(message)"
}


//Lets call the function
Message("Hello")


//Function to find the factorial of a number
func FindFactorial(number:Int) ->Int
{
    var count = number
    var result = 1 ;
    while(count>0)
    {
        result=result*count;
        count=count-1;
    }
    
    return result;
}

//Call the Factorial Functions
FindFactorial(5)


