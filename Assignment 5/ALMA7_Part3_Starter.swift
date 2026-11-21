// =============================================================
//  Station ALMA-7, Part III: The Repair Fleet
//  iOS Mobile Development · Module 5 · Lab Assignment
//
//  How to use:
//   • Xcode: File → New → Playground → Blank, replace everything
//     with this file's contents.
//   • Terminal: swift ALMA7_Part3_Starter.swift
//
//  Rules:
//   • Do NOT modify the STARTER DATA section. LegacyBeacon in
//     particular must be reached with an extension, not edited.
//   • `!` (force unwrap) is forbidden: −0.5 points each.
//   • No map / filter / reduce / compactMap.
//   • The Health Rule must exist in exactly ONE place in this file.
// =============================================================


// MARK: - =================== STARTER DATA ===================
// MARK: - Do not modify anything in this section

/// Drone records recovered from the fleet registry.
/// One `kind` does not correspond to any drone type you will build.
let fleetData: [(kind: String, id: String, charge: Int)] = [
    (kind: "welder",  id: "W-1", charge: 80),
    (kind: "scanner", id: "S-1", charge: 45),
    (kind: "cargo",   id: "C-1", charge: 100),
    (kind: "welder",  id: "W-2", charge: 15),
    (kind: "scanner", id: "S-2", charge: 60),
    (kind: "tug",     id: "T-1", charge: 50)
]

/// Hull sensors. These are NOT drones — they never move and never work a shift.
let sensorData: [(id: String, charge: Int)] = [
    (id: "hull-cam", charge: 12),
    (id: "thermal",  charge: 77)
]

/// Hardware from the original station. You may not add anything to this
/// declaration — no methods, no protocols, no properties.
struct LegacyBeacon {
    let name: String
    let signalStrength: Int
}

let beacon = LegacyBeacon(name: "ALMA-BEACON", signalStrength: 8)

print("Fleet registry online: \(fleetData.count) drone records, \(sensorData.count) sensors, beacon \(beacon.name).")

// MARK: - ================= END OF STARTER DATA =================


// MARK: - =================== YOUR SOLUTION ===================
// Uncomment each declaration when you start working on it.
// MARK: Level 1 · The Power Cell

// A class makes the battery one shared reference object that a drone can recharge.
final class PowerCell {
    private var charge: Int

    init(charge: Int) {
        self.charge = min(100, max(0, charge))
    }

    func level() -> Int {
        charge
    }

    @discardableResult
    func spend(_ amount: Int) -> Bool {
        guard amount > 0, charge >= amount else {
            return false
        }

        charge -= amount
        return true
    }

    func recharge(by amount: Int) {
        guard amount > 0 else {
            return
        }

        charge = min(100, charge + amount)
    }
}

// Encapsulation proof (leave commented):
// let cell = PowerCell(charge: 50)
// cell.charge = 100
// Compiler error: 'charge' is inaccessible due to 'private' protection level


// MARK: Level 2 · The Fleet

// final keeps subclasses from changing the common spend-then-work ritual.
class Drone {
    let id: String
    let cell: PowerCell

    init(id: String, cell: PowerCell) {
        self.id = id
        self.cell = cell
    }

    var powerCost: Int {
        10
    }

    var statusLine: String {
        "\(id): \(cell.level())% \(cell.level().powerBar)"
    }

    var componentID: String {
        id
    }

    var statusCode: Int {
        Self.healthCode(for: cell.level())
    }

    func performTask() -> Int {
        0
    }

    func recharge(by amount: Int) {
        // Class methods can mutate the referenced PowerCell without mutating self.
        cell.recharge(by: amount)
    }

    final func runOnce() -> Int {
        guard cell.spend(powerCost) else {
            return 0
        }

        return performTask()
    }
}

// 2.2
final class WelderDrone: Drone {
    override var powerCost: Int {
        25
    }

    override func performTask() -> Int {
        40
    }

    func weldSeam() -> String {
        "\(id): hull seam welded"
    }
}

class ScannerDrone: Drone {
    override var powerCost: Int {
        10
    }

    override var statusLine: String {
        super.statusLine + " [scanner]"
    }

    override func performTask() -> Int {
        15
    }
}

final class CargoDrone: Drone {
    override var powerCost: Int {
        20
    }

    override func performTask() -> Int {
        25
    }
}

// 2.3
func makeDrone(kind: String, id: String, charge: Int) -> Drone? {
    let cell = PowerCell(charge: charge)

    switch kind {
    case "welder":
        return WelderDrone(id: id, cell: cell)
    case "scanner":
        return ScannerDrone(id: id, cell: cell)
    case "cargo":
        return CargoDrone(id: id, cell: cell)
    default:
        return nil
    }
}

var fleet: [Drone] = []

for record in fleetData {
    if let drone = makeDrone(kind: record.kind, id: record.id, charge: record.charge) {
        fleet.append(drone)
    } else {
        print("Warning: skipped unknown drone kind '\(record.kind)' (\(record.id)).")
    }
}


// MARK: Level 3 · The Shift

func runShift(_ fleet: [Drone], rounds: Int) -> Int {
    var totalWork = 0

    if rounds <= 0 {
        return totalWork
    }

    for _ in 0..<rounds {
        for drone in fleet {
            totalWork += drone.runOnce()
        }
    }

    return totalWork
}

let A = runShift(fleet, rounds: 3)

var B = 0
var C = 0

for drone in fleet {
    print(drone.statusLine)
    B += drone.cell.level()

    if drone.cell.level() >= drone.powerCost {
        C += 1
    }
}


// MARK: Level 4 · Diagnostics

protocol Diagnosable {
    var componentID: String { get }
    var statusCode: Int { get }
    func diagnose() -> String
}

protocol Rechargeable {
    mutating func recharge(by amount: Int)
}

// A class has reference semantics, so its protocol implementation needs no mutating.
extension Drone: Diagnosable, Rechargeable {}

struct SensorModule: Diagnosable, Rechargeable {
    let componentID: String
    var chargeLevel: Int

    init(id: String, charge: Int) {
        componentID = id
        chargeLevel = min(100, max(0, charge))
    }

    var statusCode: Int {
        Self.healthCode(for: chargeLevel)
    }

    mutating func recharge(by amount: Int) {
        guard amount > 0 else {
            return
        }

        chargeLevel = min(100, chargeLevel + amount)
    }
}

func diagnosticsReport(_ components: [Diagnosable]) -> String {
    var lines: [String] = []

    for component in components {
        lines.append(component.diagnose())
    }

    return lines.joined(separator: "\n")
}

// [Drone] could not hold SensorModule values because Drone is a class type and
// SensorModule is not a subclass of Drone; a protocol type can hold both.
var sensors: [SensorModule] = []

for sensor in sensorData {
    sensors.append(SensorModule(id: sensor.id, charge: sensor.charge))
}

var droneAndSensorDiagnostics: [Diagnosable] = []
for drone in fleet {
    droneAndSensorDiagnostics.append(drone)
}
for sensor in sensors {
    droneAndSensorDiagnostics.append(sensor)
}

print("\nDrone and sensor diagnostics:\n\(diagnosticsReport(droneAndSensorDiagnostics))")


// MARK: Level 5 · Shared Behaviour

extension Diagnosable {
    // This is the one and only implementation of the assignment's Health Rule.
    static func healthCode(for charge: Int) -> Int {
        if charge < 20 {
            return 2
        } else if charge < 50 {
            return 1
        } else {
            return 0
        }
    }

    func diagnose() -> String {
        "\(componentID): code \(statusCode)"
    }
}

extension LegacyBeacon: Diagnosable {
    var componentID: String {
        name
    }

    var statusCode: Int {
        Self.healthCode(for: signalStrength)
    }

    func diagnose() -> String {
        "LEGACY BEACON \(name): signal code \(statusCode)"
    }
}

var allDiagnostics: [Diagnosable] = droneAndSensorDiagnostics
allDiagnostics.append(beacon)

print("\nAll component diagnostics:\n\(diagnosticsReport(allDiagnostics))")

var statusCodeTotal = 0
for component in allDiagnostics {
    statusCodeTotal += component.statusCode
}
let D = statusCodeTotal

extension Int {
    var powerBar: String {
        let clampedValue = min(100, max(0, self))
        let filledBlocks = clampedValue / 10
        var bar = ""

        for index in 0..<10 {
            bar += index < filledBlocks ? "#" : "."
        }

        return bar
    }
}

// Use the Int extension in statusLine (defined above); Swift resolves extensions
// throughout the file, regardless of their textual position.


// MARK: Level 6 · Incident Reports

/*
Report 1
Expectation: PatchDrone adds a task that produces 30 work units.
Actual: as written in the assignment, it does not compile because `performTask()`
overrides a superclass method without the `override` keyword.
Rule: Swift requires `override` when a subclass replaces an inherited method.
Fix: add `override` to the method declaration.
*/
class PatchDrone: Drone {
    override func performTask() -> Int {
        30
    }
}

let patchDrone = PatchDrone(id: "P-1", cell: PowerCell(charge: 50))
print("Report 1 fixed work:", patchDrone.runOnce())

/*
Report 2
Expectation: HeavyWelder inherits from WelderDrone and forces runOnce() to return 999.
Actual: it does not compile: WelderDrone is final and cannot be subclassed; runOnce()
is final and cannot be overridden.
Rule: `final` blocks subclassing or overriding at compile time.
Fix: inherit from Drone and customize the allowed override points, such as powerCost
and performTask(), while keeping the shared runOnce() ritual intact.
*/
final class HeavyWelder: Drone {
    override var powerCost: Int {
        30
    }

    override func performTask() -> Int {
        60
    }
}

let heavyWelder = HeavyWelder(id: "HW-1", cell: PowerCell(charge: 80))
print("Report 2 fixed work:", heavyWelder.runOnce())

/*
Report 3
Expectation: call weldSeam() on the first element of [Drone].
Actual: it does not compile because the expression's static type is Drone, which has
no weldSeam() method.
Rule: Swift checks members using the variable's static type; subclass-only members
require a runtime type check.
Fix: use `as?`, which returns an optional because the element might not be a welder.
*/

let reportFleet: [Drone] = [WelderDrone(id: "W-9", cell: PowerCell(charge: 100))]
let first = reportFleet[0]

if let welder = first as? WelderDrone {
    print(welder.weldSeam())
} else {
    print("The first report drone is not a welder.")
}

/*
Report 4
Expectation: the call prints "thruster T-1".
Actual: it compiles but prints "generic component".
Rule: label() exists only in the protocol extension, not in the protocol requirements.
Calls through the protocol type use the extension implementation because the method
is not dynamically dispatched as a protocol witness.
Fix: add label() to the protocol requirements; then the conforming type's method is
used through the protocol-typed array.
*/
protocol OldLabelled {
    var componentID: String { get }
}

extension OldLabelled {
    func label() -> String {
        "generic component"
    }
}

struct OldThruster: OldLabelled {
    let componentID: String

    func label() -> String {
        "thruster \(componentID)"
    }
}

let oldParts: [OldLabelled] = [OldThruster(componentID: "T-old")]
print("Before adding the requirement:", oldParts[0].label())

protocol Labelled {
    var componentID: String { get }
    func label() -> String
}

extension Labelled {
    func label() -> String {
        "generic component"
    }
}

struct Thruster: Labelled {
    let componentID: String

    func label() -> String {
        "thruster \(componentID)"
    }
}

let parts: [Labelled] = [Thruster(componentID: "T-1")]
print(parts[0].label())

// Observation: in the pasted Swift snippets, Reports 1, 2, and 3 fail to compile.
// In particular, the missing `override` in Report 1 is itself a compile-time error.
// Only Report 4 compiles and produces an unexpected result, despite the PDF saying
// that two reports fail to compile and two compile but lie.


// MARK: Finale · Mission Code

let missionCode = "\(A)-\(B)-\(C)-\(D)"
print("\nMISSION CODE: \(missionCode)")


// MARK: Bonus · Abstract Base Type Alternatives
/*
Runtime-only guard: a concrete base-class implementation can use
preconditionFailure("Drone must be subclassed") when performTask() is called.
The program builds, but using a plain Drone fails while running.

Compile-time guard: represent the common drone interface as a protocol. A protocol
cannot be initialized, so there is no way to create a bare base drone.
*/

protocol FleetDrone: Diagnosable, Rechargeable {
    var id: String { get }
    var cell: PowerCell { get }
    var powerCost: Int { get }
    func performTask() -> Int
}

extension FleetDrone {
    var componentID: String {
        id
    }

    var statusCode: Int {
        Self.healthCode(for: cell.level())
    }

    var statusLine: String {
        "\(id): \(cell.level())% \(cell.level().powerBar)"
    }

    func runOnce() -> Int {
        guard cell.spend(powerCost) else {
            return 0
        }

        return performTask()
    }
}

// Struct-based examples use the same PowerCell reference for shared battery state.
struct ProtocolWelderDrone: FleetDrone {
    let id: String
    let cell: PowerCell
    var powerCost: Int { 25 }

    func performTask() -> Int { 40 }

    mutating func recharge(by amount: Int) {
        cell.recharge(by: amount)
    }
}

struct ProtocolScannerDrone: FleetDrone {
    let id: String
    let cell: PowerCell
    var powerCost: Int { 10 }

    func performTask() -> Int { 15 }

    var statusLineWithScannerLabel: String {
        statusLine + " [scanner]"
    }

    mutating func recharge(by amount: Int) {
        cell.recharge(by: amount)
    }
}

struct ProtocolCargoDrone: FleetDrone {
    let id: String
    let cell: PowerCell
    var powerCost: Int { 20 }

    func performTask() -> Int { 25 }

    mutating func recharge(by amount: Int) {
        cell.recharge(by: amount)
    }
}

var protocolFleet: [any FleetDrone] = [
    ProtocolWelderDrone(id: "PW-1", cell: PowerCell(charge: 80)),
    ProtocolScannerDrone(id: "PS-1", cell: PowerCell(charge: 45)),
    ProtocolCargoDrone(id: "PC-1", cell: PowerCell(charge: 100))
]

var protocolFleetWork = 0
for _ in 0..<3 {
    for index in protocolFleet.indices {
        protocolFleetWork += protocolFleet[index].runOnce()
    }
}

print("Protocol fleet sample work:", protocolFleetWork)

/*
The class design gives the drones shared identity and lets subclasses inherit
stored state and override behavior. The protocol design also works across structs
and classes, with shared code in extensions; I would choose the class design here
because each drone has a persistent battery object and a clear family relationship.
If drones needed independent value copies, the protocol-and-struct design would be
more suitable, while shared mutable state would need an explicit reference object.
*/


// MARK: - =================== DEFENSE QUESTIONS ===================
/*
1. A class is a reference type, so its method can change the referenced PowerCell
   without replacing or mutating the class instance itself. A struct is a value type;
   its mutating protocol implementation is allowed to change its own stored value.

2. Inheritance lets a class reuse stored properties and implementation from one
   superclass. Protocols let unrelated types, including structs and classes, promise
   the same interface and be used together through that protocol type.

3. final prevents subclassing a class or overriding a method/property. Making
   runOnce() final protects the battery-spending sequence so subclasses can change
   cost and work without bypassing the shared shift ritual.

4. label() in the original example existed only in a protocol extension, not in the
   protocol requirements. Calls through a Labelled existential therefore selected the
   extension method; adding label() to the protocol enables dynamic witness dispatch.
*/
