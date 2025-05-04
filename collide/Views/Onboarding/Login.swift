//
//  Login.swift
//  collide
//
//  Created by Priyank Sharma on 23/04/25.
//

import SwiftUI

struct Login: View {
    @State private var showSheet = false
    @State private var showEmailForm = false
    @State private var email = ""
    @State private var password = ""
    @State private var showProfileForm = false
    @State private var fullName = ""
    @State private var dateOfBirth = Date()
    @State private var onboardingStep: Int = 1  // 1 = name/dob, 2 = gender/preferences
    @State private var sheetHeightFraction: CGFloat = 0.4
    
    var body: some View {
        ZStack(alignment: .bottom) {
            backgroundDesign
            primaryLoginButton
        }
    }
}

#Preview {
    Login()
}

private extension Login {
    
    // MARK: - Background
    var backgroundDesign: some View {
        Image("loginBackground")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
    
    // MARK: - Primary Button
    var primaryLoginButton: some View {
        Button(action: { showSheet.toggle() }) {
            Text("Continue")
                .font(.headline)
                .frame(width: 320, height: 72)
                .background(.ultraThinMaterial)
                .background(.black.opacity(0.4))
                .foregroundColor(.black)
                .cornerRadius(28)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.white.opacity(0.5), lineWidth: 2)
                )
        }
        .sheet(isPresented: $showSheet) {
            sheetContent
                .presentationDetents([.fraction(sheetHeightFraction)])
                .presentationBackground(.ultraThinMaterial)
                .presentationCornerRadius(24)
        }
    }
    
    // MARK: - Sheet Root View
    var sheetContent: some View {
        ZStack {
            if showProfileForm {
                if onboardingStep == 1 {
                    nameDOBView
                        .onAppear { sheetHeightFraction = 0.35 }
                        .transition(.move(edge: .trailing))
                } else if onboardingStep == 2 {
                    SexAndPreferencesView
                        .onAppear { sheetHeightFraction = 0.85 }
                        .transition(.move(edge: .trailing))
                }
            } else if showEmailForm {
                emailLoginView
                    .onAppear { sheetHeightFraction = 0.35 }
                    .transition(.move(edge: .trailing))
            } else {
                mainSheetView
                    .onAppear { sheetHeightFraction = 0.45 }
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.bouncy, value: showEmailForm)
        .animation(.bouncy, value: onboardingStep)
    }
    
    // MARK: - Main Sheet View
    var mainSheetView: some View {
        VStack(alignment: .leading, spacing: 12) {
            titleText
            subtitleText
            phoneButton
            emailButton
            socialButtons
            Spacer()
        }
        .padding()
    }
    
    // MARK: - Header Icon
    var titleText: some View {
        Text("Get Started")
            .font(.custom("NewKansasSwash-LightItalic", size: 48))
            .fontWeight(.bold)
    }
    
    var subtitleText: some View {
        //Text("Real connections, wild nights, good times.")
        Text("This app is basically Jim looking at Pam.")
            .font(.subheadline)
            .padding(.bottom)
    }
    
    var phoneButton: some View {
        Button {
            print("phone")
        } label: {
            Text("Continue with Phone")
                .frame(width: 360, height: 48)
                .background(Color.black.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(18)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.black, lineWidth: 1)
                )
        }
    }
    
    var emailButton: some View {
        Button {
            withAnimation(.bouncy) {
                showEmailForm = true
            }
        } label: {
            Text("Continue with Email")
                .frame(width: 360, height: 48)
                .background(.ultraThinMaterial)
                .foregroundColor(.black)
                .cornerRadius(18)
        }
    }
    
    var socialButtons: some View {
        HStack {
            Button {
                print("Apple")
            } label: {
                Image(systemName: "apple.logo")
                    .frame(width: 180, height: 48)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(18)
            }
            
            Button {
                print("Google")
            } label: {
                Text("Google")
                    .frame(width: 180, height: 48)
                    .background(Color.indigo)
                    .foregroundColor(.white)
                    .cornerRadius(18)
            }
        }
    }
    
    // MARK: - Email Login View
    var emailLoginView: some View {
        VStack(alignment: .leading, spacing: 16) {
            emailBackButton
            emailHeader
            emailTextField
            passwordField
            emailLoginButton
            Spacer()
        }
        .padding()
    }
    
    var emailBackButton: some View {
        HStack {
            Button(action: {
                withAnimation(.bouncy) {
                    showEmailForm = false
                }
            }) {
                Image(systemName: "chevron.backward.circle")
                    .font(.title2)
                    .foregroundColor(.black)
            }
            Spacer()
        }
    }
    
    var emailHeader: some View {
        Text("Enter your email")
            .font(.custom("NewKansasSwash-LightItalic", size: 28))
            .fontWeight(.bold)
    }
    
    var emailTextField: some View {
        TextField("Email", text: $email)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .padding()
            .background(Color(.clear))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray, lineWidth: 2)
            )
            .cornerRadius(12)
    }
    
    var passwordField: some View {
        SecureField("Password", text: $password)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray, lineWidth: 2)
            )
            .cornerRadius(12)
    }
    
    var emailLoginButton: some View {
        Button {
            withAnimation(.bouncy) {
                showProfileForm = true
            }
            print("Login with email: \(email), password: \(password)")
        } label: {
            Text("Login")
                .frame(width: 360, height: 48)
                .background(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.gray, lineWidth: 2)
                )
                .foregroundColor(.white)
                .cornerRadius(18)
        }
    }
    
    // MARK: - Personal Details View
    var nameDOBView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button(action: {
                    withAnimation(.bouncy) {
                        showProfileForm = false
                    }
                }) {
                    Image(systemName: "chevron.backward.circle")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            
            Text("Tell us about yourself")
                .font(.custom("NewKansasSwash-LightItalic", size: 28))
                .fontWeight(.bold)
            
            TextField("Full Name", text: $fullName)
                .padding()
                .background(Color(.clear))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray, lineWidth: 2)
                )
                .cornerRadius(12)
            
            DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding(.horizontal)
            
            Spacer()
            
            Button {
                print("Proceed with: \(fullName), DOB: \(dateOfBirth)")
                withAnimation(.bouncy) {
                    onboardingStep = 2
                }
            } label: {
                Text("Next")
                    .frame(width: 360, height: 48)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(18)
            }
            
            Spacer()
        }
        .padding()
    }
    
    // MARK: - orientation Details View
    var SexAndPreferencesView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button(action: {
                    withAnimation(.bouncy) {
                        onboardingStep = 1
                    }
                }) {
                    Image(systemName: "chevron.backward.circle")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            
            Text("What best describes your gender?")
                .font(.custom("NewKansasSwash-LightItalic", size: 28))
                .fontWeight(.bold)
            
            ScrollView {
                LazyVStack {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray, lineWidth: 2)
                                .frame(width: 172, height: 172)
                            
                            Image("male")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 172, height: 172)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray, lineWidth: 2)
                                .frame(width: 172, height: 172)
                            
                            Image("female")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 172, height: 172)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray, lineWidth: 2)
                                .frame(width: 172, height: 172)
                            
                            Image("nonBinary")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 172, height: 172)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray, lineWidth: 2)
                                .frame(width: 172, height: 172)
                            
                            Image("other")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 172, height: 172)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                }
                .padding(.top)
            }
                        
            Button {
                print("Proceed with: \(fullName), DOB: \(dateOfBirth)")
                    // You can add logic to move to next onboarding screen here
            } label: {
                Text("Next")
                    .frame(width: 360, height: 48)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(18)
            }
            Spacer()
        }
        .padding()
    }
    
    var SexualOrientation: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Button(action: {
                    withAnimation(.bouncy) {
                        onboardingStep = 1
                    }
                }) {
                    Image(systemName: "chevron.backward.circle")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            
            Text("What best defines you?")
                .font(.custom("NewKansasSwash-LightItalic", size: 28))
                .fontWeight(.bold)
            
            ScrollView {
                LazyVStack {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray, lineWidth: 2)
                                .frame(width: 172, height: 172)
                            
                            Image("Straight")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 172, height: 172)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray, lineWidth: 2)
                                .frame(width: 172, height: 172)
                            
                            Image("Lesbian")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 172, height: 172)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray, lineWidth: 2)
                                .frame(width: 172, height: 172)
                            
                            Image("Gay")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 172, height: 172)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray, lineWidth: 2)
                                .frame(width: 172, height: 172)
                            
                            Image("Bi")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 172, height: 172)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray, lineWidth: 2)
                                .frame(width: 172, height: 172)
                            
                            Image("Bi")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 172, height: 172)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.gray, lineWidth: 2)
                                .frame(width: 172, height: 172)
                            
                            Image("Asexual")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 172, height: 172)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                }
                .padding(.top)
            }
            
            Button {
                print("Proceed with: \(fullName), DOB: \(dateOfBirth)")
                    // You can add logic to move to next onboarding screen here
            } label: {
                Text("Next")
                    .frame(width: 360, height: 48)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(18)
            }
            Spacer()
        }
        .padding()
    }
}
