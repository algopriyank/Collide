import Foundation

class HomeViewModel: ObservableObject {
    @Published var users: [UserModel] = []
    @Published var errorMessage: String?
    @Published var errorIcon: String = ""
    
    func fetchUsers() {
        WebService.shared.fetchAllUsers { result in
            switch result {
            case .success(let users):
                self.users = users
                self.errorMessage = nil
            case .failure(let error):
                error.logDetails() // Logs full detail in console
                self.errorMessage = error.userMessage
                self.errorIcon = error.iconName
            }
        }
    }
}
