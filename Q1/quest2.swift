var myApples: Int = 17
var myOranges: Int = 0
print("Enter Cut Apples: ")
var input:String? = readLine()

if let val = input {
    if let cutApples = Int(val), cutApples <= myApples {
        myApples -= cutApples
        print("Oranges: \(myApples/7)")
        print("Apples: \(myApples%7 + cutApples)")
    } else {
        print("Invalid input!!")
    }
}
else {
    print("No input found")
}