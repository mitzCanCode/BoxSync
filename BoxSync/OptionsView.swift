//
//  OptionsView.swift
//  BoxSync
//
//  Created by Alex Amygdalios on 21/11/24.
//

import SwiftUI

struct OptionsView: View {

    @State private var roundMinutes = 0
    @State private var roundSeconds = 0
    @State private var restMinutes = 0
    @State private var restSeconds = 0
    @State private var showAlert = false
    
    @Binding var areOptionsVisible: Bool
    @Binding var roundTime: Int
    @Binding var restTime: Int
    @Binding var sets: Int
    
    var resetTimer: () -> Void
    
    func saveChanges() {
        roundTime = roundMinutes * 60 + roundSeconds
        restTime = restMinutes * 60 + restSeconds
        resetTimer() // Reset timer on main View to update values
        areOptionsVisible = false
    }
    
    var body: some View {
                VStack{
                    Text("Timer options")
                        .padding(.top, 40)
                        .font(.title)
                        .bold()
                    
                    VStack{
                        Text("Round time")
                            .font(.headline)
                            .padding()
                        HStack {
                            Picker("Minutes", selection: $roundMinutes) {
                                ForEach(0...59, id: \.self) { minute in
                                    Text("\(minute)").tag(minute)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 100, height: 150)
                            .clipped()
                            .labelsHidden()
                            
                            Text(":")
                            Picker("Seconds", selection: $roundSeconds) {
                                ForEach(0...59, id: \.self) { second in
                                    Text("\(second)").tag(second)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 100, height: 150)
                            .clipped()
                            .labelsHidden()
                        }
                    }
                    .background(Color.red
                        .cornerRadius(10))
                    .padding()
                    .shadow(radius: 10)
                    
                    
                    
                    VStack{
                        Text("Rest time")
                            .font(.headline)
                            .padding()
                        HStack {
                            Picker("Minutes", selection: $restMinutes) {
                                ForEach(0...59, id: \.self) { minute in
                                    Text("\(minute)").tag(minute)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 100, height: 150)
                            .clipped()
                            .labelsHidden()
                            
                            Text(":")
                            
                            Picker("Seconds", selection: $restSeconds) {
                                ForEach(0...59, id: \.self) { second in
                                    Text("\(second)").tag(second)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                            .frame(width: 100, height: 150)
                            .clipped()
                            .labelsHidden()
                        }
                    }
                    .shadow(radius: 10)
                    .background(Color.blue
                        .cornerRadius(10))
                    .padding()
                    
                    // button to save changes
                    Button(action: saveChanges) {
                        Label("Save", systemImage: "checkmark")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green
                                .cornerRadius(30))
                            .shadow(radius: 10)
                    }
                }
            }
        }
//
//#Preview {
//    OptionsView()
//}
