import Foundation
import Supabase

class SupabaseService {
    static let shared = SupabaseService()
    private let client = SupabaseManager.shared.client
    
    private init() {}
    
    func fetchAllUsers(completion: @escaping (Result<[UserModel], AppError>) -> Void) {
        Task {
            do {
                let users: [UserModel] = try await client
                    .from("users")
                    .select("*, photos(*)")
                    .execute()
                    .value
                DispatchQueue.main.async {
                    completion(.success(users))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    
    func fetchMatches(for userId: Int, completion: @escaping (Result<[UserModel], AppError>) -> Void) {
        Task {
            do {
                let matches: [Match] = try await client
                    .from("matches")
                    .select("*, user1:users!matches_user1_id_fkey(*), user2:users!matches_user2_id_fkey(*)")
                    .or("user1_id.eq.\(userId),user2_id.eq.\(userId)")
                    .execute()
                    .value
                
                let matchedUsers = matches.map { $0.user1Id == userId ? $0.user2 : $0.user1 }
                
                DispatchQueue.main.async {
                    completion(.success(matchedUsers))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
}
