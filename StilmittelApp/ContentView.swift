//
//  ContentView.swift
//  StilmittelApp
//
//  Created by Mojmír Horváth on 07.12.24.
//

import SwiftUI

enum QuizMode: String, CaseIterable {
    case guessTermByExample = "Guess Term by Example"
    case guessTermByExplanation = "Guess Term by Explanation"
    case browseAll = "Browse All"
}

struct ContentView: View {
    @StateObject var viewModel = StilmittelViewModel()
    @State private var selectedMode: QuizMode = .guessTermByExample
    @State private var currentStilmittel: Stilmittel?
    @State private var showAnswer = false
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Mode", selection: $selectedMode) {
                    ForEach(QuizMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if selectedMode == .browseAll {
                    List(viewModel.stilmittel) { s in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(s.term)
                                .font(.headline)
                            Text("Erklärung: \(s.explanation)")
                                .font(.subheadline)
                            Text("Beispiel: \(s.example)")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                    }
                } else {
                    Spacer()
                    if let stilmittel = currentStilmittel {
                        if selectedMode == .guessTermByExample {
                            VStack {
                                Text("Beispiel:")
                                    .font(.headline)
                                Text("\"\(stilmittel.example)\"")
                                    .font(.title3)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                
                                if showAnswer {
                                    Text("Lösung: \(stilmittel.term)")
                                        .font(.title2)
                                        .foregroundColor(.green)
                                    Text("Erklärung: \(stilmittel.explanation)")
                                        .font(.subheadline)
                                        .padding()
                                    
                                    // Show thumbs up/down options
                                    HStack {
                                        Button(action: {
                                            viewModel.knownCount += 1
                                        }) {
                                            Label("I knew it", systemImage: "hand.thumbsup.fill")
                                                .padding()
                                                .background(Color.blue.opacity(0.2))
                                                .cornerRadius(8)
                                        }
                                        
                                        Button(action: {
                                            viewModel.unknownCount += 1
                                        }) {
                                            Label("I didn't", systemImage: "hand.thumbsdown.fill")
                                                .padding()
                                                .background(Color.red.opacity(0.2))
                                                .cornerRadius(8)
                                        }
                                    }
                                    .padding(.top)
                                }
                            }
                        } else if selectedMode == .guessTermByExplanation {
                            VStack {
                                Text("Erklärung:")
                                    .font(.headline)
                                Text(stilmittel.explanation)
                                    .font(.title3)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                
                                if showAnswer {
                                    Text("Lösung: \(stilmittel.term)")
                                        .font(.title2)
                                        .foregroundColor(.green)
                                    Text("Beispiel: \(stilmittel.example)")
                                        .font(.subheadline)
                                        .padding()
                                    
                                    // Show thumbs up/down options
                                    HStack {
                                        Button(action: {
                                            viewModel.knownCount += 1
                                        }) {
                                            Label("I knew it", systemImage: "hand.thumbsup.fill")
                                                .padding()
                                                .background(Color.blue.opacity(0.2))
                                                .cornerRadius(8)
                                        }
                                        
                                        Button(action: {
                                            viewModel.unknownCount += 1
                                        }) {
                                            Label("I didn't", systemImage: "hand.thumbsdown.fill")
                                                .padding()
                                                .background(Color.red.opacity(0.2))
                                                .cornerRadius(8)
                                        }
                                    }
                                    .padding(.top)
                                }
                            }
                        }
                    } else {
                        Text("Wähle einen Modus und klicke auf 'Neu'!")
                            .padding()
                    }
                    
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            // Get a new stilmittel
                            currentStilmittel = viewModel.randomStilmittel()
                            showAnswer = false
                        }) {
                            Text("Neu")
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            showAnswer = true
                        }) {
                            Text("Antwort anzeigen")
                                .padding()
                                .background(Color.green.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                    
                    // Display known/unknown counts
                    HStack {
                        Text("Known: \(viewModel.knownCount)")
                            .padding(.trailing, 20)
                        Text("Unknown: \(viewModel.unknownCount)")
                    }
                    .padding(.bottom)
                }
            }
            .navigationTitle("Stilmittel Lernen")
        }
        .onAppear {
            // If not browse mode, load a random one at start
            if selectedMode != .browseAll {
                currentStilmittel = viewModel.randomStilmittel()
            }
        }
    }
}
