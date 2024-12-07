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
    
    init() {
        loadStilmittelData()
    }
    
    private func loadStilmittelData() {
        // Change this to "all_stilmittel" if you want to use the file as given
        // or rename all_stilmittel.json to stilmittel.json and keep stilmittel here.
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
