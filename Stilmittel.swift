//
//  Stilmittel.swift
//  StilmittelApp
//
//  Created by Mojmír Horváth on 07.12.24.
//


import Foundation

struct Stilmittel: Identifiable, Codable {
    let id = UUID()
    let term: String
    let explanation: String
    let example: String
}