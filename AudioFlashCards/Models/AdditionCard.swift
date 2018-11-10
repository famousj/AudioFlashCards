import Foundation

extension Card {
    static func AdditionCard(num1: Int, num2: Int) -> Card {
        let sum = num1 + num2
        return Card(num1: num1, num2: num2, operation: "+", answer: sum)
    }
}
