enum GenderType {
    case male, female
}

class Student {
    var name: String?
    var gender: GenderType?
    var marks: [String: Int] = [:]
    var avg: Int?

    init(name: String, marks: [String: Int], gender: GenderType) {
        self.name = name
        self.marks = marks
        self.gender = gender
        self.avg = getAverage()
    }

    func getAverage() -> Int {
        return marks.values.reduce(0, + ) / marks.count
    }


}

var myClass: [Student] = []
var subj: [String] = ["MATH", "ENG", "PHY", "CHEM", "CS"]

for _ in 1...12 {
    myClass.append(Student(name: "TestF", marks: [subj[0]: 10, subj[1]: 20, subj[2]: 30, subj[3]: 40, subj[4]: 50] , gender: GenderType.female))
}

for _ in 1...13 {
    myClass.append(Student(name: "TestM", marks: [subj[0]: 10, subj[1]: 20, subj[2]: 30, subj[3]: 40, subj[4]: 50] , gender: GenderType.male))

}

let girlStudents: [Student] = myClass.filter{ stud in return stud.gender == GenderType.female }
let boyStudents: [Student] = myClass.filter{ stud in return stud.gender == GenderType.male }

print()

for sub in subj {
    let avgb: Int = boyStudents.map{ stud in stud.marks[sub]!}.reduce(0, +) / boyStudents.count 
    let avgg: Int = girlStudents.map{ stud in stud.marks[sub]!}.reduce(0, +) / girlStudents.count
    print(" In subject \(sub) \(avgb<avgg ? "Girls average is higher": avgg<avgb ? "Boys average is higher": "average is same")")
}
print()

for stud in myClass {
    print("Average of \(stud.name!) is \(stud.avg!)")
}

print()

for sub in subj {
    let totalAverage: Int = myClass.map{ stud in stud.marks[sub]!}.reduce(0, +) / myClass.count
    print("Class average for \(sub) is \(totalAverage) ")
}