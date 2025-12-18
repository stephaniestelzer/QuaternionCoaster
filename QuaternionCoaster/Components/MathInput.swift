import SwiftUI

struct MathInput: View {
    @Binding var value: Float
    let label: String
    
    // Formatter to handle the float-to-string conversion
    private let formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 2
        return f
    }()
    
    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 2) {
            TextField("", value: $value, formatter: formatter)
                .font(.system(.title3, design: .monospaced, weight: .medium))
                .foregroundStyle(Color.indigo.opacity(0.8))
                .fixedSize() // Prevents the textfield from taking up infinite width
                .keyboardType(.numbersAndPunctuation) // Shows the minus sign and decimal
                .multilineTextAlignment(.trailing)
            
            Text(label)
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 4)
        .background(Color.white.opacity(0.05)) // Subtle hint that it's an input field
        .cornerRadius(4)
    }
}
