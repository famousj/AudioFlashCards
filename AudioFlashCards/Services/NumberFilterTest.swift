import XCTest
import Speech
@testable import AudioFlashCards

class NumberFilterTest: XCTestCase {
    
    func test_getNumberFromTranscriptionText_ParsesIntegers() {
        let testNumber = Int.random(in: 0...20)
        let testObject = NumberFilter()
        
        let testNumberString = String(testNumber)
        
        XCTAssertEqual(testObject.getNumberFromTranscriptionText(testNumberString), testNumber)
    }
    
    func test_getNumberFromTranscriptionText_ConvertsNumberWords() {
        let testObject = NumberFilter()
        
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("Zero"), 0)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("One"), 1)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("Two"), 2)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("Three"), 3)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("Four"), 4)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("Five"), 5)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("Six"), 6)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("Seven"), 7)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("Eight"), 8)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("Nine"), 9)
    }
    
    func test_getNumberFromTranscriptionText_ConvertsHomophones() {
        let testObject = NumberFilter()
        
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("To"), 2)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("Too"), 2)
        XCTAssertEqual(testObject.getNumberFromTranscriptionText("For"), 4)
    }
    
    func test_getNumberFromTranscriptionText_WhenSentNonNumber_ThenReturnsInvalidResponse() {
        let testObject = NumberFilter()
        
        XCTAssertEqual(testObject.getNumberFromTranscriptionText(String.randomString), NumberFilter.notFound)
    }
    
    func test_getNumberFromRecognitionResults_WhenFirstTranscriptionIsANumber_TheReturnsNumber() {
        let testObject = NumberFilter()
        
        let (expectedNumber, numberString) = validTestNumber
        let transcription = TranscriptionMock(formattedString: numberString)
        let results = SpeechRecognitionResultMock(transcriptions: [transcription])
        
        let actualNumber = testObject.getNumberFromRecognitionResults(results)
        
        XCTAssertEqual(actualNumber, expectedNumber)
    }
    
    func test_getNumberFromRecognitionResults_WhenNotTheFirstTextIsTheNumber_ThenReturnsNumber() {
        
        let transcriptionsLength: Int = Int.random(in: 5...10)
        let goodIndex = Int.random(in: 1..<transcriptionsLength)
        let (expectedNumber, numberString) = validTestNumber
        
        let transcriptions: [SFTranscription] = (0..<transcriptionsLength).map { i in
            if i == goodIndex {
                return TranscriptionMock(formattedString: numberString)
            } else {
                return TranscriptionMock(formattedString: String.randomString)
            }
        }
        let results = SpeechRecognitionResultMock(transcriptions: transcriptions)

        let testObject = NumberFilter()
        
        let actualNumber = testObject.getNumberFromRecognitionResults(results)

        XCTAssertEqual(actualNumber, expectedNumber)
    }

    func test_getNumberFromRecognitionResults_WhenNotextIsANumber_ThenReturnsNotFound() {
        let transcriptionsLength: Int = Int.random(in: 5...10)
        
        let transcriptions: [SFTranscription] = (0..<transcriptionsLength).map { i in
            return TranscriptionMock(formattedString: String.randomString)
        }
        let results = SpeechRecognitionResultMock(transcriptions: transcriptions)
        
        let testObject = NumberFilter()
        
        let actualNumber = testObject.getNumberFromRecognitionResults(results)
        
        XCTAssertEqual(actualNumber, NumberFilter.notFound)
    }
//
//    func test_WhenReceiveListenerTextRecognizedEvent_AndTextIsIncorrectNumber_TellsDelegateAnswerIsWrong() {
//        let numberFilter = NumberFilterMock()
//        let testCard = Card.testInstance
//        let cardDeck = CardDeck(cards: [testCard])
//
//        let transcription = TranscriptionMock(formattedString: "")
//        let result = SpeechRecognitionResultMock(transcriptions: [transcription])
//
//        let testObject = CardModel(cardDeck: cardDeck, numberRecognizer: NumberRecognizerMock(), numberFilter: numberFilter)
//        testObject.delegate = self
//
//        let _ = testObject.nextCard()
//
//        let wrongAnswer = testCard.answer + Int.random(in: 1...10)
//        numberFilter.getNumberFromTranscriptionText_returnValues = [wrongAnswer]
//        testObject.numberRecognizerEvent_receivedFinalResult(result: result)
//
//        XCTAssertEqual(cardModelEvent_wrongAnswerRecognized_counter, 1)
//    }
//
//    func test_WhenReceiveListenerTextRecognizedEvent_AndNoCurrentCard_TellsDelegateAnswerIsCorrect() {
//        let numberFilter = NumberFilterMock()
//        let cardDeck = emptyCardDeck
//
//        let testObject = CardModel(cardDeck: cardDeck, numberRecognizer: NumberRecognizerMock(), numberFilter: numberFilter)
//        testObject.delegate = self
//
//        let _ = testObject.nextCard()
//
//        testObject.numberRecognizerEvent_textRecognized(text: String("the right answer"))
//
//        XCTAssertEqual(cardModelEvent_correctAnswerRecognized_counter, 0)
//    }
}

extension NumberFilterTest {
    var validTestNumber: (Int, String) {
        let expectedNumber = Int.random(in: 0...9)
        
        return (expectedNumber, NumberFilter().numberWords[expectedNumber].randomElement()!)
    }
}

class SpeechRecognitionResultMock: SFSpeechRecognitionResult {
    
    override convenience init() {
        self.init(transcriptions: [])
    }
    
    let transcriptionsReturn: [SFTranscription]
    init(transcriptions: [SFTranscription]) {
        transcriptionsReturn = transcriptions
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var bestTranscription: SFTranscription {
        return transcriptionsReturn[0]
    }
    
    override var transcriptions: [SFTranscription] {
        return transcriptionsReturn
    }
}

class TranscriptionMock: SFTranscription {
    let formattedStringReturn: String
    init(formattedString: String) {
        formattedStringReturn = formattedString
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var formattedString: String {
        return formattedStringReturn
    }
}
