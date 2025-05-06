import SwiftUI

struct CollegeView: View {
    @ObservedObject var viewModel: AuthViewModel
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case collegeName, registrationNumber, location
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("🎓 College Details")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Button {
                    withAnimation(.bouncy) {
                        viewModel.currentView = .preferences
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(Color.gray, Color.primary.opacity(0.1))
                }
            }
            .padding(.bottom, 10)
            
            VStack(spacing: 16) {
                TextField("Enter college name", text: $viewModel.collegeName)
                    .focused($focusedField, equals: .collegeName)
                    .textContentType(.organizationName)
                    .padding()
                    .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .registrationNumber
                    }
                
                TextField("Registration number", text: $viewModel.registrationNumber)
                    .focused($focusedField, equals: .registrationNumber)
                    .keyboardType(.asciiCapable)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .location
                    }
                
                TextField("Location", text: $viewModel.location)
                    .focused($focusedField, equals: .location)
                    .textContentType(.addressCity)
                    .padding()
                    .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                    .submitLabel(.done)
                    .onSubmit {
                        focusedField = nil
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
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .padding(.top)
        }
    }
} 