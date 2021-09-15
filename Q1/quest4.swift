var myString = "asdfghebt zq yui"
var myCharArr: [Character] = []
for char in myString {
    if !myCharArr.contains(char) {
        myCharArr.append(char)
    }
}

print(String(myCharArr))