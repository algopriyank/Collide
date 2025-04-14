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
    
    var errorIcon: String {
        if errorMessage?.contains("Internet") == true {
            return "wifi.exclamationmark"
        } else if errorMessage?.contains("Invalid URL") == true {
            return "link.badge.minus"
        } else {
            return "exclamationmark.triangle.fill"
        }
    }
    
    func fetchUsers() {
        WebService.shared.fetchAllUsers { result in
            switch result {
            case .success(let users):
                self.users = users
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
