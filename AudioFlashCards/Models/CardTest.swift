import XCTest
@testable import AudioFlashCards

extension Card {
    static var testInstance: Card {
        let num1 = Int.random(in: 1...12)
        let num2 = Int.random(in: 1...12)
        let operation = ["+", "-", "/", "x"].randomElement()!
        let answer = Int.random(in: 1...12)
        
        return Card(num1: num1, num2: num2, operation: operation, answer: answer)
    }
}
