func palindrome(_ num: Int) -> Bool {
    var lst: [Int] = []
    var num = num
    while num > 0 {
        lst.append(num%10)
        num /= 10
    }

    return lst == Array(lst.reversed())
}


func numOfDigits(_ num: Int) -> (numCount: Int, word: String) {
    let words: [String] = ["Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine"]
    var myWord: String = ""
    var length = 0 
    for char in String(num) {
        if let charToNum = char.wholeNumberValue {
            myWord += words[charToNum ]
        }
    }
    var num = num
    while num > 0 {
        length += 1
        num /= 10
    }
    return (length, myWord)
}

func palindromesInRange(from: Int, to: Int) -> [Int] {
    return Array(from...to).filter{ palindrome($0) }
}


var myArr = palindromesInRange(from: 100,to: 8000)
for num in myArr {
    print(numOfDigits(num))
}
