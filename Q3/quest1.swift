// Declare variables and constants of type String and Array of Strings using automatic type inference
let myString = "Hello world!!"
let myStringArrray = ["Hello", "World", "!!"]


// Declare the above with type annotation
let myAnnnonatedString: String = "Hello World!!"
let myAnnnonatedStringArray: [String] = ["Hello", "World", "!!"]

// Define a tuple and print its value
let myTuple: (one: Int, two: Int,  three: Int) = (1, 2, 3)
print(myTuple)

// Declare and use a function which returns a tuple.. Print the value of returned tuple
print()
func myfunct (_ val: Int) -> (Int,Int) {
    if val > 10 {
        return (val%10, val/10%10)
    }
    return (0, val%10)

}
let myVal = myfunct(11)
print(myVal)

// Write a switch statement to match values of the tuple
print()
switch myVal {
    case (1,1): 
        print("Num is 11")
    case (1,2): 
        print("Num is 12")
    default : 
        print(true)
}

// Declare an optional String. And print its value.
print()
let myOptionalString: String? = "Hello"
print("Optional string is \(myOptionalString ?? "String not available")")


// Write a for loop for running 10 iterations
print()
for i in 1...10 {
    print(i, terminator: " ")
}

// Iterate an array of Strings
print("\n")
for aString in myStringArrray {
    print(aString, terminator: " ")
}

// Iterate an array elements and also print index of each element
print("\n")
let myIntArray: [Int] = [Int](repeating: 10, count: 10)
for num in myIntArray {
    print(num, terminator: " ")
}

// Create a dictionary of elements and iterate it
print("\n")
let myDict: [Int: String] = [1: "One", 2: "Two", 3: "Three"]

for (key, val) in myDict {
    print(key, ":", val)
}

// Create a Set of strings and do operations like difference, union etc in Set

let setOfString: Set<String> = ["Test val 🎅","Test val 🏇","Test val 1"]
let anotherSetOfString: Set<String> = ["Test val 🎅","Test val 3","Test val 4"]
print(setOfString.union(anotherSetOfString))
print(setOfString.subtracting(anotherSetOfString))
print(setOfString.intersection(anotherSetOfString))
print(setOfString.symmetricDifference(anotherSetOfString))

// Create a class representing Contact. Create two Sets of Contacts. Find the Union and Difference of the 2 sets. [Contact should be Hashable. Contact contains person name, street name, area name, city name, mobile number, employee id.]

class Contact: Hashable {
    var name: String?
    var streetName: String?
    var areaName: String?
    var cityName: String?
    var mobileNumber: String?
    var employeeID: Int?
    static var employees: Int = 0

    init(name: String, streetName: String, areaName: String, cityName: String, mobileNumber: String) {
        self.name = name 
        self.streetName = streetName
        self.cityName = cityName
        self.mobileNumber = mobileNumber 
        self.employeeID = Contact.employees 
        Contact.employees += 1
    }

    static func ==(x: Contact, y: Contact) -> Bool {
        return x.name == y.name && x.employeeID == y.employeeID
    }

    func hash(into hasher: inout Hasher) {
        return hasher.combine(ObjectIdentifier(self))
    }


}

let myContacts: Set<Contact> = [
                            Contact(name: "John doe", streetName: "testStreet", areaName: "testArea", cityName: "testCity", mobileNumber: "012345678"), 
                            Contact(name: "John doe", streetName: "testStreet", areaName: "testArea", cityName: "testCity", mobileNumber: "012345678"),
                            Contact(name: "Wade", streetName: "testStreet", areaName: "testArea", cityName: "testCity", mobileNumber: "012345678"),
                            Contact(name: "Jane doe", streetName: "testStreet", areaName: "testArea", cityName: "testCity", mobileNumber: "012345678") 
                            ]

let myOtherContacts: Set<Contact> = [
                            Contact(name: "John doe", streetName: "testStreet", areaName: "testArea", cityName: "testCity", mobileNumber: "012345678"), 
                            Contact(name: "Logan", streetName: "testStreet", areaName: "testArea", cityName: "testCity", mobileNumber: "012345678"),
                            Contact(name: "Jane", streetName: "testStreet", areaName: "testArea", cityName: "testCity", mobileNumber: "012345678"),
                            Contact(name: "Jane doe", streetName: "testStreet", areaName: "testArea", cityName: "testCity", mobileNumber: "012345678") 
                            ]
print("Union of contacts: ")
for contact in myContacts.union(myOtherContacts) {
    print(contact.name ?? " Unknown ", contact.employeeID ?? " Employee Id unknown")
}

// Sort the array of Contacts in ascending order of employee ids
print()
var contactArray: [Contact] = Array(myContacts) + Array(myOtherContacts)
print("Contact Array after sorting: ")

contactArray = contactArray.sorted( by: {  return $0.employeeID! < $1.employeeID!})

for contact in contactArray {
    print(contact.name ?? " Unknown ", contact.employeeID ?? " Employee Id unknown")
}

// Create a Dictionary with Int keys and String values. And iterate its keys and values
print()
for key in myDict.keys {
    print(key)
}

for val in myDict.values {
    print(val)
}

// Create a function taking two arguments
print()
func myArgfunct (_ a : inout Int, _ b: inout Int) {
    let tmp = a; a = b; b = tmp
}  

var a = 10, b = 12
print("A: \(a) B: \(b)")
myArgfunct(&a,&b)
print("A: \(a) B: \(b)")

// Create a function with inout parameters. Pass two integer numbers as the parameters. Store the sum and difference of the numbers in them in the function
print()
func sumAndDiff(_ a: inout Int, _ b: inout Int) {
    let tmp = a - b; a = a + b; b = tmp
}
print("A: \(a) B: \(b)")
sumAndDiff(&a,&b)
print("A: \(a) B: \(b)")

// Create a function that takes 2 closures as arguments. The function must have a trailing closure
print()

var getSquare = {(num: Int) -> Int in return num * num}

func getTuple(_ f1: @escaping (Int)->(Int),_ f2: @escaping (Int)->(Bool)) -> (Int) -> ( square: Int, even: Bool) {
    func closureFunction (val: Int) -> (Int, Bool) {
        return (f1(val), f2(val))
    }
    return closureFunction
}

let calc = getTuple(getSquare) {
    (num: Int) -> Bool in 
        return num % 2 == 0
}

print(calc(10))

// Create a mutating function, which modifies the 3 sides of a triangle by adding 1,2,3 to each side. If the triangle sides no longer form a side (sum of 2 sides of a triangle should be greater than 3rd side), don't add any value.
print()
var x = 2, y = 3, z = 4

var checkTriangle = { (side1: Int, side2: Int, side3: Int) -> Bool in return side1+side2>side3 && side2+side3>side1 && side1+side3>side2}

func addVal(_ x: inout Int, _ y: inout Int, _ z: inout Int) -> Bool {
    if checkTriangle(x + 1, y + 2, z + 3) {
        x += 1
        y += 2
        z += 3
        return true
    }
    return false
}


while addVal(&x, &y, &z) {
    print("Adding ",x,y,z,checkTriangle(x,y,z))
}

print(x, y, z)