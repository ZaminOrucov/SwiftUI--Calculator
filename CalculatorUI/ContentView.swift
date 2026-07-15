import SwiftUI
import SwiftData
struct ContentView: View {
    @State private var display: String = "0"
    @State private var currentNumber: Double = 0
    @State private var previousNumber: Double = 0
    @State private var currentOperation: String? = nil
    @State private var inTypingMode: Bool = false
    
    let buttons: [[String]] = [
        ["AC", "+/-", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "−"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 12) {
                Spacer()
            
                HStack {
                    Spacer()
                    Text(display)
                        .foregroundColor(.white)
                        .font(.system(size: 64, weight: .light))
                        .lineLimit(1)
                        .padding()
                }
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { button in
                            Button(action: {
                                self.didTap(button)
                            }) {
                                Text(button)
                                    .font(.system(size: 32))
                                    .frame(width: self.buttonWidth(button: button),
                                           height: self.buttonHeight())
                                    .background(self.buttonColor(button: button))
                                    .foregroundColor(.white)
                                    .cornerRadius(self.buttonWidth(button: button)/2)
                            }
                        }
                    }
                }
            }
            .padding(.bottom)
        }
    }
    
    // Düyməyə basıldıqda nə baş verir
    func didTap(_ button: String) {
        switch button {
        case "0"..."9", ".":
            if inTypingMode {
                display += button
            } else {
                display = button
                inTypingMode = true
            }
            currentNumber = Double(display) ?? 0
            
        case "AC":
            display = "0"
            currentNumber = 0
            previousNumber = 0
            currentOperation = nil
            inTypingMode = false
            
        case "+", "−", "×", "÷":
            previousNumber = currentNumber
            currentOperation = button
            inTypingMode = false
            
        case "=":
            if let op = currentOperation {
                switch op {
                case "+": currentNumber = previousNumber + currentNumber
                case "−": currentNumber = previousNumber - currentNumber
                case "×": currentNumber = previousNumber * currentNumber
                case "÷":
                    if currentNumber != 0 {
                        currentNumber = previousNumber / currentNumber
                    } else {
                        display = "Error"
                        return
                    }
                default: break
                }
                display = formatNumber(currentNumber)
                currentOperation = nil
                inTypingMode = false
            }
            
        case "+/−":
            currentNumber = -currentNumber
            display = formatNumber(currentNumber)
            
        case "%":
            currentNumber = currentNumber / 100
            display = formatNumber(currentNumber)
            
        default:
            break
        }
    }

    func formatNumber(_ num: Double) -> String {
        if num.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(num))
        }
        return String(num)
    }
    
    func buttonColor(button: String) -> Color {
        if ["÷", "×", "−", "+", "="].contains(button) {
            return .orange
        } else if ["AC", "+/−", "%"].contains(button) {
            return Color(.lightGray)
        }
        return Color(.darkGray)
    }
    
    func buttonWidth(button: String) -> CGFloat {
        if button == "0" {
            return (UIScreen.main.bounds.width - 5*12) / 4 * 2
        }
        return (UIScreen.main.bounds.width - 5*12) / 4
    }
    
    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - 5*12) / 4
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
