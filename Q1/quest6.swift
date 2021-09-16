func add(_ num1: Int, _ num2: Int) -> Void {
    print("Sum is \(num1 + num2)")
}

func sub(_ num1: Int, _ num2: Int) -> Void {
    print("Difference is \(num1 - num2)")
}

func mul(_ num1: Int, _ num2: Int) -> Void {
    print("Product is \(num1*num2)")
}

func div(_ num1: Int, _ num2: Int) -> Void {
    print("Quotient is \(num1/num2)")
}

func mod(_ num1: Int, _ num2: Int) -> Void {
    print("Remainder if \(num1%num2)")
}

func calculate (_ num1: Int, _ num2: Int, funct: (Int, Int)->(Void)) -> Void {
    funct(num1,num2)
}

calculate(5,4,funct: add)

calculate(5,4,funct: sub)

calculate(5,4,funct: div) 

calculate(5,4,funct: mod)