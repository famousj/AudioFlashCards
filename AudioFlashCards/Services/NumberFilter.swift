import Foundation
import Speech

class NumberFilter {
    private let zeroWords = ["zero"]
    private let oneWords = ["one"]
    private let twoWords = ["two", "to", "too"]
    private let threeWords = ["three"]
    private let fourWords = ["four", "for"]
    private let fiveWords = ["five"]
    private let sixWords = ["six"]
    private let sevenWords = ["seven"]
    private let eightWords = ["eight"]
    private let nineWords = ["nine"]
    
    private var numberWords: [[String]]
    
    init() {
        numberWords = [zeroWords,
                       oneWords,
                       twoWords,
                       threeWords,
                       fourWords,
                       fiveWords,
                       sixWords,
                       sevenWords,
                       eightWords,
                       nineWords]
    }
    
    func getNumberFromRecognitionResults(_ results: SFSpeechRecognitionResult) -> Int {
        return -1
    }
    
    func getNumberFromTranscriptionText(_ text: String) -> Int {
        if let number = Int(text) {
            return number
        }
        
        let text = text.lowercased()
        
        for (index, words) in numberWords.enumerated() {
            if words.contains(text) {
                return index
            }
        }
        
        return -1
    }
}
