//
//  ContentView.swift
//  Sesi6FirstAPI
//
//  Created by Hidayat Abisena on 28/01/24.
//

import SwiftUI

struct CardView: View {
    @State private var fadeIn: Bool = false
    @State private var moveDownward: Bool = false
    @State private var moveUpward: Bool = false
    @State private var soundNumber = 7
    let totalSounds = 25
    
    @State private var showPunchline: Bool = false
    
    @StateObject private var jokeVM = JokeVM()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    
                    // MARK: - Setup Text
                    Text(Constants.setupText)
                        .foregroundStyle(.white)
                        .font(.custom("PermanentMarker-Regular", size: 30))
                        .padding(.top)
                    
                    
                    // MARK: - Setup Jokes
                    Text(jokeVM.joke?.setup ?? Constants.noJokes)
                        .foregroundStyle(.white)
                        .fontWeight(.light)
                        .italic()
                        .padding(.horizontal)
                }
                .offset(y: moveDownward ? -218 : -300)
                
                // MARK: - Punchline
                if showPunchline {
                    Text(jokeVM.joke?.punchline ?? Constants.noPunchline)
                        .foregroundStyle(.white)
                        .font(.custom("PermanentMarker-Regular", size: 35))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // MARK: - Button
                if showPunchline {
                    Button {
                        performPunchlineAction()
                    } label: {
                        HStack {
                            Text("DISABLED".uppercased())
                                .fontWeight(.heavy)
                                .foregroundStyle(.white)
                        }
                        .padding(.vertical)
                        .padding(.horizontal, 24)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [.black, .black]), startPoint: .leading, endPoint: .trailing)
                        )
                        .clipShape(Capsule())
                        .shadow(color: Color("ColorShadow"), radius: 6, x: 0, y: 3)
                    }
                    .offset(y: moveUpward ? 210 : 300)
                    .disabled(showPunchline)
                } else {
                Button {
                    performPunchlineAction()
                } label: {
                    HStack {
                        Text("Punchline".uppercased())
                            .fontWeight(.heavy)
                            .foregroundStyle(.white)
                        
                        Image(systemName: "arrow.right.circle")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                    }
                    .padding(.vertical)
                    .padding(.horizontal, 24)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.color07, Color.color08]), startPoint: .leading, endPoint: .trailing)
                    )
                    .clipShape(Capsule())
                    .shadow(color: Color("ColorShadow"), radius: 6, x: 0, y: 3)
                }
                .offset(y: moveUpward ? 210 : 300)
//                .disabled(showPunchline)
            }
        }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await jokeVM.fetchJoke()
                            showPunchline = false
                        }
                    } label : {
                        Image(systemName: "arrow.clockwise")
                            .foregroundStyle(.white)
                            .padding()
                            .background(LinearGradient(gradient:Gradient(colors:[Color.color07,Color.color08]), startPoint: .leading, endPoint: .trailing)
                            )
                            .clipShape(Circle())
                    }
                }
            }
            
            .task {
                await jokeVM.fetchJoke()
            }
            .frame(width: 335, height: 545)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.color01, Color.color06]), startPoint: .top, endPoint: .bottom)
            )
            .opacity(fadeIn ? 1.0 : 0.0)
            .onAppear() {
              withAnimation(.linear(duration: 1.2)) {
                self.fadeIn.toggle()
              }
                
              withAnimation(.linear(duration: 0.6)) {
                self.moveDownward.toggle()
                self.moveUpward.toggle()
              }
            }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    CardView()
}

// MARK: - EXTENSION

extension CardView {
    func performPunchlineAction() {
        playSound(soundName: "\(soundNumber)")
        soundNumber += 1
        if soundNumber > totalSounds {
            soundNumber = 0
        }
        showPunchline.toggle()
        
    }
}
