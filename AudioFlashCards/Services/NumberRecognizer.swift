import Foundation
import Speech

protocol NumberRecognizerDelegate: class {
    func numberRecognizerEvent_textRecognized(text: String)
}

// Code here is lifted liberally from Apple's Spoken Word demo
// Details here: https://developer.apple.com/documentation/speech/recognizing_speech_in_live_audio
class NumberRecognizer: NSObject {
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var inputNode: AVAudioInputNode?
    
    weak var delegate: NumberRecognizerDelegate?
    
    override init() {
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
        
        super.init()
        speechRecognizer.delegate = self
    }
    
    func startListening() throws {
                
        // Cancel the previous task if it's running.
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        // Configure the audio session for the app.
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        inputNode = audioEngine.inputNode

        // Create and configure the speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        
        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
         recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: handleRecognitionResult)
//        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, delegate: self) // resultHandler: handleRecognitionResult)
        
        // Configure the microphone input.
        let recordingFormat = inputNode!.outputFormat(forBus: 0)
        inputNode!.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
    }
    
    func handleRecognitionResult(result: SFSpeechRecognitionResult?, error: Error?) {
        var isFinal = false
        
        if let result = result {
            let text = result.transcriptions.map { $0.formattedString }.joined(separator: "\n")

            delegate?.numberRecognizerEvent_textRecognized(text: text)
            
            isFinal = result.isFinal
        }
        
        if error != nil || isFinal {
            // Stop recognizing speech if there is a problem.
            self.audioEngine.stop()
            inputNode!.removeTap(onBus: 0)
            
            self.recognitionRequest = nil
            self.recognitionTask = nil
        }
    }
}

extension NumberRecognizer: SFSpeechRecognizerDelegate {

    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        // TODO Handle availability changing
    }
}
