import Foundation

extension String {
    static var randomString: String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let length = Int.random(in: 3...10)
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
}
