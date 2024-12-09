// ===== StilmittelApp/ContentView.swift =====
//
//  ContentView.swift
//  StilmittelApp
//
//  Created by Mojmír Horváth on 07.12.24.
//

import SwiftUI

enum QuizMode: String, CaseIterable {
    case guessTermByExample = "Guess Example"
    case guessTermByExplanation = "Guess Explanation"
    case browseAll = "Browse All"
}

struct ContentView: View {
    @StateObject var viewModel = StilmittelViewModel()
    @State private var selectedMode: QuizMode = .guessTermByExample
    @State private var currentStilmittel: Stilmittel?
    @State private var showAnswer = false
    @State private var answered = false  // Track if user has responded known/unknown
    @State private var searchText = ""   // For searching in browseAll mode
    
    var filteredStilmittel: [Stilmittel] {
        viewModel.stilmittel
            .filter {
                searchText.isEmpty ||
                $0.term.lowercased().contains(searchText.lowercased()) ||
                $0.explanation.lowercased().contains(searchText.lowercased()) ||
                $0.example.lowercased().contains(searchText.lowercased())
            }
            .sorted { $0.term.lowercased() < $1.term.lowercased() }
    }
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedMode) {
                // MARK: - Guess by Example Tab
                VStack {
                    Spacer()
                    if let stilmittel = currentStilmittel {
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
                                
                                // Show thumbs up/down options once
                                HStack {
                                    Button(action: {
                                        viewModel.knownCount += 1
                                        answered = true
                                    }) {
                                        Label("I knew it", systemImage: "hand.thumbsup.fill")
                                            .padding()
                                            .background(Color.blue.opacity(0.2))
                                            .cornerRadius(8)
                                    }
                                    .disabled(answered)
                                    
                                    Button(action: {
                                        viewModel.unknownCount += 1
                                        answered = true
                                    }) {
                                        Label("I didn't", systemImage: "hand.thumbsdown.fill")
                                            .padding()
                                            .background(Color.red.opacity(0.2))
                                            .cornerRadius(8)
                                    }
                                    .disabled(answered)
                                }
                                .padding(.top)
                            }
                        }
                    } else {
                        Text("Wähle einen Modus und klicke auf 'Neu'!")
                            .padding()
                    }
                    
                    Spacer()
                    
                    // Single button at the bottom
                    Button(action: {
                        if showAnswer {
                            // If we were showing the answer, now load a new stilmittel
                            currentStilmittel = viewModel.randomStilmittel()
                            showAnswer = false
                            answered = false
                        } else {
                            // If we were not showing the answer, show it now
                            showAnswer = true
                        }
                    }) {
                        Text(showAnswer ? "Neu" : "Antwort anzeigen")
                            .padding()
                            .background(showAnswer ? Color.blue.opacity(0.2) : Color.green.opacity(0.2))
                            .cornerRadius(8)
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
                .tag(QuizMode.guessTermByExample)
                .tabItem {
                    Label("Guess Example", systemImage: "eye")
                }
                .onAppear {
                    if selectedMode == .guessTermByExample && currentStilmittel == nil {
                        currentStilmittel = viewModel.randomStilmittel()
                    }
                }
                
                // MARK: - Guess by Explanation Tab
                VStack {
                    Spacer()
                    if let stilmittel = currentStilmittel {
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
                                
                                // Show thumbs up/down options once
                                HStack {
                                    Button(action: {
                                        viewModel.knownCount += 1
                                        answered = true
                                    }) {
                                        Label("I knew it", systemImage: "hand.thumbsup.fill")
                                            .padding()
                                            .background(Color.blue.opacity(0.2))
                                            .cornerRadius(8)
                                    }
                                    .disabled(answered)
                                    
                                    Button(action: {
                                        viewModel.unknownCount += 1
                                        answered = true
                                    }) {
                                        Label("I didn't", systemImage: "hand.thumbsdown.fill")
                                            .padding()
                                            .background(Color.red.opacity(0.2))
                                            .cornerRadius(8)
                                    }
                                    .disabled(answered)
                                }
                                .padding(.top)
                            }
                        }
                    } else {
                        Text("Wähle einen Modus und klicke auf 'Neu'!")
                            .padding()
                    }
                    
                    Spacer()
                    
                    // Single button at the bottom
                    Button(action: {
                        if showAnswer {
                            currentStilmittel = viewModel.randomStilmittel()
                            showAnswer = false
                            answered = false
                        } else {
                            showAnswer = true
                        }
                    }) {
                        Text(showAnswer ? "Neu" : "Antwort anzeigen")
                            .padding()
                            .background(showAnswer ? Color.blue.opacity(0.2) : Color.green.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .padding()
                    
                    HStack {
                        Text("Known: \(viewModel.knownCount)")
                            .padding(.trailing, 20)
                        Text("Unknown: \(viewModel.unknownCount)")
                    }
                    .padding(.bottom)
                }
                .tag(QuizMode.guessTermByExplanation)
                .tabItem {
                    Label("Guess Explanation", systemImage: "questionmark.circle")
                }
                .onAppear {
                    if selectedMode == .guessTermByExplanation && currentStilmittel == nil {
                        currentStilmittel = viewModel.randomStilmittel()
                    }
                }
                
                // MARK: - Browse All Tab
                VStack {
                    List(filteredStilmittel) { s in
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
                    .searchable(text: $searchText, prompt: "Search Stilmittel")
                }
                .tag(QuizMode.browseAll)
                .tabItem {
                    Label("Browse All", systemImage: "magnifyingglass")
                }
                
            }
            .navigationTitle("Stilmittel Lernen")
        }
        .onAppear {
            // Falls der ausgewählte Modus nicht "Browse All" ist, beim Start ein zufälliges Stilmittel laden
            if selectedMode != .browseAll && currentStilmittel == nil {
                currentStilmittel = viewModel.randomStilmittel()
            }
        }
    }
}
