//
//  ContentView.swift
//  RockPaper
//
//  Created by Prabhdeep Singh on 23/08/22.
//

import SwiftUI
enum GameChoices: String {
    case rock = "Rock"
    case paper = "Paper"
    case scisssors = "Scissors"
}

struct ContentView: View {
    //MARK: Properties
    private let gameChoices = [GameChoices.rock.rawValue, GameChoices.paper.rawValue, GameChoices.scisssors.rawValue]
    private let maxTurns = 4
    @State private var playerShouldWin = Bool.random()
    @State private var aiChoice = Int.random(in: 0...2)
    @State private var playerPoints = 0
    @State private var currentTurnNumber = 1
    @State private var shouldPresentAlert = false
    @State private var didPlayerAnswerCorrectly = false
    @State private var shouldShowFinalScore = false
    
    //MARK: UI
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue, .white, .mint], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack(alignment: .center, spacing: 20) {
                HStack {
                    Text("\(playerPoints)")
                        .font(.system(size: 25, weight: .medium, design: .serif))
                        .padding(40)
                        .foregroundColor(Color.white)
                        .background(Color.green)
                        .clipShape(Circle())
                }
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text("AI Chose -> ")
                            .bold()
                            .foregroundColor(.gray)
                            .font(.system(size: 18))
                        Spacer()
                        Text(gameChoices[aiChoice])
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(10)
                            .frame(width: 100, height: 30)
                            .background(.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding([.leading, .trailing], 30)
                    HStack {
                        Text("Player must ->")
                            .bold()
                            .foregroundColor(.gray)
                            .font(.system(size: 18))
                        Spacer()
                        Text(playerShouldWin ? "Win" : "Lose")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(10)
                            .frame(width: 100, height: 30)
                            .background(playerShouldWin ? .green : .red)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .padding([.leading, .trailing], 30)
                }
                HStack {
                    ForEach(gameChoices, id: \.self) { choice in
                        Button(choice) {
                            if currentTurnNumber > maxTurns {
                                return
                            }
                            didPlayerAnswerCorrectly = getGameResult(playerChoice: choice, aiChoice: gameChoices[aiChoice])
                            shouldPresentAlert = true
                            if didPlayerAnswerCorrectly {
                                playerPoints += 1
                            }
                            currentTurnNumber += 1
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.brown)
                    }
                }
                .alert(didPlayerAnswerCorrectly ? "Hurray! That was Correct": "Wrong Answer", isPresented: $shouldPresentAlert) {
                    Button(currentTurnNumber <= maxTurns ? "Next Turn" : "Finish") {
                        nextTurn()
                    }
                } message: {
                    Text(didPlayerAnswerCorrectly ? "You scored 1 point" : "Better luck next time")
                }
                shouldShowFinalScore ? Text("You Scored a Total: \(playerPoints) Points!")
                    .foregroundColor(.gray)
                    .font(.headline.weight(.medium))
                : Text("")
                Button("Restart",role: .cancel) {
                    resetGame()
                }
                .frame(height: shouldShowFinalScore ? nil : 0)
            }
        }
    }
    
    func getGameResult(playerChoice: String, aiChoice: String) -> Bool {
        if playerShouldWin {
            switch aiChoice {
            case GameChoices.rock.rawValue:
                if playerChoice == GameChoices.paper.rawValue {
                    return true
                }
                return false
            case GameChoices.paper.rawValue:
                if playerChoice == GameChoices.scisssors.rawValue {
                    return true
                }
                return false
            case GameChoices.scisssors.rawValue:
                if playerChoice == GameChoices.rock.rawValue {
                    return true
                }
                return false
            default:
                return false
            }
        } else {
            switch aiChoice {
            case GameChoices.rock.rawValue:
                if playerChoice != GameChoices.paper.rawValue {
                    return true
                }
                return false
            case GameChoices.paper.rawValue:
                if playerChoice != GameChoices.scisssors.rawValue {
                    return true
                }
                return false
            case GameChoices.scisssors.rawValue:
                if playerChoice != GameChoices.rock.rawValue {
                    return true
                }
                return false
            default:
                return false
            }
        }
    }
    
    func nextTurn() {
        if currentTurnNumber > maxTurns {
           showFinalScore()
            return
        }
        playerShouldWin = Bool.random()
        aiChoice = Int.random(in: 0...2)
        didPlayerAnswerCorrectly = false
    }
    func resetGame() {
        playerShouldWin = Bool.random()
        aiChoice = Int.random(in: 0...2)
        didPlayerAnswerCorrectly = false
        currentTurnNumber = 1
        playerPoints = 0
        shouldShowFinalScore = false
    }
    func showFinalScore() {
        shouldShowFinalScore = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
