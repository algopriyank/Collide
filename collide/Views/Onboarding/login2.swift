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
                    .background(.thinMaterial)
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
    case preferences
    case college
    case photos
    case bioTags
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

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

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
    @State private var interestedIn: String = ""
    @State private var lookingFor: String = ""
    @State private var collegeName: String = ""
    @State private var registrationNumber: String = ""
    @State private var location: String = ""
    @State private var selectedImages: [UIImage?] = Array(repeating: nil, count: 6)
    @State private var showingImagePicker = false
    @State private var selectedImageIndex: Int? = nil
    @State private var tempImage: UIImage? = nil
    @State private var bio: String = ""
    @State private var selectedTags: Set<String> = []
    
    let pronounOptions = ["he/him", "she/her", "they/them", "ze/zir", "prefer not to say"]
    let genderOptions = ["Male", "Female", "Non-binary", "Other", "Prefer not to say"]
    
    var body: some View {
        ZStack {
                // Background Gradient
            LinearGradient(
                colors: [.clear, .cyan.opacity(0.24), .green.opacity(0.24)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                    // Top Image inside RoundedRectangle
                Image("loginBackground5")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .padding(.horizontal, 24)
                
                    // Text below image
                Text("Welcome to Collide")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
                Text("This app is basically Jim looking at Pam.")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Spacer()
                
                    // Show tray button at the bottom
                Button(action: {
                    show.toggle()
                }) {
                    Text("Get Started")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 24)
                }
                .padding(.bottom, 40)
            }
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
                    case .preferences:
                        preferencesView()
                    case .college:
                        collegeView()
                    case .photos:
                        photosView()
                    case .bioTags:
                        bioTagsView()
                    case .periods:
                        periodView()
                    case .keypad:
                        keypadView()
                    }
                }
                .compositingGroup()
            }
            .padding(20)
        }
    }}

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
            
            Button(action: {
                withAnimation(.bouncy) {
                    currentView = .otp
                }
            }) {
                Text("Continue")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .disabled(phoneNumber.count < 10)
            .opacity(phoneNumber.count < 10 ? 0.5 : 1)
            .contentShape(Rectangle())
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
            
            Button(action: {
                withAnimation(.bouncy) {
                    currentView = .personalDetails
                }
            }) {
                Text("Verify")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .disabled(otp.count < 6)
            .opacity(otp.count < 6 ? 0.5 : 1)
            .contentShape(Rectangle())
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
            
            Button(action: {
                withAnimation(.bouncy) {
                    if emailLoginStarted {
                        currentView = .personalDetails
                    } else {
                        emailLoginStarted = true
                    }
                }
            }) {
                Text(emailLoginStarted ? "Login" : "Continue")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .disabled(email.isEmpty || (emailLoginStarted && password.isEmpty))
            .opacity((email.isEmpty || (emailLoginStarted && password.isEmpty)) ? 0.5 : 1)
            .contentShape(Rectangle())
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
                        Text(gender.isEmpty ? "Gender" : gender)
                            .foregroundColor(gender.isEmpty ? .gray : .primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(height: 82) // Match the Picker height
                    .frame(maxWidth: .infinity)
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
                .frame(height: 82)
                .clipped()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Button(action: {
                withAnimation(.bouncy) {
                    currentView = .preferences
                }
            }) {
                Text("Continue")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .disabled(name.isEmpty || gender.isEmpty)
            .opacity((name.isEmpty || gender.isEmpty) ? 0.5 : 1)
            .contentShape(Rectangle())
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
    
    func preferencesView() -> some View {
        VStack(spacing: 20) {
            HStack {
                Text("❤️ Preferences")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    withAnimation(.bouncy) {
                        currentView = .personalDetails
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(Color.gray, Color.primary.opacity(0.1))
                }
            }
            .padding(.bottom, 10)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Interested In")
                    .font(.headline)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    ForEach(["Men", "Women", "Everyone", "Custom"], id: \.self) { option in
                        Text(option)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(interestedIn == option ? Color.blue : Color.gray.opacity(0.1))
                            )
                            .foregroundColor(interestedIn == option ? .white : .primary)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    interestedIn = option
                                }
                            }
                    }
                }
                
                Text("Looking For")
                    .font(.headline)
                    .padding(.top)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    ForEach([
                        "Serious relationship",
                        "Just vibing",
                        "Casual hookups",
                        "Friends only",
                        "Party partner",
                        "Exploring"
                    ], id: \.self) { option in
                        Text(option)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(lookingFor == option ? Color.blue : Color.gray.opacity(0.1))
                            )
                            .foregroundColor(lookingFor == option ? .white : .primary)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    lookingFor = option
                                }
                            }
                    }
                }
            }
            
            Button {
                withAnimation(.bouncy) {
                    currentView = .college
                }
            } label: {
                Text("Continue")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .padding(.top)
        }
        .padding(20)
    }
    
    func collegeView() -> some View {
        VStack(spacing: 20) {
            HStack {
                Text("🎓 College Details")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    withAnimation(.bouncy) {
                        currentView = .preferences
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(Color.gray, Color.primary.opacity(0.1))
                }
            }
            .padding(.bottom, 10)
            
            VStack(spacing: 16) {
                TextField("Enter college name", text: $collegeName)
                    .textContentType(.organizationName)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                TextField("Registration number", text: $registrationNumber)
                    .keyboardType(.asciiCapable)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                TextField("Location", text: $location)
                    .textContentType(.addressCity)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Button {
                withAnimation(.bouncy) {
                    currentView = .photos // Replace with the next screen when ready
                }
            } label: {
                Text("Continue")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .padding(.top)
        }
        .padding(20)
    }
    
    func photosView() -> some View {
        let boxSize: CGFloat = 100
        let spacing: CGFloat = 10
        
        let columns = Array(repeating: GridItem(.fixed(boxSize), spacing: spacing), count: 3)
        
        return VStack(spacing: 20) {
            HStack {
                Text("📸 Upload Photos")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    withAnimation(.bouncy) {
                        currentView = .college
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(Color.gray, Color.primary.opacity(0.1))
                }
            }
            .padding(.bottom, 10)
            
            LazyVGrid(columns: columns, spacing: spacing) {
                ForEach(0..<6, id: \.self) { index in
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: boxSize, height: boxSize)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedImages[index] != nil ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
                            )
                        
                        if let image = selectedImages[index] {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: boxSize, height: boxSize)
                                .clipped()
                                .cornerRadius(12)
                        } else {
                            Image(systemName: "plus")
                                .font(.title)
                                .foregroundColor(.gray)
                        }
                        
                        if selectedImages[index] != nil {
                            VStack {
                                HStack {
                                    Spacer()
                                    Button {
                                        selectedImages[index] = nil
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.white)
                                            .padding(5)
                                            .background(Color.black.opacity(0.6))
                                            .clipShape(Circle())
                                    }
                                }
                                Spacer()
                            }
                            .frame(width: boxSize, height: boxSize)
                            .padding(6)
                        }
                    }
                    .onTapGesture {
                        if selectedImages[index] == nil {
                            selectedImageIndex = index
                            showingImagePicker = true
                        }
                    }
                }
            }
            
            Button {
                withAnimation(.bouncy) {
                    currentView = .bioTags
                }
            } label: {
                Text("Continue")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(selectedImages.contains(where: { $0 != nil }) ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .disabled(!selectedImages.contains(where: { $0 != nil }))
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $showingImagePicker, onDismiss: {
            if let temp = tempImage, let index = selectedImageIndex {
                selectedImages[index] = temp
                tempImage = nil
            }
        }) {
            ImagePicker(image: $tempImage)
        }
    }
    
    func bioTagsView() -> some View {
        let allTags = [
            "AI", "code", "football", "tv", "games", "music",
            "PSP", "cricket", "driving", "Meme Dealer", "Bookworm",
            "Fitness Freak", "Party Animal", "Traveller", "Reader"
        ]
        
        let rows = [GridItem(.fixed(36)), GridItem(.fixed(36)), GridItem(.fixed(36))]
        
        return VStack(spacing: 20) {
            header(title: "📝 Bio & Tags") {
                withAnimation(.bouncy) {
                    currentView = .photos
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Write a little something about you")
                    .font(.headline)
                
                Text("Example: “Love chai, memes & road trips.”")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                
                TextField("Type your bio here...", text: $bio, axis: .vertical)
                    .lineLimit(3...4)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Choose your tags")
                    .font(.headline)
                
                ScrollView(.horizontal) {
                    LazyHGrid(rows: rows, spacing: 10) {
                        ForEach(allTags, id: \.self) { tag in
                            Button {
                                if selectedTags.contains(tag) {
                                    selectedTags.remove(tag)
                                } else {
                                    selectedTags.insert(tag)
                                }
                            } label: {
                                Text(tag)
                                    .font(.subheadline)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(Color.gray.opacity(0.1))
                                    .foregroundColor(.primary)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 30)
                                            .stroke(selectedTags.contains(tag) ? Color.blue : Color.clear, lineWidth: 2)
                                    )
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            
            Button {
                withAnimation(.bouncy) {
                    currentView = .periods // Or the next screen
                }
            } label: {
                Text("Continue")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .padding(.top)
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
