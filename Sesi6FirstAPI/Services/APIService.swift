//
//  APIService.swift
//  Sesi6FirstAPI
//
//  Created by MacBook Pro on 19/04/24.
//

import Foundation

class APIService {
    static let shared = APIService()
    
    private init() {}
    
    func fetchJokeServices() async throws -> Joke {
        let urlString = URL(string: Constants.jokeAPI)
        
        guard let url = urlString else {
            print("😡 ERROR: Could not convert \(String(describing: urlString)) to a URL")
            
            throw URLError(.badURL)
        }
        
        print("🕸️ We are accessing the url \(url)")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResonse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(httpResonse.statusCode) else {
            throw URLError(.init(rawValue: httpResonse.statusCode))
        }
        
        let joke = try JSONDecoder().decode(Joke.self, from: data)
        return joke
        
    }
}

/// Kenapa pakai class?
/// 1. Untuk memastikan bahwa hanya ada satu objek (instance) bersama (shared)
/// yang akan digunakan di seluruh aplikasi. Konsep ini disebut dengan singleton
///
/// 2. Jadi, nanti setiap ada perubaha State di bagian lain dari aplikasi kita,
/// statenya akan sama. Seperti konsel mobil yang dirubah warnanya tadi.
///
/// 3. Cara pemanggilannya, APISerivice.shared
/// 4. Untuk mencegah agar si objeck APIService tidak di re-create dilar kelas ini
