import Foundation
import Speech

class NumberFilter {
    
    static let notFound = -1
    
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
    
    let numberWords: [[String]]
    
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
//        let textNumber = results.transcriptions
//            .map { (transcription) -> Int in
//                let text = transcription.formattedString
//                return getNumberFromTranscriptionText(text)
//            }
//            .filter{ $0 != -1 }
//            .first ?? -1
        
                
        return results.transcriptions
            .map { (transcription) -> Int in
                let text = transcription.formattedString
                return getNumberFromTranscriptionText(text)
            }
            .filter{ $0 != NumberFilter.notFound }
            .first ?? NumberFilter.notFound
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
        
        return NumberFilter.notFound
    }
}
