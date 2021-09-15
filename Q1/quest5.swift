func palindrome(_ num: Int) -> Bool {
    return String(num) == String(String(num).reversed())
}

func numOfDigits(_ num: String) -> (numCount: Int, word: String) {
    let words: [String] = ["Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"]
    var myWord: String = ""
    let length = num.count 
    for char in num {
        if let charToNum = char.wholeNumberValue {
            myWord += words[charToNum ]
        }
    }
    return (length, myWord)
}

func palindromesInRange(from: Int, to: Int) -> [Int] {
    return Array(from...to).filter{ palindrome($0) }
}
let test = "test"


var myArr = palindromesInRange(from: 100,to: 8000)
for num in myArr {
    print(numOfDigits(String(num)))
}