//
//  CardLineView.swift
//  PriceSlider
//
//  Created by Israel Torres Alvarado on 14/05/25.
//

import SwiftUI

struct CreditLineView: View {
    // MARK: - Properties
    @State private var creditLine: Double = 90000
    @State private var textValue: String = "90000"
    let minCredit: Double = 8500
    let maxCredit: Double = 90000

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Línea de crédito")
                .font(.title3)
                .bold()

            Text("Selecciona tu línea de crédito")
                .font(.subheadline)
                .foregroundColor(.gray)

            HStack {
                Text("$")
                    .bold()
                TextField("", text: $textValue)
                    .keyboardType(.numberPad)
                    .frame(width: 100)
                    .onChange(of: textValue) { newValue in
                        let filtered = newValue.filter { $0.isNumber }
                        if let value = Double(filtered), value >= minCredit, value <= maxCredit {
                            creditLine = value
                        }
                        textValue = filtered
                    }

                Image(systemName: "pencil")
                    .foregroundColor(.gray)
            }
            .font(.title2)

            Slider(value: $creditLine, in: minCredit...maxCredit, step: 100) {
                Text("Credit Line")
            } onEditingChanged: { _ in
                textValue = String(format: "%.0f", creditLine)
            }
            .accentColor(.blue)

            HStack {
                Text("Monto mínimo")
                    .font(.caption)
                Spacer()
                Text("Monto máximo")
                    .font(.caption)
            }

            HStack {
                Text("$\(Int(minCredit))")
                    .bold()
                Spacer()
                Text("$\(Int(maxCredit))")
                    .bold()
            }
        }
        .padding()
    }
}

#Preview {
    CreditLineView()
}
