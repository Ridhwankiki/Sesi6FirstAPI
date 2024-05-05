//
//  JokeVM.swift
//  Sesi6FirstAPI
//
//  Created by MacBook Pro on 19/04/24.
//

import Foundation

@MainActor
class JokeVM: ObservableObject {
    @Published var joke: Joke?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    
    func fetchJoke() async {
        isLoading = true
        errorMessage = nil
        
        do {
//            let fetchedJoke = try await APIService.shared.fetchJokeServices()
//            joke = fetchedJoke
            joke = try await APIService.shared.fetchJokeServices()
            print("Setup: \(joke?.setup ?? "No Setup")")
            print("Punchline: \(joke?.punchline ?? "No Punchline")")
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            print("ERRPR: could not get data from UR: \(Constants.jokeAPI).\(error.localizedDescription)")
        }
        
    }
}
