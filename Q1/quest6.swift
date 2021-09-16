func add(_ num1: Int, _ num2: Int) -> Int {
    return num1 + num2
}

func sub(_ num1: Int, _ num2: Int) -> Int {
    return num1 - num2
}

func mul(_ num1: Int, _ num2: Int) -> Int {
    return num1*num2
}

func div(_ num1: Int, _ num2: Int) -> Int {
    return num1/num2
}

func mod(_ num1: Int, _ num2: Int) -> Int {
    return num1%num2
}

func calculate (_ num1: Int, _ num2: Int, funct: (Int, Int)->(Int)) -> Int {
    return funct(num1,num2)
}

print("Sum is \(calculate(5,4,funct: add))")

print("Difference is \(calculate(5,4,funct: sub))")

print("Product is \(calculate(5,4,funct: mul))")

print("Remainder is \(calculate(5,4,funct: mod))")

print("Quotient is \(calculate(5,4,funct: div))")