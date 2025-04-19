    // Update your imports
import Foundation

class WebService {
    static let shared = WebService()
    private init() {}
    
    private let baseURL = "https://elxkzdrcyloubqhwiuuu.supabase.co/rest/v1/"
    private let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVseGt6ZHJjeWxvdWJxaHdpdXV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM5MzI2MDEsImV4cCI6MjA1OTUwODYwMX0.835jbXGwqRA8aSI6LIiczBshfOOYUBRrZNnhHgRmlcM"
    
    private var defaultHeaders: [String: String] {
        [
            "apikey": apiKey,
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
    }
    
    func fetchAllUsers(completion: @escaping (Result<[UserModel], AppError>) -> Void) {
        guard let url = URL(string: baseURL + "users?select=*,photos(*)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        defaultHeaders.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error as? URLError {
                switch error.code {
                case .notConnectedToInternet:
                    completion(.failure(.noInternet))
                case .timedOut:
                    completion(.failure(.timeout))
                default:
                    completion(.failure(.underlying(error)))
                }
                return
            }
            
            if let error = error {
                completion(.failure(.underlying(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let users = try JSONDecoder().decode([UserModel].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(users))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(error)))
                }
            }
        }.resume()
    }
    
    func fetchMatches(for userId: Int, completion: @escaping (Result<[UserModel], AppError>) -> Void) {
        let query = "matches?or=(user1_id.eq.\(userId),user2_id.eq.\(userId))&select=*,user1:users!matches_user1_id_fkey(*),user2:users!matches_user2_id_fkey(*)"
        
        guard let url = URL(string: baseURL + query) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        defaultHeaders.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.underlying(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let matches = try JSONDecoder().decode([Match].self, from: data)
                let matchedUsers = matches.map { $0.user1Id == userId ? $0.user2 : $0.user1 }
                DispatchQueue.main.async {
                    completion(.success(matchedUsers))
                }
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }.resume()
    }
}
