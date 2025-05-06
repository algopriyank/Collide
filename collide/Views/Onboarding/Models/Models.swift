import SwiftUI

// MARK: - Enum & Structs

enum CurrentView {
    case actions
    case periods
    case nextView
    case keypad
    case phone
    case otp
    case email
    case personalDetails
    case genders
    case preferences
    case college
    case photos
    case bioTags
    case interests
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

struct Action: Identifiable {
    let id = UUID()
    let image: String
    let title: String
}

struct Period: Identifiable {
    let id = UUID()
    let title: String
    let value: Int
}

struct KeyValue: Identifiable {
    let id = UUID()
    let title: String
    let isBack: Bool
}

// MARK: - Sample Data
let actions = [
    Action(image: "flame", title: "Boost"),
    Action(image: "star", title: "Super Like"),
    Action(image: "bolt", title: "Turbo Boost")
]

let periods = [
    Period(title: "1", value: 1),
    Period(title: "3", value: 3),
    Period(title: "6", value: 6),
    Period(title: "Custom", value: 0)
]

let keypadValues: [KeyValue] = {
    var values = (1...9).map { KeyValue(title: "\($0)", isBack: false) }
    values.append(KeyValue(title: "delete.left", isBack: true))
    values.append(KeyValue(title: "0", isBack: false))
    return values
}() 
