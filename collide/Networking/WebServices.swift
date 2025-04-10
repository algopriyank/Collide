import Foundation

class WebService {
    static let shared = WebService()
    private init() {}
    
    private let baseURL = "https://elxkzdrcyloubqhwiuuu.supabase.co/rest/v1/"
    private let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVseGt6ZHJjeWxvdWJxaHdpdXV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM5MzI2MDEsImV4cCI6MjA1OTUwODYwMX0.835jbXGwqRA8aSI6LIiczBshfOOYUBRrZNnhHgRmlcM" // Keep this secure
    
    private var defaultHeaders: [String: String] {
        [
            "apikey": apiKey,
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
    }
    
    // MARK: - Fetch All Users
    func fetchAllUsers(completion: @escaping (Result<[UserModel], Error>) -> Void) {
        guard let url = URL(string: baseURL + "users?select=*,photos(*)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        defaultHeaders.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }
            
            guard let data = data else {
                return completion(.failure(NetworkError.noData))
            }
            
            do {
                let users = try JSONDecoder().decode([UserModel].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(users))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
        // You can add more endpoints below:
        // - fetchUser(by id)
        // - fetchMatches(for userId)
        // - sendSwipe(...)
        // - submitReview(...)
}

// MARK: - Network Errors
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .noData: return "No data received from server"
        }
    }
}
