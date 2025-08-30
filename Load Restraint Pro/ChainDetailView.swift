//
//  Untitled.swift
//  Load Restraint Pro
//
//  Created by Hunter Sarnelli on 8/25/25.
//

import SwiftUI

struct ChainDetailView: View {
    @Binding var chain: Chain
    
    var body: some View {
        Form {
            Section(header: Text("Instructions: Enter Total Length, Longitudinal, and at least one of Vertical or Lateral. Leave the other as 0 to auto-calculate it using the Pythagorean theorem (minimal measurements required). If both provided, consistency will be checked.")) {
                // Empty; just header text
            }
            
            TextField("Name", text: $chain.name)
            Picker("Strength (lbs)", selection: $chain.strength) {
                Text("5,000").tag(5000.0)
                Text("10,000").tag(10000.0)
                Text("25,000").tag(25000.0)
            }
            Picker("Restraint Direction", selection: $chain.direction) {
                Text("Forward").tag("Forward")
                Text("Aft").tag("Aft")
            }
            TextField("Total Length", value: $chain.totalLength, format: .number)
            TextField("Longitudinal Component", value: $chain.longitudinal, format: .number)
            TextField("Vertical Component (optional)", value: $chain._vertical, format: .number)
            TextField("Lateral Component (optional)", value: $chain._lateral, format: .number)
            
            if chain.vertical > 0 || chain.lateral > 0 {
                Section(header: Text("Computed Values (used in restraints)")) {
                    if chain._vertical == 0 {
                        Text("Calculated Vertical: \(chain.vertical, specifier: "%.2f")")
                    } else {
                        Text("Vertical: \(chain.vertical, specifier: "%.2f") (from input)")
                    }
                    if chain._lateral == 0 {
                        Text("Calculated Lateral: \(chain.lateral, specifier: "%.2f")")
                    } else {
                        Text("Lateral: \(chain.lateral, specifier: "%.2f") (from input)")
                    }
                }
            }
            
            if !chain.warning.isEmpty {
                Text(chain.warning).foregroundColor(.red)
            }
        }
        .navigationTitle(chain.name)
    }
}
