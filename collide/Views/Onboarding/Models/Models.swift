import SwiftUI

// MARK: - Enum & Structs

enum CurrentView {
    case login
    case nextView
    case phone
    case otp
    case email
    case personalDetails
    case genders
    case preferences
    case college
    case photos
    case BioInterests
    case funQuestions
    case finalScreen
}

struct TrayConfig {
    var maxDetent: PresentationDetent = .fraction(0.99)
    var cornerRadius: CGFloat = 30
    var horizontalPadding: CGFloat = 15
    var bottomPadding: CGFloat = 0
    var isInteractiveDismissDisabled: Bool = false
}

struct KeyValue: Identifiable {
    let id = UUID()
    let title: String
    let isBack: Bool
}

// MARK: - Sample Data

let keypadValues: [KeyValue] = {
    var values = (1...9).map { KeyValue(title: "\($0)", isBack: false) }
    values.append(KeyValue(title: "delete.left", isBack: true))
    values.append(KeyValue(title: "0", isBack: false))
    return values
}() 
