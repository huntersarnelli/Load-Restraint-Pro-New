//
//  ContentView.swift
//  Load Restraint Pro
//
//  Created by Hunter Sarnelli on 8/25/25.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = LoadViewModel()
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {  // Increased spacing for professionalism
                //TextField("Cargo Weight (lbs)", value: $viewModel.cargoWeight, format: .number)
                HStack {
                    Text("Cargo Weight (lbs):")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    TextField("0", value: $viewModel.cargoWeight, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .focused($isFocused)// Or .decimalPad if decimals are needed
                    }
                .padding(.horizontal)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                List {
                    ForEach($viewModel.chains) { $chain in
                        NavigationLink(destination: ChainDetailView(chain: $chain, onDelete: {
                            viewModel.chains.removeAll { $0.id == chain.id }
                        }, onDuplicateSymmetric: { newChain in
                            viewModel.chains.append(newChain)
                        })) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(chain.name) (\(chain.direction))")
                                    .font(.headline)
                                Text("Fwd \(String(format: "%.0f", chain.fwdRestraint)) | Aft \(String(format: "%.0f", chain.aftRestraint)) | Vert \(String(format: "%.0f", chain.vertRestraint)) | Lat \(String(format: "%.0f", chain.latRestraint))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                if !chain.warning.isEmpty {
                                    Text(chain.warning).foregroundColor(.red).font(.caption)
                                }
                            }
                        }
                    }
                    .onDelete { indices in viewModel.chains.remove(atOffsets: indices) }
                }
                .listStyle(.insetGrouped)  // Professional grouped look
                
                HStack(spacing: 20) {  // Buttons side-by-side for balance
                    Button(action: { viewModel.addChain() }) {
                        Label("Add Chain", systemImage: "plus.circle")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)  // Themed color
                    
                    Button(action: { viewModel.reset() }) {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
                .padding(.horizontal)
                
                Section(header: Text("Restraint Summary").font(.headline).padding(.top)) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible(), alignment: .trailing)], spacing: 8) {
                        Text("Direction")
                            .font(.subheadline).bold()
                        Text("Total / Required")
                            .font(.subheadline).bold()
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        
                        Text("Fwd")
                        Text("\(String(format: "%.0f", viewModel.totalFwd)) / \(String(format: "%.0f", viewModel.reqFwd))")
                            .foregroundColor(viewModel.totalFwd >= viewModel.reqFwd ? .green : .red)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        
                        Text("Aft")
                        Text("\(String(format: "%.0f", viewModel.totalAft)) / \(String(format: "%.0f", viewModel.reqAft))")
                            .foregroundColor(viewModel.totalAft >= viewModel.reqAft ? .green : .red)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        
                        Text("Vert Up")
                        Text("\(String(format: "%.0f", viewModel.totalVert)) / \(String(format: "%.0f", viewModel.reqVertUp))")
                            .foregroundColor(viewModel.totalVert >= viewModel.reqVertUp ? .green : .red)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        
                        Text("Lat (Per Direction)")
                        Text("\(String(format: "%.0f", viewModel.totalLat / 2)) / \(String(format: "%.0f", viewModel.reqLat))")
                            .foregroundColor((viewModel.totalLat / 2) >= viewModel.reqLat ? .green : .red)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        
                        //Text("Vert Down")
                        //Text("\(String(format: "%.0f", viewModel.totalVert)) / \(String(format: "%.0f", viewModel.reqVertDown))")  // Reuse totalVert for down
                            //.foregroundColor(viewModel.totalVert >= viewModel.reqVertDown ? .green : .red)
                            //.frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(8)
                    .shadow(radius: 2)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Load Restraint Pro")
            .toolbar {  // Add this toolbar
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    isFocused = false  // Dismiss keyboard
                                }
                            }
                        }
                    }
            .navigationViewStyle(.stack)
    }
}
