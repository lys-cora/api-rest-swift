enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed(Error)
    case invalidData
    case decodingFailed(Error)
}

struct User: Codable {
    let name: String
    let email: String
}

func postUser(user: User, completion: @escaping (Result<Void, NetworkError>) -> Void) {
    guard let url = URL(string: "https://example.com/users") else {
        completion(.failure(.invalidURL))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    do {
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(user)
    } catch {
        completion(.failure(.requestFailed(error)))
        return
    }

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(.requestFailed(error)))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            completion(.failure(.invalidResponse))
            return
        }

        guard let data = data else {
            completion(.failure(.invalidData))
            return
        }

        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(Void.self, from: data)
            completion(.success(response))
        } catch {
            completion(.failure(.decodingFailed(error)))
        }
    }

    task.resume()
}
