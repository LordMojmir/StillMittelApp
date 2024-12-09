//
//  StilmittelViewModel.swift
//  StilmittelApp
//
//  Created by Mojmír Horváth on 07.12.24.
//

import Foundation

struct StilmittelData: Codable {
    let stilmittel: [Stilmittel]
}

class StilmittelViewModel: ObservableObject {
    @Published var stilmittel: [Stilmittel] = []
    @Published var knownCount = 0
    @Published var unknownCount = 0
    
    init() {
        loadStilmittelData()
    }
    
    private func loadStilmittelData() {
        guard let url = Bundle.main.url(forResource: "all_stilmittel", withExtension: "json") else {
            print("Could not find all_stilmittel.json in the bundle.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode(StilmittelData.self, from: data)
            self.stilmittel = decodedData.stilmittel
        } catch {
            print("Failed to load or decode stilmittel data: \(error)")
        }
    }
    
    func randomStilmittel() -> Stilmittel? {
        stilmittel.randomElement()
    }
}
