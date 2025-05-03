    //
    //  CustomSheet.swift
    //  collide
    //
    //  Created by Priyank Sharma on 04/05/25.
    //

import SwiftUI

    // MARK: - Tray Configuration

struct TrayConfig {
    var maxDetent: PresentationDetent = .fraction(0.99)
    var cornerRadius: CGFloat = 30
    var horizontalPadding: CGFloat = 15
    var bottomPadding: CGFloat = 0
    var isInteractiveDismissDisabled: Bool = false
}

    // MARK: - View Modifier Extension

extension View {
    @ViewBuilder
    func systemTrayView<Content: View>(
        _ show: Binding<Bool>,
        config: TrayConfig = TrayConfig(),
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self
            .sheet(isPresented: show) {
                content()
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius, style: .continuous))
                    .padding(.horizontal, config.horizontalPadding)
                    .padding(.bottom, config.bottomPadding)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .presentationDetents([config.maxDetent])
                    .presentationCornerRadius(0)
                    .presentationBackground(.clear)
                    .presentationDragIndicator(.hidden)
                    .interactiveDismissDisabled(config.isInteractiveDismissDisabled)
            }
    }
}

    // MARK: - Models

enum CurrentView {
    case actions
    case periods
    case keypad
    case phone
    case otp
    case email
    case personalDetails
    case genders
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

let keypadValues: [KeyValue] = {
    var values = (1...9).map { KeyValue(title: "\($0)", isBack: false) }
    values.append(KeyValue(title: "delete.left", isBack: true))
    values.append(KeyValue(title: "0", isBack: false))
    return values
}()

    // MARK: - Main View

struct ContentView: View {
    @State private var show = false
    @State private var currentView: CurrentView = .actions
    @State private var selectedAction: Action? = nil
    @State private var selectedPeriod: Period? = nil
    @State private var duration: String = ""
    @State private var phoneNumber: String = ""
    @State private var otp: String = ""
    @State private var emailLoginStarted = false
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @State private var dob: Date = Date()
    @State private var gender: String = ""
    @State private var pronouns: String = ""
    @State private var showGenderPicker: Bool = false
    @State private var selectedPronoun: String = "he/him"
    
    let pronounOptions = ["he/him", "she/her", "they/them", "ze/zir", "prefer not to say"]
    let genderOptions = ["Male", "Female", "Non-binary", "Other", "Prefer not to say"]
    
    var body: some View {
        VStack {
            Button("Show Tray View") {
                show.toggle()
            }
            .padding()
        }
        .systemTrayView($show) {
            VStack(spacing: 20) {
                ZStack {
                    switch currentView {
                    case .actions:
                        loginView()
                    case .phone:
                        phoneInputView()
                    case .email:
                        emailLoginView()
                    case .otp:
                        otpInputView()
                    case .personalDetails:
                        personalDetailsView()
                    case .genders:
                        genderView()
                    case .periods:
                        periodView()
                    case .keypad:
                        keypadView()
                    }
                }
                .compositingGroup()
                
                //continueButton()
            }
            .padding(20)
        }
    }
}

    // MARK: - Subviews

extension ContentView {
    
    func loginView() -> some View {
        VStack(spacing: 20) {
            header(title: "Login or Sign up") {
                show = false
            }
            
            VStack(spacing: 15) {
                Button {
                    withAnimation(.bouncy) {
                        currentView = .phone
                    }
                } label: {
                    Text("Continue with Phone")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Capsule())
                }
                
                Button {
                    withAnimation(.bouncy) {
                        currentView = .email
                    }
                } label: {
                    Text("Continue with Email")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Capsule())
                }
                
                HStack(spacing: 15) {
                    Button {
                        withAnimation(.bouncy) {
                            currentView = .periods
                        }
                    } label: {
                        HStack {
                            Image(systemName: "globe")
                            Text("Google")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Capsule())
                    }
                    
                    Button {
                        withAnimation(.bouncy) {
                            currentView = .periods
                        }
                    } label: {
                        HStack {
                            Image(systemName: "applelogo")
                            Text("Apple")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Capsule())
                    }
                }
            }
        }
    }
    
    func phoneInputView() -> some View {
        VStack(spacing: 20) {
            header(title: "Enter Phone Number") {
                withAnimation(.bouncy) {
                    currentView = .actions
                }
            }
            
            VStack(spacing: 6) {
                Text(phoneNumber.isEmpty ? "Enter Number" : phoneNumber)
                    .font(.system(size: 40, weight: .bold))
                    .contentTransition(.numericText())
                    .frame(height: 50)
                
                Text("We’ll send you an OTP to verify")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .padding(.vertical)
            
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 15), count: 3), spacing: 15) {
                ForEach(keypadValues) { keyValue in
                    Group {
                        if keyValue.isBack {
                            Image(systemName: keyValue.title)
                        } else {
                            Text(keyValue.title)
                        }
                    }
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.snappy) {
                            if keyValue.isBack {
                                if !phoneNumber.isEmpty {
                                    phoneNumber.removeLast()
                                }
                            } else {
                                if phoneNumber.count < 10 {
                                    phoneNumber.append(keyValue.title)
                                }
                            }
                        }
                    }
                }
            }
            
            Button("Continue") {
                withAnimation(.bouncy) {
                    currentView = .otp
                }
            }
            .disabled(phoneNumber.count < 10)
            .opacity(phoneNumber.count < 10 ? 0.5 : 1)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue, in: Capsule())
            .foregroundStyle(.white)
            .padding(.top)
        }
    }
    
    func otpInputView() -> some View {
        VStack(spacing: 20) {
            header(title: "Enter OTP") {
                withAnimation(.bouncy) {
                    currentView = .phone
                }
            }
            
            VStack(spacing: 6) {
                HStack(spacing: 12) {
                    ForEach(0..<6) { i in
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 40, height: 55)
                            
                            Text(i < otp.count ? String(otp[otp.index(otp.startIndex, offsetBy: i)]) : "")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                    }
                }
                
                Text("We’ve sent an OTP to \(phoneNumber)")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .padding(.vertical)
            
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 15), count: 3), spacing: 15) {
                ForEach(keypadValues) { keyValue in
                    Group {
                        if keyValue.isBack {
                            Image(systemName: keyValue.title)
                        } else {
                            Text(keyValue.title)
                        }
                    }
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.snappy) {
                            if keyValue.isBack {
                                if !otp.isEmpty {
                                    otp.removeLast()
                                }
                            } else {
                                if otp.count < 6 {
                                    otp.append(keyValue.title)
                                }
                            }
                        }
                    }
                }
            }
            
            Button("Verify") {
                withAnimation(.bouncy) {
                    currentView = .periods
                }
            }
            .disabled(otp.count < 6)
            .opacity(otp.count < 6 ? 0.5 : 1)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue, in: Capsule())
            .foregroundStyle(.white)
            .padding(.top)
        }
    }
    
    func emailLoginView() -> some View {
        VStack(spacing: 20) {
            header(title: "Enter Email") {
                withAnimation(.bouncy) {
                    currentView = .actions
                    email = ""
                    password = ""
                    emailLoginStarted = false
                }
            }
            
            VStack(spacing: 14) {
                TextField("you@example.com", text: $email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                if emailLoginStarted {
                    SecureField("Enter Password", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            
            Button(emailLoginStarted ? "Login" : "Continue") {
                withAnimation(.bouncy) {
                    if emailLoginStarted {
                            // Normally you'd call login logic here
                        currentView = .personalDetails
                    } else {
                        emailLoginStarted = true
                    }
                }
            }
            .disabled(email.isEmpty || (emailLoginStarted && password.isEmpty))
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(Color.blue, in: Capsule())
            .foregroundStyle(.white)
            .padding(.top)
        }
    }
    
    func personalDetailsView() -> some View {
        VStack(spacing: 20) {
            header(title: "Personal Details") {
                withAnimation(.bouncy) {
                    currentView = .email
                }
            }
            
            TextField("Full Name", text: $name)
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            DatePicker("Date of Birth", selection: $dob, displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
                // Gender & Pronouns side by side
            HStack(spacing: 12) {
                    // GENDER
                Button {
                    withAnimation(.bouncy) {
                        currentView = .genders
                    }
                } label: {
                    HStack {
                        Text(gender.isEmpty ? "Select Gender" : gender)
                            .foregroundColor(gender.isEmpty ? .gray : .primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .sheet(isPresented: $showGenderPicker) {
                    VStack {
                        Text("Select Gender")
                            .font(.headline)
                            .padding()
                        Picker("Gender", selection: $gender) {
                            Text("Male").tag("Male")
                            Text("Female").tag("Female")
                            Text("Non-binary").tag("Non-binary")
                            Text("Other").tag("Other")
                            Text("Prefer not to say").tag("Prefer not to say")
                        }
                        .labelsHidden()
                        .padding()
                        Button("Done") {
                            showGenderPicker = false
                        }
                        .padding(.top)
                    }
                    .presentationDetents([.medium])
                }
                
                // PRONOUNS
                Picker("Pronouns", selection: $selectedPronoun) {
                    ForEach(pronounOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .clipped()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Button("Continue") {
                withAnimation(.bouncy) {
                    currentView = .periods
                }
            }
            .disabled(name.isEmpty || gender.isEmpty)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(Color.blue, in: Capsule())
            .foregroundStyle(.white)
            .padding(.top)
        }
    }
    
    func genderView() -> some View {
        VStack(spacing: 12) {
            header(title: "Select Gender") {
                withAnimation(.bouncy) {
                    currentView = .personalDetails
                }
            }
            
            Text("How do you identify?")
                .multilineTextAlignment(.center)
                .foregroundStyle(.gray)
                .padding(.bottom, 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 15), count: 2), spacing: 15) {
                ForEach(genderOptions, id: \.self) { option in
                    let isSelected = gender == option
                    
                    Text(option)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill((isSelected ? Color.blue : Color.gray).opacity(isSelected ? 0.2 : 0.1))
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.bouncy) {
                                gender = option
                                currentView = .personalDetails
                            }
                        }
                }
            }
        }
    }
    
    func periodView() -> some View {
        VStack(spacing: 12) {
            header(title: "Choose Period") {
                withAnimation(.bouncy) { currentView = .actions }
            }
            
            Text("Choose the period you want\nto get subscribed.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.gray)
                .padding(.bottom, 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 15), count: 3), spacing: 15) {
                ForEach(periods) { period in
                    let isSelected = selectedPeriod?.id == period.id
                    
                    VStack(spacing: 6) {
                        Text(period.title)
                            .font(period.value == 0 ? .title3 : .title2)
                            .fontWeight(.semibold)
                        
                        if period.value != 0 {
                            Text(period.value == 1 ? "Month" : "Months")
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 80)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill((isSelected ? Color.blue : Color.gray).opacity(isSelected ? 0.2 : 0.1))
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.snappy) {
                            if period.value == 0 {
                                currentView = .keypad
                            } else {
                                selectedPeriod = isSelected ? nil : period
                            }
                        }
                    }
                }
            }
        }
    }
    
    func keypadView() -> some View {
        VStack(spacing: 12) {
            header(title: "Custom Duration") {
                withAnimation(.bouncy) { currentView = .periods }
            }
            
            VStack(spacing: 6) {
                Text(duration.isEmpty ? "0" : duration)
                    .font(.system(size: 60, weight: .black))
                    .contentTransition(.numericText())
                
                Text("Days")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .padding(.vertical, 20)
            
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 15), count: 3), spacing: 15) {
                ForEach(keypadValues) { keyValue in
                    Group {
                        if keyValue.isBack {
                            Image(systemName: keyValue.title)
                        } else {
                            Text(keyValue.title)
                        }
                    }
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.snappy) {
                            if keyValue.isBack {
                                if !duration.isEmpty {
                                    duration.removeLast()
                                }
                            } else {
                                duration.append(keyValue.title)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func continueButton() -> some View {
        Button {
            withAnimation(.bouncy) {
                if currentView == .actions {
                    currentView = .periods
                } else {
                    show = false // Final action here
                }
            }
        } label: {
            Text("Continue")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .foregroundStyle(.white)
                .background(Color.blue, in: .capsule)
        }
        .padding(.top, 15)
    }
    
    func header(title: String, backAction: @escaping () -> Void) -> some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            Spacer()
            Button(action: backAction) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(Color.gray, Color.primary.opacity(0.1))
            }
        }
        .padding(.bottom, 10)
    }
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

    // MARK: - Preview

#Preview {
    ContentView()
}
