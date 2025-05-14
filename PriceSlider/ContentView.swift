//
//  ContentView.swift
//  PriceSlider
//
//  Created by Israel Torres Alvarado on 13/05/25.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    @State private var creditLine: Double = 90000
    @State private var textValue: String = "90,000"
    
    let minCredit: Double = 8500
    let maxCredit: Double = 90000
    
    // Formatter para mostrar el número con comas
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
                Text("$")
                    .bold()
                
                TextField("", text: $textValue)
                    .keyboardType(.numberPad)
                    .frame(width: 120)
                    .onChange(of: textValue) { newValue in
                        let cleanString = newValue.replacingOccurrences(of: ",", with: "")
                        let filtered = cleanString.filter { $0.isNumber }
                        
                        if let value = Double(filtered) {
                            if value >= minCredit && value <= maxCredit {
                                creditLine = value
                            } else if value < minCredit {
                                creditLine = minCredit
                            } else if value > maxCredit {
                                creditLine = maxCredit
                            }
                            updateTextField()
                        } else {
                            textValue = ""
                        }
                    }
                
                Image(systemName: "pencil")
                    .foregroundColor(.gray)
            }
            .font(.title2)
            
            Slider(value: $creditLine, in: minCredit...maxCredit, step: 100) {
                Text("Credit Line")
            } onEditingChanged: { _ in
                updateTextField()
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
            updateTextField()
        }
    }
    
    // Actualiza el campo de texto con formato
    private func updateTextField() {
        if let formatted = currencyFormatter.string(from: NSNumber(value: creditLine)) {
            textValue = formatted
        }
    }
    
    private func formattedAmount(_ value: Double) -> String {
        currencyFormatter.string(from: NSNumber(value: value)) ?? "\(Int(value))"
    }
}

#Preview {
    ContentView()
}
