import SwiftUI

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