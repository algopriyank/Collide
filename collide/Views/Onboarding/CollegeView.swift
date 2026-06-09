//
//  CollegeView.swift
//  collide
//
//  Created by Antigravity on 09/06/26.
//

import SwiftUI

struct CollegeView: View {
    @ObservedObject var viewModel: AuthViewModel
    @FocusState private var focusedField: Field?
    @Environment(\.colorScheme) private var colorScheme
    
    enum Field: Hashable {
        case collegeName, studentEmail, location
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // College Name Field
                    VStack(alignment: .leading, spacing: 6) {
                        
                        // Suggestion List (Moved ABOVE the text field so it is never hidden by keyboard)
                        if !viewModel.collegeSearchResults.isEmpty {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("SUGGESTED COLLEGES")
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                                    .padding(.top, 10)
                                    .padding(.horizontal, 14)
                                    .padding(.bottom, 6)
                                
                                ForEach(viewModel.collegeSearchResults) { college in
                                    Button {
                                        withAnimation(.spring()) {
                                            selectCollege(college)
                                        }
                                    } label: {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(college.name)
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.primary)
                                                    .multilineTextAlignment(.leading)
                                                
                                                Text("\(college.city), \(college.state)")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                            Spacer()
                                            Image(systemName: "plus.circle.fill")
                                                .foregroundColor(.blue)
                                                .font(.subheadline)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 14)
                                        .contentShape(Rectangle())
                                    }
                                    
                                    if college != viewModel.collegeSearchResults.last {
                                        Divider()
                                            .padding(.horizontal, 14)
                                    }
                                }
                            }
                            .background(
                                colorScheme == .dark
                                    ? Color(red: 0.15, green: 0.15, blue: 0.17)
                                    : Color.white
                            )
                            .cornerRadius(12)
                            .shadow(color: Color.black.opacity(colorScheme == .dark ? 0.3 : 0.08), radius: 10, y: -4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.15), lineWidth: 1)
                            )
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                            .padding(.bottom, 8)
                        }
                        
                        Text("COLLEGE")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                            .padding(.leading, 4)
                        
                        HStack {
                            Image(systemName: "graduationcap")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                            
                            TextField("Enter college name", text: $viewModel.collegeSearchQuery)
                                .focused($focusedField, equals: .collegeName)
                                .textContentType(.organizationName)
                                .submitLabel(.next)
                                .onSubmit {
                                    if !viewModel.collegeSearchResults.isEmpty {
                                        // Auto-select first result if any
                                        selectCollege(viewModel.collegeSearchResults[0])
                                    } else {
                                        focusedField = .studentEmail
                                    }
                                }
                            
                            if viewModel.isSearchingColleges {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .transition(.opacity)
                            } else if !viewModel.collegeSearchQuery.isEmpty {
                                Button {
                                    withAnimation {
                                        viewModel.collegeSearchQuery = ""
                                        viewModel.collegeName = ""
                                        viewModel.collegeSearchResults = []
                                    }
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .modifier(CustomTextFieldStyle(isFocused: focusedField == .collegeName))
                    }
                    
                    // Student Email Field
                    VStack(alignment: .leading, spacing: 6) {
                        Text("STUDENT EMAIL")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                            .padding(.leading, 4)
                        
                        HStack {
                            Image(systemName: "envelope")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                            
                            TextField("name@college.edu", text: $viewModel.studentEmail)
                                .focused($focusedField, equals: .studentEmail)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .submitLabel(.next)
                                .onSubmit {
                                    focusedField = .location
                                }
                        }
                        .modifier(CustomTextFieldStyle(isFocused: focusedField == .studentEmail))
                    }
                    
                    // Location Field
                    VStack(alignment: .leading, spacing: 6) {
                        Text("LOCATION")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.secondary)
                            .padding(.leading, 4)
                        
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.secondary)
                                .font(.subheadline)
                            
                            TextField("Location (automatically updated)", text: $viewModel.location)
                                .focused($focusedField, equals: .location)
                                .textContentType(.addressCity)
                                .submitLabel(.done)
                                .onSubmit {
                                    focusedField = nil
                                }
                        }
                        .modifier(CustomTextFieldStyle(isFocused: focusedField == .location))
                    }
                }
                
                Button {
                    withAnimation(.bouncy) {
                        viewModel.currentView = .photos
                    }
                } label: {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                            viewModel.isContinueEnabled(for: .college)
                                ? (colorScheme == .dark ? Color.white : Color.black)
                                : Color.gray.opacity(0.3)
                        )
                        .foregroundColor(
                            viewModel.isContinueEnabled(for: .college)
                                ? (colorScheme == .dark ? .black : .white)
                                : .secondary
                        )
                        .clipShape(Capsule())
                }
                .disabled(!viewModel.isContinueEnabled(for: .college))
                .padding(.top)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                endEditing()
            }
            .padding(.bottom, 24)
        }
    }
    
    private func selectCollege(_ college: CollegeResult) {
        viewModel.collegeName = college.name
        viewModel.collegeSearchQuery = college.name
        viewModel.location = "\(college.city), \(college.state)"
        viewModel.collegeSearchResults = []
        focusedField = .studentEmail
    }
}

// MARK: - Custom Text Field Style
struct CustomTextFieldStyle: ViewModifier {
    var isFocused: Bool
    @Environment(\.colorScheme) private var colorScheme
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(colorScheme == .dark ? Color.white.opacity(0.06) : Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isFocused 
                            ? Color.blue.opacity(0.8) 
                            : Color.gray.opacity(colorScheme == .dark ? 0.25 : 0.15),
                        lineWidth: isFocused ? 1.5 : 1
                    )
            )
            .shadow(
                color: isFocused 
                    ? Color.blue.opacity(colorScheme == .dark ? 0.15 : 0.05) 
                    : Color.clear,
                radius: 4, 
                y: 2
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

// MARK: - View Extension for keyboard dismissal
fileprivate extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}