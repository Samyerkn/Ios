//Easy Tasks
let fruits: [String] = ["banana", "strawberry", "mango", "peach", "cherry"]
print(fruits[2])

var favNums: Set<Int> = [2,5,12,22,7]
favNums.insert(8)
print(favNums)

let releaseYears: [String: Int] = ["Swift": 2014,
                                   "Python": 1991,
                                   "Java": 1995]
print(releaseYears["Swift"] ?? 0)

var colors: [String] = ["red", "black", "white", "burgundy"]
colors[1] = "purple"
print(colors)


//Medium Tasks
let firstSet: Set<Int> = [1,2,3,4]
let secondSet:Set<Int> = [3,4,5,6]
let commonNumbers = firstSet.intersection(secondSet)
print(commonNumbers)


var studentScores: [String: Int] = ["Amina": 80, "Symbat": 90, "Samal": 95]
studentScores["Amina"] = 95
print(studentScores)


let firstFruits = ["apple", "banana"]
let secondFruits = ["cherry", "date"]
print(firstFruits+secondFruits)



//Hard Tasks
var populations: [String: Int] = [
    "Kazakhstan": 20,
    "Japan": 124,
    "Canada": 41
]

populations["Brazil"] = 212
print(populations)



let firstPets: Set<String> = ["cat", "dog"]
let secondPets: Set<String> = ["dog", "mouse"]

let allPets = firstPets.union(secondPets)
let finalPets = allPets.subtracting(secondPets)
print(finalPets)




let gradesByStudent: [String: [Int]] = [
    "Amina": [85, 90, 95],
    "Samal": [88, 92, 96]
]
print(gradesByStudent["Samal"]?[1] ?? 0)
