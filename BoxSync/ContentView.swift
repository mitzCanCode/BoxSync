//
//  ContentView.swift
//  BoxSync
//
//  Created by Dimitris Chatzigeorgiou on 19/11/24.
//

import SwiftUI
import AVFoundation

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
    @State var areOptionsVisible: Bool = false
    
    
    func resetTimer() {
        paused = true
        time = resting ? restTime : roundTime
    }
    
    func playSound(soundName: String) {
        SoundManager.shared.playSound(named: soundName)
    }

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                    .edgesIgnoringSafeArea(.all)
                    .overlay(.regularMaterial)
                VStack {
                    Spacer() // Move content to the center of the screen
                    Text("\(resting ? "Resting" : "Boxing")")
                    Text("Round: \(sets)")
                    Text("\(time)")
                    Text("\(time / 60):\(time % 60 >= 10 ? "\(time % 60)" : "0\(time % 60)")")
                        .font(.system(size: 140))
                        .fontDesign(.monospaced)
                        .fontWeight(.semibold)
                        .kerning(1.2)
                        .foregroundStyle(resting ? .blue : .red)
                        .onReceive(timer) { _ in
                            if (time > 0) && (!paused) && (sets <= setLimiter) {
                                time -= 1
                            } else if (time == 0) && (sets < setLimiter) {
                                resting.toggle()
                                if resting {
                                    time = restTime
                                    playSound(soundName: "bell") // Play bell sound when rest starts
                                } else {
                                    time = roundTime
                                    sets += 1
                                    playSound(soundName: "bell") // Play a bell sound when rest is over
                                }
                            } else if !(paused) {
                                workoutFinished.toggle()
                                paused = true
                                sets = 1
                                time = roundTime
                                resting = false
                            }
                            if (time == 5) && (!paused){
                                playSound(soundName: "fiveSec")
                            }
                        }

                    // Main container for all action buttons
                    VStack {
                        // Container for pausing and resetting time buttons
                        HStack {
                            // Pause button
                            Button(action: {
                                if !(sets == 1 && time == roundTime) {
                                    paused.toggle()
                                } else {
                                    paused = false
                                }
                            }, label: {
                                if !(sets == 1 && time == roundTime) {
                                    Text("\(paused ? "Resume" : "Pause")")
                                        .modifier(glassText())
                                } else {
                                    Text("Start")
                                        .modifier(glassText())
                                }
                            })

                            // Time Reset Button
                            Button(action: {
                                resetTimer()
                            }, label: {
                                Text("Reset")
                                    .modifier(glassText())
                            })
                        }

                        // Container for adding and removing 15 seconds buttons
                        HStack {
                            if !(time == roundTime) {
                                // Remove 15 seconds
                                Button(action: {
                                    if ((time - 15) >= 0) {
                                        time -= 15
                                    } else {
                                        time = 0
                                    }
                                }, label: {
                                    Text("Remove 15 seconds")
                                        .modifier(glassText())
                                })

                                // Add 15 seconds
                                Button(action: {
                                    time += 15
                                }, label: {
                                    Text("Add 15 seconds")
                                        .modifier(glassText())
                                })
                            }
                        }
                    }

                    Spacer() // Pushes the button to the bottom

                    // Navigation button to OptionsView
                    Button(action: { areOptionsVisible.toggle()}) {
                        Text("Options")
                            .modifier(glassText())
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20) // Adds spacing from the bottom edge
                    .sheet(isPresented: $areOptionsVisible) {
                        OptionsView(areOptionsVisible: $areOptionsVisible, roundTime: $roundTime, restTime: $restTime, sets: $sets, resetTimer: resetTimer)
                        }
                }
                .alert(isPresented: $workoutFinished) {
                    Alert(
                        title: Text("Workout Completed"),
                        dismissButton: .default(
                            Text("OK"),
                            action: { workoutFinished = false }
                        )
                    )
                }
                .onAppear {
                    roundTimeStr = "100"
                    restTimeStr = "60"

                    roundTime = Int(roundTimeStr) ?? 100
                    restTime = Int(restTimeStr) ?? 60
                    setLimiter = 3
                }
            }
        }
    }
}

class SoundManager {
    static let shared = SoundManager()
    var player: AVAudioPlayer?

    func playSound(named soundName: String) {
        if let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        } else {
            print("Sound file not found.")
        }
    }
}


#Preview {
    ContentView()
}
