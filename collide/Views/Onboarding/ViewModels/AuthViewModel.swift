import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var errorMessage: String? = nil
    @Published var currentView: CurrentView = .welcome
    @Published var phoneNumber: String = ""
    @Published var otp: String = ""
    @Published var emailLoginStarted = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var dob: Date = Date()
    @Published var birthdayText: String = "" {
        didSet {
            if let date = parseBirthday(birthdayText) {
                dob = date
            }
        }
    }
    @Published var showBirthdayPublicly: Bool = true
    @Published var gender: String = ""
    @Published var pronouns: String = ""
    @Published var showGenderPicker: Bool = false
    @Published var selectedPronoun: String = "he/him"
    @Published var interestedIn: String = ""
    @Published var lookingFor: String = ""
    @Published var collegeName: String = ""
    @Published var registrationNumber: String = ""
    @Published var location: String = ""
    @Published var selectedImages: [UIImage?] = Array(repeating: nil, count: 6)
    @Published var showingImagePicker = false
    @Published var selectedImageIndex: Int? = nil
    @Published var tempImage: UIImage? = nil
    @Published var bio: String = ""
    @Published var selectedInterests: Set<String> = []
    @Published var allInterests: [Interest] = []
    @Published var funQuestionAnswers: [String: String] = [:]
    @Published var onboardingComplete: Bool {
        didSet {
            UserDefaults.standard.set(onboardingComplete, forKey: "onboardingComplete")
        }
    }
    
    init() {
        self.onboardingComplete = UserDefaults.standard.bool(forKey: "onboardingComplete")
    }
    
    // Events/Callbacks
    var onCloseTray: (() -> Void)?
    
    let pronounOptions = ["he/him", "she/her", "they/them"]
    let genderOptions = ["Woman", "Man", "Non-binary"]
    
    func parseBirthday(_ text: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.isLenient = false
        
        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard cleanText.count == 10 else { return nil }
        return formatter.date(from: cleanText)
    }
    
    // Function to close the tray
    func closeTray() {
        onCloseTray?()
    }
    
    // Function to process keypad input for phone
    func processPhoneKeypad(value: KeyValue) {
        if value.isBack {
            if !phoneNumber.isEmpty {
                phoneNumber.removeLast()
            }
        } else {
            if phoneNumber.count < 10 {
                phoneNumber.append(value.title)
            }
        }
    }
    
    // Function to process keypad input for OTP
    func processOTPKeypad(value: KeyValue) {
        if value.isBack {
            if !otp.isEmpty {
                otp.removeLast()
            }
        } else {
            if otp.count < 6 {
                otp.append(value.title)
            }
        }
    }
    
    // Function to toggle interest selection
    func toggleInterest(_ interest: String) {
        if selectedInterests.contains(interest) {
            selectedInterests.remove(interest)
        } else {
            selectedInterests.insert(interest)
        }
    }
    
    // Function to reset email login
    func resetEmailLogin() {
        email = ""
        password = ""
        emailLoginStarted = false
    }
    
    // Function to handle image selection
    func selectImage(at index: Int) {
        selectedImageIndex = index
        showingImagePicker = true
    }
    
    // Function to remove image
    func removeImage(at index: Int) {
        selectedImages[index] = nil
    }
    
    // Function to apply selected image
    func applySelectedImage() {
        if let temp = tempImage, let index = selectedImageIndex {
            selectedImages[index] = temp
            tempImage = nil
        }
    }
    
    // Function to check if continue button should be enabled
    func isContinueEnabled(for view: CurrentView) -> Bool {
        switch view {
        case .phone:
            return phoneNumber.count == 10
        case .otp:
            return otp.count == 6
        case .email:
            if emailLoginStarted {
                return !email.isEmpty && !password.isEmpty
            }
            return !email.isEmpty
        case .personalDetails:
            return !name.isEmpty && !gender.isEmpty && parseBirthday(birthdayText) != nil
        case .photos:
            return selectedImages.contains(where: { $0 != nil })
        case .BioInterests:
            return selectedInterests.count >= 5
        default:
            return true
        }
    }
} 

import Supabase

extension AuthViewModel {
    @MainActor
    func signInWithEmail() async {
        do {
            try await SupabaseManager.shared.client.auth.signIn(email: email, password: password)
            currentView = .personalDetails  // ✅ Go to personalDetails on success
            errorMessage = nil
        } catch {
            print("Sign-in error: \(error.localizedDescription)")
            errorMessage = error.localizedDescription  // ❌ Show error
        }
    }
    
    @MainActor
    func signUpWithEmail() async {
        do {
            try await SupabaseManager.shared.client.auth.signUp(email: email, password: password)
            currentView = .personalDetails  // ✅ Go to personalDetails on success
            errorMessage = nil
        } catch {
            print("Sign-up error: \(error.localizedDescription)")
            errorMessage = error.localizedDescription  // ❌ Show error
        }
    }
}
