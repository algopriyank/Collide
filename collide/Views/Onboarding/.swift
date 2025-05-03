//
//  CustomSheet.swift
//  collide
//
//  Created by Priyank Sharma on 28/04/25.
//

import SwiftUI

enum CurrentView {
    case actions
    case periods
}

struct CustomSheet: View {
    @State private var showSheet = false
    @State private var currentView: CurrentView = .actions
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        Button("Show tray view") {
            showSheet.toggle()
        }
        .systemTrayView($showSheet) {
            ZStack {
                switch currentView {
                case .actions: view1()
                        .transition(.blurReplace)
                case .periods: view2Email()
                        .transition(.blurReplace)
                }
            }
            .compositingGroup()
        }
    }
    
    ///view 1
    @ViewBuilder
    func view1() -> some View {
        VStack (alignment: .leading) {
            HStack {
                //close button
            }
            Text("Get Started")
                .font(.custom("NewKansasSwash-LightItalic", size: 28))
                .fontWeight(.bold)
            
            Text("Real connections, wild nights, good times.")
                .font(.subheadline)
                .padding(.bottom)
            
            //login with phone number
            Button {
                print("phone")
            } label: {
                Text("Continue with Phone")
                    .frame(width: 360, height: 48)
//                    .background(.ultraThinMaterial)
                    .background(Color.mint)
                    .foregroundColor(.white)
                    .cornerRadius(18)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }
            
            //login with email
            Button {
                print("email")
                withAnimation(.bouncy) {
                    currentView = .periods
                }
            } label: {
                Text("Continue with Email")
                    .frame(width: 360, height: 48)
                    .background(.teal)
                    .foregroundColor(.black)
                    .cornerRadius(18)
            }
            
            //login with apple
            HStack (alignment: .center) {
                Button {
                    print("Apple")
                } label: {
                    Image(systemName: "apple.logo")
                        .frame(width: 175, height: 48)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(18)
                }
                
                //login with google
                Button {
                    print("Google")
                } label: {
                    Text("Google")
                        .frame(width: 175, height: 48)
                        .background(Color.indigo)
                        .foregroundColor(.white)
                        .cornerRadius(18)
                }
            }
            
            //terms and conditions
            HStack (alignment: .center) {
                Spacer()
                
                Button {
                    print("Terms and Conditions")
                } label: {
                    Text("Terms and Conditions")
                        .font(.footnote)
                        .foregroundColor(.black)
                }
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 320)
        .padding(12)
    }
    
    func view2Email() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Enter your email")
                .font(.custom("NewKansasSwash-LightItalic", size: 28))
                .fontWeight(.bold)
            
                // Email Text Field
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            
                // Password Text Field
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            
                // Login Button
            Button {
                print("Login with email: \(email) and password: \(password)")
            } label: {
                Text("Login")
                    .frame(width: 360, height: 48)
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(18)
            }
        }
        .padding(12)
    }
}

#Preview {
    CustomSheet()
}


    
// MARK: - Config Object
struct TrayConfig {
    var maxDetent: PresentationDetent
    var cornerRadius: CGFloat = 30
    var isInteractiveDismissDisabled: Bool = false
    var horizontalPadding: CGFloat = 15
    var bottomPadding: CGFloat = 15
}

// MARK: - Sheet Modifier Extension
extension View {
    @ViewBuilder
    func systemTrayView<Content: View>(
        _ show: Binding<Bool>,
        config: TrayConfig = .init(maxDetent: .fraction(0.99)),
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.sheet(isPresented: show) {
                content()
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: config.cornerRadius))
                    .padding(.horizontal, config.horizontalPadding)
                    .padding(.bottom, config.bottomPadding)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .presentationDetents([config.maxDetent])
                    .presentationCornerRadius(0)
                    .presentationBackground(.clear)
                    .presentationDragIndicator(.hidden)
                    .interactiveDismissDisabled(config.isInteractiveDismissDisabled)
                    .background(RemoveSheetShadow())
            }
    }
}

// MARK: - Shadow Remover
fileprivate struct RemoveSheetShadow: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        DispatchQueue.main.async {
            if let shadowView = view.dropShadowView {
                shadowView.layer.shadowColor = UIColor.clear.cgColor
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

    // MARK: - Helper Extension
extension UIView {
    var dropShadowView: UIView? {
        if let superview,
           String(describing: type(of: superview)) == "UIDropShadowView" {
            return superview
        }
        return superview?.dropShadowView
    }
}
