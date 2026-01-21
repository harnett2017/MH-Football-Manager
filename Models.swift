// Ultimate Football Manager iOS Prototype - Models
// This file contains the data models for players and team.

import Foundation

class Player: Identifiable, ObservableObject {
    let id = UUID()
    @Published var name: String
    let position: String
    @Published var overall: Int
    let potential: Int
    let age: Int
    @Published var morale: Int
    
    init(name: String, position: String, overall: Int, potential: Int, age: Int, morale: Int = 80) {
        self.name = name
        self.position = position
        self.overall = overall
        self.potential = potential
        self.age = age
        self.morale = morale
    }
    
    func train() {
        if Bool.random() {
            overall = min(overall + 1, potential)
        }
        morale += Int.random(in: -5...5)
    }
}

class Team: ObservableObject {
    @Published var name: String = "Houghton Heroes"
    @Published var squad: [Player] = []
    @Published var youthAcademy: [Player] = []
    @Published var formation: String = "4-4-2"
    @Published var points: Int = 0
    
    func addPlayer(_ player: Player) {
        squad.append(player)
    }
    
    func generateYouthIntake(num: Int = 5, completion: @escaping (String) -> Void) {
        // In a real app, use async for inputs; here simulate with default auto-gen
        let positions = ["GK", "DEF", "MID", "FWD"]
        for _ in 0..<num {
            let name = randomName() // Auto-gen; user can rename later
            let pos = positions.randomElement()!
            let overall = Int.random(in: 40...60)
            let potential = Int.random(in: 60...90)
            let age = Int.random(in: 15...18)
            youthAcademy.append(Player(name: name, position: pos, overall: overall, potential: potential, age: age))
        }
        completion("Youth intake generated!")
    }
    
    func promoteYouth(at index: Int) {
        if index < youthAcademy.count {
            let player = youthAcademy.remove(at: index)
            squad.append(player)
        }
    }
    
    func simulateMatch() -> String {
        let myScore = (squad.prefix(11).reduce(0) { $0 + $1.overall } / 11) + Int.random(in: -10...10)
        let oppScore = 70 + Int.random(in: -20...20)
        if myScore > oppScore {
            points += 3
            return "Win: \(myScore)-\(oppScore)"
        } else if myScore == oppScore {
            points += 1
            return "Draw: \(myScore)-\(oppScore)"
        } else {
            return "Loss: \(myScore)-\(oppScore)"
        }
    }
    
    private func randomName() -> String {
        let firstNames = ["Liam", "Ethan", "Noah", "Oliver", "Aiden", "Mark", "Dave", "Sarah", "Emma", "John"]
        let lastNames = ["Smith", "Johnson", "Williams", "Brown", "Jones", "Sunderland", "Houghton", "Wilson", "Taylor", "Green"]
        return firstNames.randomElement()! + " " + lastNames.randomElement()!
    }
}
