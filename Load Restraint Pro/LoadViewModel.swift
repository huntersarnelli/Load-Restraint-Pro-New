//
//  LoadViewModel.swift
//  Load Restraint Pro
//
//  Created by Hunter Sarnelli on 8/25/25.
//

import Foundation
import SwiftUI

class LoadViewModel: ObservableObject {
    @Published var chains: [Chain] = []
    @Published var cargoWeight: Double? = nil
    
    // G-factors for C-130
    let fwdG: Double = 3.0
    let aftG: Double = 1.5
    let latG: Double = 1.5
    let vertUpG: Double = 2.0
    let vertDownG: Double = 4.5  // Optional, for completeness
    
    // Total provided restraints
    var totalFwd: Double { chains.reduce(0) { $0 + $1.fwdRestraint } }
    var totalAft: Double { chains.reduce(0) { $0 + $1.aftRestraint } }
    var totalVert: Double { chains.reduce(0) { $0 + $1.vertRestraint } }
    var totalLat: Double { chains.reduce(0) { $0 + $1.latRestraint } }
    
    // Required restraints
    var reqFwd: Double { (cargoWeight ?? 0) * fwdG }
    var reqAft: Double { (cargoWeight ?? 0) * aftG }
    var reqLat: Double { (cargoWeight ?? 0) * latG }
    var reqVertUp: Double { (cargoWeight ?? 0) * vertUpG }
    var reqVertDown: Double { (cargoWeight ?? 0) * vertDownG }
    
    func addChain() {
        chains.append(Chain())
    }
    
    func reset() {
            chains = []
            cargoWeight = nil
        }
    }
    
