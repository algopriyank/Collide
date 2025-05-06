import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var currentView: CurrentView = .actions
    @Published var selectedAction: Action? = nil
    @Published var selectedPeriod: Period? = nil
    @Published var duration: String = ""
    @Published var phoneNumber: String = ""
    @Published var otp: String = ""
    @Published var emailLoginStarted = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var dob: Date = Date()
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
    @Published var selectedTags: Set<String> = []
    @Published var selectedInterests: Set<String> = []
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
    
    let pronounOptions = ["he/him", "she/her", "they/them", "ze/zir", "prefer not to say"]
    let genderOptions = ["Male", "Female", "Non-binary", "Other", "Prefer not to say"]
    
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
    
    // Function to process keypad input for duration
    func processDurationKeypad(value: KeyValue) {
        if value.isBack {
            if !duration.isEmpty {
                duration.removeLast()
            }
        } else {
            duration.append(value.title)
        }
    }
    
    // Function to toggle tag selection
    func toggleTag(_ tag: String) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
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
            return !name.isEmpty && !gender.isEmpty
        case .photos:
            return selectedImages.contains(where: { $0 != nil })
        case .interests:
            return selectedInterests.count >= 5
        default:
            return true
        }
    }
} 
