import Foundation

func getTriplet(_ num: Int) -> (Int, Int , Int ) {
    if num % 2 != 0 {
        return (num, Int(pow(Double(num),2)/2 - 0.5), Int(pow(Double(num),2)/2 + 0.5))
    }
    else {
        return (num, Int(pow(Double(num/2),2) - 1), Int(pow(Double(num/2),2) + 1))
    }
}

for num in 3...30 {
    print(getTriplet(num))

}
