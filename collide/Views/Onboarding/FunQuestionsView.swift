import SwiftUI

struct FunQuestionsView: View {
    @ObservedObject var viewModel: AuthViewModel
    
    let allQuestions = [
        "Two truths and a lie 🤯",
        "What’s your ideal weekend? 🌴",
        "A hot take about dating… 🔥",
        "What would your dating app bio be? 💬"
    ]
    
    @State private var selectedQuestion1: String? = nil
    @State private var selectedQuestion2: String? = nil
    @State private var answer1: String = ""
    @State private var answer2: String = ""
    
    @State private var showPickerForFirst = false
    @State private var showPickerForSecond = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
                // MARK: - Header
            HeaderView(title: "Fun Questions") {
                withAnimation(.bouncy) {
                    viewModel.currentView = .interests
                }
            }
            
            VStack(spacing: 16) {
                    // MARK: - First Question Card
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(selectedQuestion1 ?? "Select your first question")
                            .font(.headline)
                        Spacer()
                        Button("Choose") {
                            showPickerForFirst = true
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }
                    
                    TextEditor(text: $answer1)
                        .scrollContentBackground(.hidden)
                        .frame(height: selectedQuestion1 != nil ? 60 : 0)
                        .padding(selectedQuestion1 != nil ? 8 : 0)
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(12)
                        .disabled(selectedQuestion1 == nil)
                        .opacity(selectedQuestion1 != nil ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: selectedQuestion1)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(16)
                .shadow(radius: 1)
                
                    // MARK: - Second Question Card
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(selectedQuestion2 ?? "Select your second question")
                            .font(.headline)
                        Spacer()
                        Button("Choose") {
                            showPickerForSecond = true
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }
                    
                    TextEditor(text: $answer2)
                        .scrollContentBackground(.hidden)
                        .frame(height: selectedQuestion2 != nil ? 60 : 0)
                        .padding(selectedQuestion2 != nil ? 8 : 0)
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(12)
                        .disabled(selectedQuestion2 == nil)
                        .opacity(selectedQuestion2 != nil ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: selectedQuestion2)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(16)
                .shadow(radius: 1)
            }
            .padding(.horizontal)
            
                // MARK: - Continue Button
            Button(action: {
                viewModel.funQuestionAnswers = [
                    selectedQuestion1 ?? "": answer1,
                    selectedQuestion2 ?? "": answer2
                ]
                withAnimation(.bouncy) {
                    viewModel.currentView = .finalScreen
                }
            }) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(canContinue ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(!canContinue)
            .padding(.horizontal)
            .padding(.bottom, 10)
            
        }
        .sheet(isPresented: $showPickerForFirst) {
            QuestionPickerView(
                availableQuestions: availableQuestions(excluding: selectedQuestion2),
                onSelect: { selectedQuestion1 = $0 }
            )
        }
        .sheet(isPresented: $showPickerForSecond) {
            QuestionPickerView(
                availableQuestions: availableQuestions(excluding: selectedQuestion1),
                onSelect: { selectedQuestion2 = $0 }
            )
        }
    }
    
        // MARK: - Helpers
    var canContinue: Bool {
        selectedQuestion1 != nil &&
        selectedQuestion2 != nil &&
        !answer1.isEmpty &&
        !answer2.isEmpty
    }
    
    func availableQuestions(excluding excluded: String?) -> [String] {
        allQuestions.filter { $0 != excluded }
    }
}

struct QuestionPickerView: View {
    let availableQuestions: [String]
    let onSelect: (String) -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List(availableQuestions, id: \.self) { question in
                Button(action: {
                    onSelect(question)
                    dismiss()
                }) {
                    Text(question)
                }
            }
            .navigationTitle("Choose a Question")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
