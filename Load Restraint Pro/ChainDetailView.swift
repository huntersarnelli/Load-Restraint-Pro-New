//
//  Untitled.swift
//  Load Restraint Pro
//
//  Created by Hunter Sarnelli on 8/25/25.
//
import SwiftUI

struct ChainDetailView: View {
    @Binding var chain: Chain
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused: Bool
    let onDelete: () -> Void
    let onDuplicateSymmetric: (Chain) -> Void
    
    var body: some View {
        Form {
            Section(header: Text("Instructions").font(.subheadline).foregroundColor(.secondary)) {
                Text("Enter Total Length, Longitudinal, and at least one of Vertical or Lateral. Leave the other as 0 to auto-calculate it using the Pythagorean theorem (minimal measurements required). If both provided, consistency will be checked.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Section(header: Text("Details")) {
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
            }
            
            //Section(header: Text("Measurements")) {
                //TextField("Total Length", value: $chain.totalLength, format: .number)
                //TextField("Longitudinal Component", value: $chain.longitudinal, format: .number)
                //TextField("Vertical Component (optional)", value: $chain._vertical, format: .number)
                //TextField("Lateral Component (optional)", value: $chain._lateral, format: .number)
            //}
            
            Section(header: Text("Chain Measurements")) {
                HStack {
                    Text("Total Length:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("0", value: $chain.totalLength, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .focused($isFocused)
                }
                HStack {
                    Text("Longitudinal:")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("0", value: $chain.longitudinal, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .focused($isFocused)
                }
                HStack {
                    Text("Vertical (opt):")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("0", value: $chain._vertical, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .focused($isFocused)
                }
                HStack {
                    Text("Lateral (opt):")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("0", value: $chain._lateral, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        .focused($isFocused)
                }
            }
            
            
            if chain.vertical > 0 || chain.lateral > 0 {
                Section(header: Text("Computed Values")) {
                    if chain._vertical == 0 {
                        Text("Calculated Vertical: \(String(format: "%.2f", chain.vertical))")
                    } else {
                        Text("Vertical: \(String(format: "%.2f", chain.vertical)) (from input)")
                    }
                    if chain._lateral == 0 {
                        Text("Calculated Lateral: \(String(format: "%.2f", chain.lateral))")
                    } else {
                        Text("Lateral: \(String(format: "%.2f", chain.lateral)) (from input)")
                    }
                }
            }
            
            if !chain.warning.isEmpty {
                Text(chain.warning).foregroundColor(.red)
            }
            
            Section {
                Button("Duplicate Symmetric") {
                    let duplicate = Chain(
                        name: "\(chain.name) (Lat Sym)",
                        strength: chain.strength,
                        totalLength: chain.totalLength,
                        longitudinal: chain.longitudinal,
                        _vertical: chain._vertical,
                        _lateral: chain._lateral,
                        direction: chain.direction
                    )
                    onDuplicateSymmetric(duplicate)
                    dismiss()
                }
                .foregroundColor(.blue)
                
                Button("Delete Chain") {
                    onDelete()
                    dismiss()
                }
                .foregroundColor(.red)
            }
        }
        .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
                            isFocused = false
                        }
                    }
                }
        .navigationTitle(chain.name)
        .navigationBarTitleDisplayMode(.inline)  // Cleaner title
    }
}
