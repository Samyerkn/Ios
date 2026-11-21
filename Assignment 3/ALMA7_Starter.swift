// =============================================================
//  Station ALMA-7: Rescue Protocol
//  iOS Mobile Development · Module 3 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER CODE section.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • Use the exact function names from the assignment PDF.
// =============================================================


// MARK: - =================== STARTER CODE ===================
// MARK: - Do not modify anything in this section

typealias Reading = (sensor: String, value: Int)

/// Splits a string at the first occurrence of the separator.
/// splitOnce("O2:87", by: ":") -> ("O2", "87")
/// splitOnce("hello", by: ":") -> nil
func splitOnce(_ line: String, by separator: Character) -> (String, String)? {
    guard let index = line.firstIndex(of: separator) else { return nil }
    let left = String(line[..<index])
    let right = String(line[line.index(after: index)...])
    return (left, right)
}

let rawLog = [
    "O2:87", "TEMP:-12", "O2:9x", "PRESS:101", "TEMP:abc", "O2:",
    "RAD:3", "O2:64", ":55", "TEMP:31", "PRESS:98", "O2:71",
    "RAD:-1", "TEMP:4", "PRESS:1o2", "O2:90"
]

class Tank {
    var level: Int
    init(level: Int) { self.level = level }
}

class Module {
    let name: String
    var oxygenTank: Tank?
    init(name: String, oxygenTank: Tank?) {
        self.name = name
        self.oxygenTank = oxygenTank
    }
}

class CrewMember {
    let name: String
    let role: String
    let priority: Int      // 1 = evacuated first
    var module: Module?    // nil = in open space
    init(name: String, role: String, priority: Int, module: Module?) {
        self.name = name
        self.role = role
        self.priority = priority
        self.module = module
    }
}

let lab  = Module(name: "Lab",  oxygenTank: Tank(level: 40))
let hab  = Module(name: "Hab",  oxygenTank: Tank(level: 12))
let dock = Module(name: "Dock", oxygenTank: nil)

let crew = [
    CrewMember(name: "Timur",   role: "Engineer",  priority: 3, module: lab),
    CrewMember(name: "Dana",    role: "Scientist", priority: 4, module: dock),
    CrewMember(name: "Aigerim", role: "Commander", priority: 1, module: hab),
    CrewMember(name: "Nurlan",  role: "Pilot",     priority: 2, module: nil)
]

var roster: [String: CrewMember] = [:]
for member in crew { roster[member.name] = member }

print("ALMA-7 systems online: \(rawLog.count) log lines, \(crew.count) crew members.")

// MARK: - ================= END OF STARTER CODE =================


// MARK: - =================== YOUR SOLUTION ===================


// MARK: Level 1 · Decoding Telemetry
// 1.1
func parseReading(_ raw: String) -> Reading? {
    guard let parts = splitOnce(raw, by: ":"),
          !parts.0.isEmpty,
          let value = Int(parts.1),
          value >= 0 || parts.0 == "TEMP"
    else {
        return nil
    }

    return (sensor: parts.0, value: value)
}

print("parseReading:")
print(parseReading("O2:87") as Any)
print(parseReading("TEMP:-12") as Any)
print(parseReading("RAD:-1") as Any)
print(parseReading(":55") as Any)


// 1.2
func parseLog(_ lines: [String]) -> (valid: [Reading], invalidCount: Int) {
    var valid: [Reading] = []
    var invalidCount = 0

    for line in lines {
        if let reading = parseReading(line) {
            valid.append(reading)
        } else {
            invalidCount += 1
        }
    }

    return (valid: valid, invalidCount: invalidCount)
}

let parsedLog = parseLog(rawLog)
let validReadings = parsedLog.valid
let A = parsedLog.invalidCount

print("parseLog A (invalid lines):", A)
print("parseLog second test:", parseLog(["O2:10", "bad"]).invalidCount)


// MARK: Level 2 — Analysis

// 2.1
func select(
    _ readings: [Reading],
    where isIncluded: (Reading) -> Bool
) -> [Reading] {
    var selected: [Reading] = []

    for reading in readings {
        if isIncluded(reading) {
            selected.append(reading)
        }
    }

    return selected
}

func values(of readings: [Reading]) -> [Int] {
    var result: [Int] = []

    for reading in readings {
        result.append(reading.value)
    }

    return result
}

let oxygenReadings = select(validReadings) { $0.sensor == "O2" }
let temperatureReadings = select(validReadings) { $0.sensor == "TEMP" }
let oxygenValues = values(of: oxygenReadings)
let temperatureValues = values(of: temperatureReadings)

print("O2 readings:", oxygenReadings)
print("TEMP readings:", temperatureReadings)
print("values tests:", values(of: oxygenReadings), values(of: temperatureReadings))
print("select test:", select(validReadings) { $0.sensor == "RAD" })


// 2.2
func stats(of values: [Int]) -> (min: Int, max: Int, average: Double)? {
    guard let firstValue = values.first else {
        return nil
    }

    var minimum = firstValue
    var maximum = firstValue
    var total = 0

    for value in values {
        if value < minimum {
            minimum = value
        }

        if value > maximum {
            maximum = value
        }

        total += value
    }

    let average = Double(total) / Double(values.count)
    return (min: minimum, max: maximum, average: average)
}

func stats(_ values: Int...) -> (min: Int, max: Int, average: Double)? {
    stats(of: values)
}

print("stats array tests:", stats(of: [2, 4, 6]) as Any, stats(of: []) as Any)
print("stats variadic tests:", stats(3, 8, 1) as Any, stats() as Any)

let oxygenStats = stats(of: oxygenValues)
let B = Int(oxygenStats?.average ?? 0)

print("B (average O2 as Int):", B)


// 2.3 — The Closure Ladder

let descending1 = validReadings.sorted(by: {
    (left: Reading, right: Reading) -> Bool in
    return left.value > right.value
})

let descending2 = validReadings.sorted(by: { left, right in
    return left.value > right.value
})

let descending3 = validReadings.sorted(by: { left, right in
    left.value > right.value
})

let descending4 = validReadings.sorted(by: {
    $0.value > $1.value
})

let descending5 = validReadings.sorted {
    $0.value > $1.value
}

// elementsEqual compares the arrays in order.
// The closure compares both fields of each Reading: sensor and value.
let closureLadderMatches =
    descending1.elementsEqual(descending2, by: {
        $0.sensor == $1.sensor && $0.value == $1.value
    }) &&
    descending1.elementsEqual(descending3, by: {
        $0.sensor == $1.sensor && $0.value == $1.value
    }) &&
    descending1.elementsEqual(descending4, by: {
        $0.sensor == $1.sensor && $0.value == $1.value
    }) &&
    descending1.elementsEqual(descending5, by: {
        $0.sensor == $1.sensor && $0.value == $1.value
    })

print("Closure ladder results match:", closureLadderMatches)
print(descending5)


// MARK: Level 3 — Temperature Stabilization

// 3.1
func heatUp(_ t: Int) -> Int {
    t + 5
}

// 3.1
func coolDown(_ t: Int) -> Int {
    t - 3
}

// 3.1
func hold(_ t: Int) -> Int {
    t
}

// 3.1
func chooseProtocol(for temp: Int) -> (Int) -> Int {
    if temp < 18 {
        return heatUp
    } else if temp > 24 {
        return coolDown
    } else {
        return hold
    }
}

print("heatUp tests:", heatUp(10), heatUp(18))
print("coolDown tests:", coolDown(30), coolDown(24))
print("hold tests:", hold(18), hold(24))

let coldProtocol = chooseProtocol(for: 17)
let safeProtocol = chooseProtocol(for: 20)
print("chooseProtocol tests:", coldProtocol(17), safeProtocol(20))


// 3.2
func runUntilStable(
    from start: Int,
    maxSteps: Int = 10
) -> (finalTemp: Int, steps: Int, isStable: Bool) {
    var temperature = start
    var steps = 0

    while (temperature < 18 || temperature > 24) && steps < maxSteps {
        let protocolToApply = chooseProtocol(for: temperature)
        temperature = protocolToApply(temperature)
        steps += 1
    }

    let isStable = temperature >= 18 && temperature <= 24
    return (finalTemp: temperature, steps: steps, isStable: isStable)
}

print(
    "runUntilStable tests:",
    runUntilStable(from: 31),
    runUntilStable(from: -100, maxSteps: 5)
)

let temperatureStats = stats(of: temperatureValues)
let lowestValidTemperature = temperatureStats?.min ?? 0
let C = runUntilStable(from: lowestValidTemperature).steps

print("C (steps from lowest valid TEMP):", C)


// MARK: Level 4 — The Crew

// 4.1
func oxygenLevel(of member: CrewMember) -> Int? {
    member.module?.oxygenTank?.level
}

print(
    "oxygenLevel tests:",
    oxygenLevel(of: crew[0]) as Any,
    oxygenLevel(of: crew[1]) as Any
)


// 4.2
func status(of member: CrewMember) -> String {
    let location = member.module?.name ?? "open space"

    guard let level = oxygenLevel(of: member) else {
        return "\(member.name): no data (\(location))"
    }

    let condition = level < 20 ? "CRITICAL" : "OK"
    return "\(member.name): \(level)% \(condition)"
}

print("status tests:", status(of: crew[2]), status(of: crew[1]))
print("Crew status:")

for member in crew {
    print(status(of: member))
}


// 4.3
@discardableResult
func transferOxygen(
    from source: inout Int,
    to target: inout Int,
    amount: Int
) -> Int {
    let transferable = max(0, min(amount, min(source, 100 - target)))
    source -= transferable
    target += transferable
    return transferable
}

var transferredFromLabToHab = 0

if let labTank = lab.oxygenTank,
   let habTank = hab.oxygenTank {
    transferredFromLabToHab = transferOxygen(
        from: &labTank.level,
        to: &habTank.level,
        amount: 30
    )
}

print("Oxygen moved from Lab to Hab:", transferredFromLabToHab)

var testSource = 5
var testTarget = 98

let secondTransfer = transferOxygen(
    from: &testSource,
    to: &testTarget,
    amount: 10
)

print(
    "transferOxygen second test:",
    secondTransfer,
    "source:",
    testSource,
    "target:",
    testTarget
)

let D = hab.oxygenTank?.level ?? 0
print("D (Hab oxygen after transfer):", D)


// 4.4
func evacuationOrder(
    _ names: String...,
    roster: [String: CrewMember]
) -> [String] {
    var foundMembers: [CrewMember] = []

    for name in names {
        guard let member = roster[name] else {
            print("Unknown crew member: \(name)")
            continue
        }

        foundMembers.append(member)
    }

    let sortedMembers = foundMembers.sorted {
        $0.priority < $1.priority
    }

    var result: [String] = []

    for member in sortedMembers {
        result.append(member.name)
    }

    return result
}

print("Evacuation order tests:")
print(evacuationOrder("Dana", "Ghost", "Aigerim", "Timur", roster: roster))
print(evacuationOrder("Nurlan", "Timur", roster: roster))


// MARK: Level 5 — The Saboteur's Logbook

/*
Problems in the original reportOxygen:
- member.module can be nil for a crew member in open space, such as Nurlan.
  Force-unwrapping it would crash.
- module.oxygenTank can be nil for a module without a tank, such as Dana's Dock.
  Force-unwrapping it would crash.

Problems in the original firstCritical:
- oxygenLevel can be nil; force-unwrapping it would crash for a member without a reading.
- result can remain nil if nobody is critical; force-unwrapping it would crash.
- The loop overwrites result for every critical member, returning the last one instead
  of the first. This logic bug does not show up with the starter crew because only one
  crew member is critical.
*/

// 5
func reportOxygen(for member: CrewMember) -> String {
    let location = member.module?.name ?? "open space"

    guard let level = oxygenLevel(of: member) else {
        return "\(member.name): no data (\(location))"
    }

    return "\(member.name): \(level)%"
}

// 5
func firstCritical(in crew: [CrewMember]) -> String? {
    for member in crew {
        guard let level = oxygenLevel(of: member) else {
            continue
        }

        if level < 20 {
            return member.name
        }
    }

    return nil
}

print("reportOxygen tests:", reportOxygen(for: crew[0]), reportOxygen(for: crew[1]))
print("firstCritical empty crew:", firstCritical(in: []) as Any)

let firstTestModule = Module(name: "Test One", oxygenTank: Tank(level: 10))
let secondTestModule = Module(name: "Test Two", oxygenTank: Tank(level: 5))

let twoCriticalMembers = [
    CrewMember(name: "First", role: "Test", priority: 1, module: firstTestModule),
    CrewMember(name: "Second", role: "Test", priority: 2, module: secondTestModule)
]

print(
    "firstCritical logic test (should be First):",
    firstCritical(in: twoCriticalMembers) as Any
)


// MARK: Finale — The Launch Code

let launchCode = "\(A)-\(B)-\(C)-\(D)"
print("LAUNCH CODE: \(launchCode)")


// MARK: Bonus

func makeAlarm(threshold: Int) -> (Int) -> Bool {
    var alarmCount = 0

    return { oxygenLevel in
        if oxygenLevel < threshold {
            alarmCount += 1
            print("Alarm #\(alarmCount)")
            return true
        }

        return false
    }
}

let alarm = makeAlarm(threshold: 20)
print("Alarm tests:", alarm(12), alarm(40), alarm(5))

let secondAlarm = makeAlarm(threshold: 10)
print("Second alarm instance:", secondAlarm(5))


// MARK: - ================= DEFENSE QUESTIONS =================
/*
1. How does guard let differ from if let beyond syntax?

   With if let, each unwrapped value is available only inside its own braces.
   With several checks, the code becomes deeply nested:

   func areaWithIfLet(_ widthText: String?, _ heightText: String?) -> Int? {
       if let widthText = widthText {
           if let width = Int(widthText) {
               if let heightText = heightText {
                   if let height = Int(heightText) {
                       return width * height
                   }
               }
           }
       }
       return nil
   }

   With guard let, invalid input exits early and the rest stays at one level:

   func areaWithGuardLet(_ widthText: String?, _ heightText: String?) -> Int? {
       guard let widthText = widthText,
             let width = Int(widthText),
             let heightText = heightText,
             let height = Int(heightText)
       else {
           return nil
       }

       return width * height
   }


2. Why can't you call stats(someArray) when someArray is [Int]?

   stats(_ values: Int...) accepts separate Int arguments at the call site,
   such as stats(3, 8, 1). Swift packs those separate arguments into an [Int]
   inside the function. It does not automatically unpack an existing array
   into separate arguments. For an array, we call stats(of: someArray).


3. Why doesn't transferOxygen(from: &x, to: &x, amount: 5) compile?

   The same variable would be passed to two inout parameters at once.
   Swift prevents overlapping access so the function cannot change the
   same value as both the source and the target.


4. Why doesn't oxygenLevel(of: dana) ?? "no data" compile?

   oxygenLevel returns Int?. The fallback after ?? must be an Int, but
   "no data" is a String. The values have different types.


5. What is the full type of chooseProtocol?

   Its type is (Int) -> ((Int) -> Int). It takes an Int temperature and
   returns a function that takes an Int and returns an Int.


Bonus. Where does the alarm counter live after makeAlarm returns?

   The returned closure captures alarmCount. The captured value stays
   available while the closure is alive, so later calls continue counting.
*/

