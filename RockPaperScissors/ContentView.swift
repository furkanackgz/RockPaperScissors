//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Furkan Açıkgöz on 12.07.2023.
//

import SwiftUI

struct PutSpacers: View {
    var number: Int
    
    var body: some View {
        ForEach(0..<number, id: \.self) { _ in
            Spacer()
        }
    }
}

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

struct TextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.primary)
            .font(.title2).bold()
    }
}

extension View {
    func hStackButton() -> some View {
        modifier(ButtonModifier())
    }
    
    func hStackText() -> some View {
        modifier(TextModifier())
    }
}

struct ContentView: View {
    @State private var elements = ["Rock", "Paper", "Scissors"]
    @State private var appsChoice = 2
    @State private var winOrLose = false
    @State private var usersChoice = 0
    @State private var score = 0
    @State private var numOfTurns = 1
    @State private var presentAlert = false
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color("Cream"), location: 0.3),
                .init(color: Color("Light Blue"), location: 0.3)
            ], center: .center, startRadius: 0, endRadius: 600)
                .ignoresSafeArea()
            
            VStack {
                PutSpacers(number: 1)
                
                Text(winOrLose ? "Win" : "Lose")
                    .font(.system(size: 52))
                    .foregroundColor(winOrLose ? .green : .red)
                
                PutSpacers(number: 2)
                
                VStack(spacing: 60) {
                    Text(elements[appsChoice])
                        .font(.system(size: 38))
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 10) {
                        ForEach(0..<3) { num in
                            Button {
                                usersChoice = num
                                updateScore()
                                resetGame()
                            } label: {
                                Text(elements[num])
                                    .hStackText()
                            }
                            .hStackButton()
                        }
                    }
                }
                
                PutSpacers(number: 3)
                
                Text("Score: \(score)")
                    .font(.title)
                
                PutSpacers(number: 1)
            }
        }
        .onAppear {
            startGame()
        }
        .alert("Result", isPresented: $presentAlert) {
            Button("New Game") { startGame() }
        } message: {
            Text("Finished, the score: \(score)")
        }

    }
    
    private func startGame() {
        appsChoice = Int.random(in: 0..<3)
        winOrLose = Bool.random()
        score = 0
        numOfTurns = 0
        presentAlert = false
    }
    
    private func resetGame() {
        appsChoice = Int.random(in: 0..<3)
        winOrLose = [true, false].randomElement()!
        numOfTurns += 1
        if numOfTurns == 10 { presentAlert = true }
    }
    
    private func updateScore() {
        if checkWhetherUserWon() == winOrLose {
            score += 1
        } else {
            score -= 1
        }
    }
    
    private func checkWhetherUserWon() -> Bool {
        if abs(appsChoice - usersChoice) == 1 {
            return (usersChoice > appsChoice) ? true : false
        } else {
            return (usersChoice < appsChoice) ? true : false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
