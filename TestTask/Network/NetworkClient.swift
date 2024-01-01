//
//  NetworkClient.swift
//  TestTask
//
//  Created by Александр Зарудний on 31.12.23.
//

import Foundation

final class NetworkClient {
    static let shared = NetworkClient()

    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()

    func fetchData<T: Decodable>(urlPath: String) async throws -> T {
        guard let url = URL(string: urlPath) else {
            throw URLError(.badURL)
        }
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try decoder.decode(T.self, from: data)
        return response
    }
}

extension URL {
    init(string: StaticString) {
        guard let url = URL(string: "\(string)") else {
            preconditionFailure("Invalid URL string: \(string)")
        }
        self = url
    }
}
