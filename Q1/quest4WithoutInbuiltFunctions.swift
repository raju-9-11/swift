var myString = "asdfggheehbttt testt zq yui"
var myDict: [Character:Int] = [:]
var myArr: [Character] = []
for char in myString {
    if myDict[char] == nil {
        myArr.append(char)
        myDict[char] = 0
    }
}

print(String(myArr))