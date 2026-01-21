// Ultimate Football Manager iOS Prototype - Main UI
// This is the SwiftUI view for the app. To run:
// 1. Create a new Xcode project (iOS App, SwiftUI Interface).
// 2. Replace ContentView.swift with this.
// 3. Add Models.swift to the project.

import SwiftUI

struct ContentView: View {
    @StateObject var team = Team()
    @State private var currentTab = "Dashboard"
    @State private var matchResult: String? = nil
    @State private var showingNameAlert = false
    @State private var selectedPlayer: Player?
    @State private var newName: String = ""
    @State private var showingYouthGen = false
    @State private var youthMessage: String = ""
    
    var body: some View {
        NavigationStack {
            TabView(selection: $currentTab) {
                dashboardView
                    .tabItem { Label("Dashboard", systemImage: "house") }
                    .tag("Dashboard")
                
                squadView
                    .tabItem { Label("Squad", systemImage: "person.3") }
                    .tag("Squad")
                
                youthView
                    .tabItem { Label("Youth", systemImage: "leaf") }
                    .tag("Youth")
                
                tacticsView
                    .tabItem { Label("Tactics", systemImage: "gear") }
                    .tag("Tactics")
            }
            .navigationTitle("Ultimate Football Manager")
            .onAppear {
                generateInitialSquad()
            }
            .alert("Rename Player", isPresented: $showingNameAlert) {
                TextField("New Name", text: $newName)
                Button("OK") {
                    selectedPlayer?.name = newName
                    newName = ""
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Enter new name for \(selectedPlayer?.name ?? "")")
            }
            .alert(youthMessage, isPresented: $showingYouthGen) {
                Button("OK") { }
            }
        }
    }
    
    private var dashboardView: some View {
        VStack {
            Text("Points: \(team.points)")
                .font(.headline)
            if let result = matchResult {
                Text("Last Match: \(result)")
            }
            Button("Simulate Match") {
                matchResult = team.simulateMatch()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    private var squadView: some View {
        List(team.squad) { player in
            HStack {
                Text("\(player.name) (\(player.position)) OVR:\(player.overall) POT:\(player.potential) Age:\(player.age)")
                Spacer()
                Button("Rename") {
                    selectedPlayer = player
                    newName = player.name
                    showingNameAlert = true
                }
                Button("Train") {
                    player.train()
                }
            }
        }
    }
    
    private var youthView: some View {
        VStack {
            List {
                ForEach(team.youthAcademy) { player in
                    HStack {
                        Text("\(player.name) (\(player.position)) OVR:\(player.overall) POT:\(player.potential) Age:\(player.age)")
                        Spacer()
                        Button("Rename") {
                            selectedPlayer = player
                            newName = player.name
                            showingNameAlert = true
                        }
                        Button("Promote") {
                            if let index = team.youthAcademy.firstIndex(where: { $0.id == player.id }) {
                                team.promoteYouth(at: index)
                            }
                        }
                    }
                }
            }
            Button("Generate Youth Intake") {
                team.generateYouthIntake { message in
                    youthMessage = message
                    showingYouthGen = true
                }
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    private var tacticsView: some View {
        VStack {
            Text("Formation: \(team.formation)")
            // Add more tactics UI here, e.g., picker for formations
            Picker("Formation", selection: $team.formation) {
                Text("4-4-2").tag("4-4-2")
                Text("4-3-3").tag("4-3-3")
                Text("3-5-2").tag("3-5-2")
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    private func generateInitialSquad() {
        if team.squad.isEmpty {
            let positions = Array(repeating: "GK", count: 2) + Array(repeating: "DEF", count: 6) + Array(repeating: "MID", count: 6) + Array(repeating: "FWD", count: 6)
            for pos in positions {
                let name = team.randomName() // Auto-gen initially; rename in app
                let overall = Int.random(in: 60...85)
                let potential = Int.random(in: overall...95)
                let age = Int.random(in: 18...35)
                team.addPlayer(Player(name: name, position: pos, overall: overall, potential: potential, age: age))
            }
        }
    }
}

#Preview {
    ContentView()
}
