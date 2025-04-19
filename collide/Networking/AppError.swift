import Foundation

enum AppError: LocalizedError, Identifiable {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(statusCode: Int)
    case noInternet
    case timeout
    case underlying(Error)
    case custom(String)
    
    var id: String {
        return localizedDescription
    }
    
        /// Message for the user
    var userMessage: String {
        switch self {
        case .invalidURL:
            return "Oops! The link seems to be broken."
        case .noData:
            return "No data received. Please try again later."
        case .decodingError:
            return "We couldn't read the data properly."
        case .serverError(let code):
            return "Server responded with error code \(code)."
        case .noInternet:
            return "No Internet Connection. Please check your Wi-Fi or mobile data."
        case .timeout:
            return "The request timed out. Try again."
        case .underlying:
            return "Something went wrong. Try again."
        case .custom(let message):
            return message
        }
    }
    
        /// SF Symbol for each error type
    var iconName: String {
        switch self {
        case .invalidURL: return "link.badge.plus"
        case .noData: return "tray.fill"
        case .decodingError: return "doc.text.magnifyingglass"
        case .serverError: return "server.rack"
        case .noInternet: return "wifi.slash"
        case .timeout: return "timer"
        case .underlying: return "exclamationmark.triangle.fill"
        case .custom: return "bolt.fill"
        }
    }
    
        /// Console-level debug logging
    func logDetails(from function: String = #function) {
        print("❌ [AppError] in \(function):")
        switch self {
        case .decodingError(let error):
            print("Decoding Error →", error)
        case .serverError(let code):
            print("Server Error → Code: \(code)")
        case .custom(let message):
            print("Custom Error →", message)
        case .underlying(let error):
            print("Underlying Error →", error.localizedDescription)
        case .noInternet, .timeout, .invalidURL, .noData:
            print(self.localizedDescription)
        }
    }
}
