// =============================================================
//  Station ALMA-7, Part II: The Teleporter Incident
//  iOS Mobile Development · Module 4 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Part2_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER DATA section.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • Default to struct. Use class only where the task says so.
// =============================================================


// MARK: - =================== STARTER DATA ===================
// MARK: - Do not modify anything in this section

/// Splits a line into fields.
/// fields("crate:101:120")            -> ["crate", "101", "120"]
/// fields("livestock:lab mice:12:2")  -> ["livestock", "lab mice", "12", "2"]
/// fields("junk")                     -> ["junk"]
func fields(_ line: String, separatedBy separator: Character = ":") -> [String] {
    var result: [String] = []
    var current = ""
    for character in line {
        if character == separator {
            result.append(current)
            current = ""
        } else {
            current.append(character)
        }
    }
    result.append(current)
    return result
}

/// Cargo manifest as recovered from the damaged recorder.
let rawManifest = [
    "crate:101:120",
    "container:KZ-ALM-7:340",
    "livestock:lab mice:12:2",
    "???-corrupted-line",
    "crate:102:75",
    "container:KZ-ALM-9:410",
    "livestock:ficus:3:5",
    "crate:103:260",
    "crate:104:abc",
    ""
]

/// Oxygen readings. One of these deck names is not a real deck.
let deckReadings: [(deck: String, oxygen: Int)] = [
    (deck: "bridge",     oxygen: 78),
    (deck: "lab",        oxygen: 64),
    (deck: "greenhouse", oxygen: 55),
    (deck: "cargo",      oxygen: 12),
    (deck: "medbay",     oxygen: 90),
    (deck: "engine",     oxygen: 41)
]

/// Crew records, straight from the personnel file.
let crewData: [(name: String, deck: String, oxygen: Int)] = [
    (name: "Timur",   deck: "engine", oxygen: 62),
    (name: "Dana",    deck: "lab",    oxygen: 48),
    (name: "Aigerim", deck: "bridge", oxygen: 91),
    (name: "Nurlan",  deck: "cargo",  oxygen: 17)
]

print("ALMA-7 recorder online: \(rawManifest.count) manifest lines, \(deckReadings.count) readings, \(crewData.count) crew records.")

// MARK: - ================= END OF STARTER DATA =================


// MARK: - =================== YOUR SOLUTION ===================
// Uncomment each declaration when you start working on it.


// MARK: Level 1 · The Deck Register

// 1.1
enum Deck: String, CaseIterable {
    case bridge
    case lab
    case cargo
    case medbay
    case engine

    var evacuationPriority: Int {
        switch self {
        case .bridge:
            return 1
        case .medbay:
            return 2
        case .lab:
            return 3
        case .engine:
            return 4
        case .cargo:
            return 5
        }
    }
}

for deck in Deck.allCases {
    print("\(deck.rawValue): priority \(deck.evacuationPriority)")
}
// 1.2
// enum AlarmLevel: Int { }
enum AlarmLevel: Int {
    case green = 0
    case yellow
    case orange
    case red

    static func level(forTotalMass mass: Int) -> AlarmLevel {
        let step = max(0, min(mass / 500, AlarmLevel.red.rawValue))
        return AlarmLevel(rawValue: step) ?? .green
    }
}

let alarmExamples: [(mass: Int, level: AlarmLevel)] = [
    (0, AlarmLevel.level(forTotalMass: 0)),
    (940, AlarmLevel.level(forTotalMass: 940)),
    (4000, AlarmLevel.level(forTotalMass: 4000))
]

for example in alarmExamples {
    print("Alarm at \(example.mass) kg: \(example.level) (\(example.level.rawValue))")
}


// MARK: Level 2 · The Manifest

// 2.1
enum ManifestEntry {
    case crate(id: Int, massKg: Int)
    case container(code: String, massKg: Int)
    case livestock(species: String, count: Int, massPerUnitKg: Int)
    case unknown(raw: String)
}


// 2.2
func parseEntry(_ line: String) -> ManifestEntry {
    let parts = fields(line)

    guard let tag = parts.first else {
        return .unknown(raw: line)
    }

    switch tag {
    case "crate":
        guard parts.count == 3,
              let id = Int(parts[1]),
              let massKg = Int(parts[2]) else {
            return .unknown(raw: line)
        }

        return .crate(id: id, massKg: massKg)

    case "container":
        guard parts.count == 3,
              let massKg = Int(parts[2]) else {
            return .unknown(raw: line)
        }

        return .container(code: parts[1], massKg: massKg)

    case "livestock":
        guard parts.count == 4,
              let count = Int(parts[2]),
              let massPerUnitKg = Int(parts[3]) else {
            return .unknown(raw: line)
        }

        return .livestock(
            species: parts[1],
            count: count,
            massPerUnitKg: massPerUnitKg
        )

    default:
        return .unknown(raw: line)
    }
}

print("Parsed crate:", parseEntry("crate:101:120"))
print("Parsed invalid line:", parseEntry("crate:104:abc"))


// 2.3
func mass(of entry: ManifestEntry) -> Int {
    switch entry {
    case .crate(_, let massKg):
        return massKg
    case .container(_, let massKg):
        return massKg
    case .livestock(_, let count, let massPerUnitKg):
        return count * massPerUnitKg
    case .unknown(raw: _):
        return 0
    }
}

print("Mass of crate:", mass(of: .crate(id: 1, massKg: 120)))
print(
    "Mass of livestock:",
    mass(of: .livestock(species: "mice", count: 12, massPerUnitKg: 2))
)

var manifestEntries: [ManifestEntry] = []
var unknownLineCount = 0
var totalManifestMass = 0

for line in rawManifest {
    let entry = parseEntry(line)
    manifestEntries.append(entry)
    totalManifestMass += mass(of: entry)

    if case .unknown(raw: _) = entry {
        unknownLineCount += 1
    }
}

let A = totalManifestMass

print("Unknown manifest lines:", unknownLineCount)
print("Total manifest mass:", A)


// MARK: Level 3 · Crew Snapshots

// 3.1
struct CrewSnapshot {
    let name: String
    var deck: Deck
    var oxygen: Int

    mutating func breathe(_ amount: Int) {
        oxygen = max(0, oxygen - max(0, amount))
    }

    mutating func move(to deck: Deck) {
        self.deck = deck
    }

    mutating func reviveInMedbay() {
        self = CrewSnapshot(name: name, deck: .medbay, oxygen: 100)
    }

    static func rookie(named name: String) -> CrewSnapshot {
        CrewSnapshot(name: name, deck: .bridge, oxygen: 100)
    }
}

let rookieOne = CrewSnapshot.rookie(named: "New Crew Member")
let rookieTwo = CrewSnapshot.rookie(named: "Another Crew Member")

print("Rookie one:", rookieOne.name, rookieOne.deck.rawValue, rookieOne.oxygen)
print("Rookie two:", rookieTwo.name, rookieTwo.deck.rawValue, rookieTwo.oxygen)


// 3.2
var crewRoster: [CrewSnapshot] = []

for record in crewData {
    guard let deck = Deck(rawValue: record.deck) else {
        print("Skipping \(record.name): unknown deck \(record.deck)")
        continue
    }

    let snapshot = CrewSnapshot(
        name: record.name,
        deck: deck,
        oxygen: record.oxygen
    )
    crewRoster.append(snapshot)
}

print("Crew roster:", crewRoster.count, "members")

for member in crewRoster {
    print("\(member.name): \(member.deck.rawValue), oxygen \(member.oxygen)")
}


// 3.3 · Prove value semantics

func changedCopy(of snapshot: CrewSnapshot) -> CrewSnapshot {
    var localCopy = snapshot
    localCopy.breathe(10)
    return localCopy
}

func breatheUsingInout(_ snapshot: inout CrewSnapshot) {
    snapshot.breathe(10)
}

var originalSnapshot = CrewSnapshot.rookie(named: "Copy Test")
var copiedSnapshot = originalSnapshot

print("Copy test before — original:", originalSnapshot.oxygen)
print("Copy test before — copy:", copiedSnapshot.oxygen)

copiedSnapshot.breathe(15)

print("Copy test after — original:", originalSnapshot.oxygen)
print("Copy test after — copy:", copiedSnapshot.oxygen)

print("Plain function before — original:", originalSnapshot.oxygen)
let returnedCopy = changedCopy(of: originalSnapshot)
print("Plain function result:", returnedCopy.oxygen)
print("Plain function after — original:", originalSnapshot.oxygen)

print("inout before:", originalSnapshot.oxygen)
breatheUsingInout(&originalSnapshot)
print("inout after:", originalSnapshot.oxygen)


// MARK: Level 4 · The Teleport Pod

// 4.1
final class TeleportPod {
    let id: String
    var chargeLevel: Int
    var occupant: CrewSnapshot?

    // A struct gets a memberwise initializer automatically.
    // A class does not, so this initializer sets every stored property.
    init(id: String, chargeLevel: Int) {
        self.id = id
        self.chargeLevel = chargeLevel
        self.occupant = nil
    }

    func load(_ crew: CrewSnapshot) -> Bool {
        guard occupant == nil, chargeLevel >= 20 else {
            return false
        }

        occupant = crew
        return true
    }

    func fire() -> CrewSnapshot? {
        guard let passenger = occupant else {
            return nil
        }

        chargeLevel -= 20
        occupant = nil
        return passenger
    }

    deinit {
        print("TeleportPod \(id) deinitialized")
    }
}

let examplePod = TeleportPod(id: "Example", chargeLevel: 60)
let secondExamplePod = TeleportPod(id: "Example-2", chargeLevel: 40)

print("Example pod:", examplePod.id, examplePod.chargeLevel)
print("Second example pod:", secondExamplePod.id, secondExamplePod.chargeLevel)


// 4.2 · Charge ledger

let pod = TeleportPod(id: "P-1", chargeLevel: 100)

if let timur = crewRoster.first(where: { $0.name == "Timur" }) {
    print("Load Timur:", pod.load(timur))
    print("Charge after loading Timur:", pod.chargeLevel)
}

print("Fire Timur:", pod.fire()?.name as Any)
print("Charge after firing Timur:", pod.chargeLevel)

if let dana = crewRoster.first(where: { $0.name == "Dana" }) {
    print("Load Dana:", pod.load(dana))
    print("Charge after loading Dana:", pod.chargeLevel)
}

print("Fire Dana:", pod.fire()?.name as Any)
print("Charge after firing Dana:", pod.chargeLevel)

if let nurlan = crewRoster.first(where: { $0.name == "Nurlan" }) {
    print("Load Nurlan:", pod.load(nurlan))
    print("Charge after loading Nurlan:", pod.chargeLevel)
}

print("Fire Nurlan:", pod.fire()?.name as Any)
print("Charge after firing Nurlan:", pod.chargeLevel)

print("Fire with empty pod:", pod.fire() as Any)
print("Charge after empty fire:", pod.chargeLevel)

let C = pod.chargeLevel


// 4.3 · Prove reference semantics

let referencePodA = TeleportPod(id: "Reference Test", chargeLevel: 80)
let referencePodB = referencePodA

referencePodB.chargeLevel = 35

print("Charge through first reference:", referencePodA.chargeLevel)
print("Charge through second reference:", referencePodB.chargeLevel)

var snapshotA = CrewSnapshot.rookie(named: "Value Test")
var snapshotB = snapshotA

snapshotB.breathe(20)

print("Original snapshot oxygen:", snapshotA.oxygen)
print("Copied snapshot oxygen:", snapshotB.oxygen)

// Classes share a reference to one object; structs are copied as separate values.


// MARK: Level 5 · Station Systems

// 5.1
final class Station {
    let callSign: String

    var hullIntegrity: Int {
        willSet {
            print("Hull will change from \(hullIntegrity) to \(newValue)")
        }
        didSet {
            let clampedValue = min(100, max(0, hullIntegrity))
            if hullIntegrity != clampedValue {
                hullIntegrity = clampedValue
            }
        }
    }

    var oxygenByDeck: [Deck: Int]

    lazy var fullDiagnostics: String = {
        print("Running full scan...")
        return "\(callSign): \(totalOxygen) oxygen total, hull \(hullIntegrity)%"
    }()

    var totalOxygen: Int {
        var total = 0

        for oxygen in oxygenByDeck.values {
            total += oxygen
        }

        return total
    }

    var averageOxygen: Int {
        get {
            guard !oxygenByDeck.isEmpty else {
                return 0
            }

            return totalOxygen / oxygenByDeck.count
        }
        set {
            let existingDecks = Array(oxygenByDeck.keys)

            for deck in existingDecks {
                oxygenByDeck[deck] = newValue
            }
        }
    }

    init(
        callSign: String,
        hullIntegrity: Int,
        readings: [(deck: String, oxygen: Int)]
    ) {
        self.callSign = callSign
        self.hullIntegrity = hullIntegrity

        var readingsByDeck: [Deck: Int] = [:]

        for reading in readings {
            guard let deck = Deck(rawValue: reading.deck) else {
                print("Skipping oxygen reading for unknown deck: \(reading.deck)")
                continue
            }

            readingsByDeck[deck] = reading.oxygen
        }

        self.oxygenByDeck = readingsByDeck
    }
}

let station = Station(
    callSign: "ALMA-7",
    hullIntegrity: 100,
    readings: deckReadings
)

let B = station.averageOxygen

print("Station:", station.callSign)
print("Total oxygen:", station.totalOxygen)
print("Starting average oxygen:", B)
print("Oxygen by deck:", station.oxygenByDeck)

// The backup station's lazy diagnostics are never accessed.
let untouchedStation = Station(
    callSign: "ALMA-7-Backup",
    hullIntegrity: 90,
    readings: deckReadings
)
print("Backup station created; diagnostics were not accessed.")

// The scan message appears on the first access only.
print("Diagnostics first access:", station.fullDiagnostics)
print("Diagnostics second access:", station.fullDiagnostics)

// Test the computed property's setter.
station.averageOxygen = 60
print("Average after setting it to 60:", station.averageOxygen)
print("Oxygen after setting the average:", station.oxygenByDeck)


// 5.2 · The clamp trap

station.hullIntegrity = 130
print("Hull after setting 130:", station.hullIntegrity)

station.hullIntegrity = -40
print("Hull after setting -40:", station.hullIntegrity)

station.hullIntegrity = 55
print("Hull after setting 55:", station.hullIntegrity)

// didSet does not call its observers again when it changes the same property
// from inside that property's didSet.


// MARK: Level 6 · Incident Reports

/*
Report 1:
Expected: every crew member's oxygen decreases by 10.
Actual: the loop changes a temporary copy of each CrewSnapshot. The array stays unchanged.
Rule: CrewSnapshot is a struct, so it has value semantics.
Fix: change the array elements through their indices.
*/

var attemptedRosterChange = crewRoster
for var member in attemptedRosterChange {
    member.oxygen -= 10
}

if let originalFirstMember = crewRoster.first,
   let attemptedFirstMember = attemptedRosterChange.first {
    print("Value-type loop demo - original oxygen:", originalFirstMember.oxygen)
    print("Value-type loop demo - array oxygen after changing loop copy:", attemptedFirstMember.oxygen)
}

var fixedRoster = crewRoster

for index in fixedRoster.indices {
    fixedRoster[index].oxygen -= 10
}

var originalOxygenLevels: [Int] = []
for member in crewRoster {
    originalOxygenLevels.append(member.oxygen)
}

var fixedOxygenLevels: [Int] = []
for member in fixedRoster {
    fixedOxygenLevels.append(member.oxygen)
}

print("Original roster oxygen:", originalOxygenLevels)
print("Fixed roster oxygen:", fixedOxygenLevels)


/*
Report 2:
Expected: podA keeps its original charge of 100.
Actual: if podB refers to podA, changing podB also changes podA.
Rule: TeleportPod is a class, so both variables can refer to the same object.
Fix: create a separate pod when independent state is needed.
*/

let podA = TeleportPod(id: "A", chargeLevel: 100)
let podB = TeleportPod(id: "B", chargeLevel: 100)

podB.chargeLevel = 0

print("Separate pod A charge:", podA.chargeLevel)
print("Separate pod B charge:", podB.chargeLevel)


/*
Report 3:
Expected: Logbook.add appends an entry.
Actual: the code does not compile.
Rule: a struct method that changes a stored property must be marked mutating.
Fix: add mutating before func.
*/

struct Logbook {
    var entries: [String] = []

    mutating func add(_ entry: String) {
        entries.append(entry)
    }
}

var logbook = Logbook()
logbook.add("Teleporter checked")

print("Logbook entries:", logbook.entries)
print("Logbook entry count:", logbook.entries.count)


/*
Report 4:
Expected: both assignments work.
Actual: changing snapshot.oxygen does not compile, but changing pod.chargeLevel does.
Rule: let freezes the whole struct value. For a class, let freezes the reference,
not the object's var properties.
Fix: declare the snapshot as var. The pod can remain let.
*/

var snapshot = CrewSnapshot.rookie(named: "Dana")
snapshot.oxygen = 40

let fixedPod = TeleportPod(id: "B", chargeLevel: 50)
fixedPod.chargeLevel = 10

print("Updated snapshot oxygen:", snapshot.oxygen)
print("Updated pod charge:", fixedPod.chargeLevel)


// MARK: Level 7 · Sealing the Black Box

// A class is appropriate because the station needs one shared recorder
// and one shared history.
final class FlightRecorder {
    // private blocks outside code from directly accessing or replacing the entries.
    private var entries: [String] = []

    // internal blocks access from other modules.
    internal var entryCount: Int {
        entries.count
    }

    // internal blocks access from other modules.
    // private(set) blocks outside code from changing the seal state.
    internal private(set) var isSealed = false

    // internal blocks access from other modules.
    internal var transcript: String {
        entries.joined(separator: "\n")
    }

    // internal blocks access from other modules.
    internal func addEntry(_ entry: String) {
        guard !isSealed else {
            return
        }

        entries.append(entry)
    }

    // internal blocks access from other modules.
    internal func seal() {
        isSealed = true
    }

    // fileprivate blocks calls from other files but lets this file's audit function use it.
    fileprivate func entriesForAudit() -> [String] {
        entries
    }
}

func auditTranscript(of recorder: FlightRecorder) -> String {
    recorder.entriesForAudit().joined(separator: " | ")
}

let recorder = FlightRecorder()
recorder.addEntry("Crew transfer verified")
recorder.addEntry("Oxygen readings stored")

print("Recorder entry count:", recorder.entryCount)
print("Recorder transcript:", recorder.transcript)
print("Audit transcript:", auditTranscript(of: recorder))

recorder.seal()
recorder.addEntry("This entry should not be added")

print("Recorder is sealed:", recorder.isSealed)
print("Entry count after attempted addition:", recorder.entryCount)

/*
Attempts to change the recorder from outside the type:

recorder.entries = []
Compiler error: 'entries' is inaccessible due to 'private' protection level.

recorder.isSealed = false
Compiler error: cannot assign to property: 'isSealed' setter is inaccessible.
*/


// MARK: Finale · Integrity Code

let alarmForManifest = AlarmLevel.level(forTotalMass: A)
let D = alarmForManifest.rawValue

let integrityCode = "\(A)-\(B)-\(C)-\(D)"
print("INTEGRITY CODE: \(integrityCode)")


// MARK: Bonus

var retainedPod: TeleportPod? = nil

print("Before the bonus do-block")

do {
    let podInsideBlock = TeleportPod(id: "Bonus-Pod", chargeLevel: 70)
    retainedPod = podInsideBlock
    print("Inside the do-block")
}

print("After the do-block; the second reference still exists")
// deinit runs on this line when retainedPod releases the last reference to the pod.
retainedPod = nil
print("After releasing the second reference")

func areSamePod(_ first: TeleportPod, _ second: TeleportPod) -> Bool {
    first === second
}

let identityPodA = TeleportPod(id: "Identity", chargeLevel: 50)
let identityPodB = identityPodA
let similarPod = TeleportPod(id: "Identity", chargeLevel: 50)

print("Aliases are the same pod:", areSamePod(identityPodA, identityPodB))
print("Similar pods are the same pod:", areSamePod(identityPodA, similarPod))

// === compares class references. CrewSnapshot is a struct value, not a reference,
// so === cannot be used to compare two CrewSnapshot values.


// MARK: - DEFENSE QUESTIONS
/*
1. Why did CrewSnapshot get an initializer for free while TeleportPod did not?

   CrewSnapshot is a struct with stored properties and no custom initializer, so Swift
   provides a memberwise initializer. Classes do not get that memberwise initializer.
   The assignment asks us to write TeleportPod's initializer ourselves.

2. What does mutating do to self, and why do classes never need it?

   A mutating method lets a struct change its value, including assigning a new value
   to self. In the method, self behaves like an inout value: changes are written back
   to the original variable when the call finishes. Classes change the referenced
   object's properties, so their methods do not use mutating.

3. In Report 4 both values are let. What exactly does let freeze for a struct and class?

   For a struct, let makes the whole value immutable, so snapshot.oxygen cannot change.
   For a class, let makes the reference constant; the object's var properties can still
   change. That is why fixedPod.chargeLevel can change.

4. Why must a lazy property be var? When does lazy change behaviour?

   A lazy property is stored when first accessed, so Swift must be able to assign its
   value after initialization; that is why it must be var. In this code,
   station.fullDiagnostics prints "Running full scan..." on its first access, and the
   cached value is reused on the second access. untouchedStation never accesses that
   property, so it never prints the scan message. If fullDiagnostics were an ordinary
   stored property initialized by the same closure, the scan message would print when
   every Station was created, even if the diagnostics were never read.

5. private vs fileprivate: where in FlightRecorder would private be too strict?

   entries is private so outside code cannot access the raw list. The free function
   auditTranscript cannot access a private property directly. The fileprivate
   entriesForAudit helper is visible throughout this file, so that function can read
   the entries through the helper.

Bonus. On which line does deinit fire, and why can't === be used on CrewSnapshot?

   The bonus pod stays alive after the do-block because retainedPod still refers to it.
   deinit runs when retainedPod is set to nil and the last reference is released.
   === checks whether two class references point to the same object. CrewSnapshot is
   a struct, so it has values rather than object identity.
*/
