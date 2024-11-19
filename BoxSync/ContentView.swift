//
//  ContentView.swift
//  BoxSync
//
//  Created by Dimitris Chatzigeorgiou on 19/11/24.
//

import SwiftUI

struct ContentView: View {
    @State var roundTime: Int = 0
    @State var restTime: Int = 0
    @State var roundTimeStr: String = "0"
    @State var restTimeStr: String = "0"
    @State var sets: Int = 1
    @State var setLimiter: Int = 0
    @State var time: Int = 100
    @State var paused: Bool = true
    @State var resting: Bool = false
    @State var workoutFinished: Bool = false


    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        VStack {
            Text("\(resting ? "Resting" : "Boxing")")
            Text("Round: \(sets)")
            Text("\(time)")
                .foregroundStyle(resting ? .blue : .red)
                .onReceive(timer) { _ in
                    // Remove time only when not paused, time is larger than 0, sets are less or equal to the number of total rounds
                    if (time > 0) && (!paused) && (sets <= setLimiter) {
                        time -= 1
                    } else if (time == 0) && (sets < setLimiter) {
                        resting.toggle()
                        if resting {
                            time = restTime
                        } else {
                            time = roundTime
                            sets += 1
                        }
                        
                    } else if !(paused){
                        workoutFinished.toggle()
                        paused = true
                        sets = 1
                        time = roundTime
                        resting = false                    }
                }
            
            // Main container for all action buttons
            VStack{
                
                // Container for pausing and reseting time buttons
                HStack{
                    // Pause button
                    Button(action:{
                        if !(sets == 1 && time == roundTime) {
                            paused.toggle()
                        } else {
                            paused = false
                        }
                    }, label: {
                        if !(sets == 1 && time == roundTime) {
                            Text("\(paused ? "Resume" : "Pause")")
                        } else {
                            Text("Start")
                        }
                    }
                    )
                    
                    // Time Reset Button
                    Button(action:{
                        
                        time = resting ? restTime : roundTime
                    }, label: {
                        Text("Reset")
                    }
                    )
                }
                
                // Container for adding and removing 15 seconds buttons
                HStack{
                    
                    // Remove 15 seconds
                    Button(action:{
                        if ((time - 15) >= 0){
                            time -= 15
                        } else {
                            time = 0
                        }
                    }, label: {
                            Text("Remove 15 seconds")
                    }
                    )
                    
                    // Add 15 seconds
                    Button(action:{
                        time += 15
                    }, label: {
                        Text("Add 15 seconds")
                    }
                    )
                    
                }
                
            }
        }
        .alert(isPresented: $workoutFinished){
            Alert(
                title: Text("Workout Completed"),
                dismissButton: .default(
                    Text("OK"),
                    action: {workoutFinished = false}
                )
                )
        }
        .onAppear{
            roundTimeStr = "100"
            restTimeStr = "60"
            
            roundTime = Int(roundTimeStr) ?? 100
            restTime = Int(restTimeStr) ?? 60
            setLimiter = 3
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
