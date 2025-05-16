import SwiftUI

struct CreditLineView: View {
    @State private var creditLine: Double = 90000
    @State private var textValue: String = ""
    @FocusState private var isEditing: Bool

    let minCredit: Double = 8500
    let maxCredit: Double = 90000

    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Línea de crédito")
                .font(.title3)
                .bold()

            Text("Selecciona tu línea de crédito")
                .font(.subheadline)
                .foregroundColor(.gray)

            HStack(spacing: 4) {
                Text("$").bold()

                TextField("", text: $textValue)
                    .keyboardType(.numberPad)
                    .focused($isEditing)
                    .onChange(of: isEditing) { editing in
                        if editing {
                            // Al comenzar edición → mostrar número plano
                            textValue = String(Int(creditLine))
                        } else {
                            // Al terminar edición → validar y formatear
                            applyFormatting()
                        }
                    }

                Image(systemName: "pencil")
                    .foregroundColor(.gray)
            }
            .font(.title2)

            Slider(value: $creditLine, in: minCredit...maxCredit, step: 100) {
                Text("Credit Line")
            } onEditingChanged: { _ in
                if !isEditing {
                    textValue = formattedAmount(creditLine)
                }
            }
            .accentColor(.blue)

            HStack {
                VStack(alignment: .leading) {
                    Text("Monto mínimo")
                        .font(.caption)
                    Text("$\(formattedAmount(minCredit))")
                        .bold()
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text("Monto máximo")
                        .font(.caption)
                    Text("$\(formattedAmount(maxCredit))")
                        .bold()
                }
            }
        }
        .padding()
        .onAppear {
            textValue = formattedAmount(creditLine)
        }
    }

    private func formattedAmount(_ value: Double) -> String {
        currencyFormatter.string(from: NSNumber(value: value)) ?? "\(Int(value))"
    }

    private func applyFormatting() {
        let clean = textValue.replacingOccurrences(of: ",", with: "")
        if let value = Double(clean) {
            let clamped = min(max(value, minCredit), maxCredit)
            creditLine = clamped
            textValue = formattedAmount(clamped)
        } else {
            textValue = formattedAmount(creditLine)
        }
    }
}

