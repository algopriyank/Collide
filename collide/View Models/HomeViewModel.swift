//
//  HomeViewModel.swift
//  collide
//
//  Created by Priyank Sharma on 07/04/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var users: [UserModel] = []
    @Published var errorMessage: String?
    
    func fetchUsers() {
        WebService.shared.fetchAllUsers { result in
            switch result {
            case .success(let fetchedUsers):
                self.users = fetchedUsers
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
