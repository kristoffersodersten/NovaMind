import AVFoundation
import Speech
import SwiftUI


// MARK: - Voice Input Manager
class VoiceInputManager: NSObject, ObservableObject {
    @Published var isListening = false
    @Published var isProcessing = false
    @Published var transcribedText = ""
    @Published var isHandsFreeMode = false
    @Published var hasPermission = false
    @Published var errorMessage: String?
    @Published var visualizationData: [Float] = Array(repeating: 0.0, count: 10)

    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioEngine: AVAudioEngine?
    private var displayLink: CADisplayLink?

    // KrilleCore2030 measurements
    private let sampleRate: Double = 44100
    private let bufferSize: AVAudioFrameCount = 1024

    override init() {
        super.init()
        setupSpeechRecognition()
        setupAudioEngine()
    }

    // MARK: - Setup Methods
    private func setupSpeechRecognition() {
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "sv-SE")) // Swedish

        guard let speechRecognizer = speechRecognizer else {
            errorMessage = "Speech recognizer not available"
            return
        }

        speechRecognizer.delegate = self
    }

    private func setupAudioEngine() {
        audioEngine = AVAudioEngine()
    }

    // MARK: - Permission Handling
    func requestPermissions() {
        SFSpeechRecognizer.requestAuthorization { [weak self] authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    self?.hasPermission = true
                    self?.requestMicrophonePermission()
                case .denied, .restricted, .notDetermined:
                    self?.hasPermission = false
                    self?.errorMessage = "Speech recognition permission denied"
                @unknown default:
                    self?.hasPermission = false
                }
            }
        }
    }

    private func requestMicrophonePermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
            DispatchQueue.main.async {
                if !granted {
                    self?.hasPermission = false
                    self?.errorMessage = "Microphone permission denied"
                }
            }
        }
    }

    // MARK: - Voice Recognition
    
    private func setupAudioSession() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    }
    
    private func handleRecognitionError(_ error: Error) {
        errorMessage = error.localizedDescription
        stopListening()
    }

    func startListening() {
        guard hasPermission else {
            requestPermissions()
            return
        }

        guard let speechRecognizer = speechRecognizer,
              speechRecognizer.isAvailable else {
            errorMessage = "Speech recognizer not available"
            return
        }

        // Cancel any previous task
        stopListening()

        do {
            try setupAudioSession()
        } catch {
            errorMessage = "Audio session setup failed: \(error.localizedDescription)"
            return
        }

        guard let audioEngine = audioEngine else { return }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }

        recognitionRequest.shouldReportPartialResults = true

        // Setup audio input
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        inputNode.installTap(onBus: 0, bufferSize: bufferSize, format: recordingFormat) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
            self?.updateVisualizationData(from: buffer)
        }

        audioEngine.prepare()

        do {
            try audioEngine.start()
            isListening = true
            isProcessing = true
            transcribedText = ""
            errorMessage = nil
            startVisualization()

            recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
                DispatchQueue.main.async {
                    if let result = result {
                        self?.transcribedText = result.bestTranscription.formattedString
                        self?.isProcessing = !result.isFinal
                    }

                    if let error = error {
                        self?.handleRecognitionError(error)
                    }
                }
            }
        } catch {
            errorMessage = "Audio engine start failed: \(error.localizedDescription)"
            stopListening()
        }
    }

    func stopListening() {
        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()

        recognitionRequest = nil
        recognitionTask = nil

        isListening = false
        isProcessing = false
        stopVisualization()

        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(false, options: .notifyOthersOnDeactivation)
    }

    func toggleListening() {
        if isListening {
            stopListening()
        } else {
            startListening()
        }
    }

    func toggleHandsFreeMode() {
        isHandsFreeMode.toggle()
        if isHandsFreeMode {
            startListening()
        } else {
            stopListening()
        }
    }

    // MARK: - Audio Visualization
    private func updateVisualizationData(from buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        let frameLength = Int(buffer.frameLength)

        let samples = Array(UnsafeBufferPointer(start: channelData, count: frameLength))
        let chunkSize = frameLength / visualizationData.count

        var newData: [Float] = []

        for index in 0..<visualizationData.count {
            let startIndex = index * chunkSize
            let endIndex = min(startIndex + chunkSize, frameLength)

            let chunk = Array(samples[startIndex..<endIndex])
            let rms = sqrt(chunk.map { $0 * $0 }.reduce(0, +) / Float(chunk.count))
            newData.append(min(rms * 10, 1.0)) // Scale and clamp
        }

        DispatchQueue.main.async {
            self.visualizationData = newData
        }
    }

    private func startVisualization() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateVisualization))
        displayLink?.add(to: .main, forMode: .common)
    }

    private func stopVisualization() {
        displayLink?.invalidate()
        displayLink = nil

        DispatchQueue.main.async {
            self.visualizationData = Array(repeating: 0.0, count: 10)
        }
    }

    @objc private func updateVisualization() {
        // Visualization updates are handled in updateVisualizationData
    }

    // MARK: - Text Processing
    func clearTranscription() {
        transcribedText = ""
    }

    func processTranscription() -> String {
        let processed = transcribedText.trimmingCharacters(in: .whitespacesAndNewlines)
        clearTranscription()
        return processed
    }
}

// MARK: - Speech Recognizer Delegate
extension VoiceInputManager: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        DispatchQueue.main.async {
            if !available {
                self.stopListening()
                self.errorMessage = "Speech recognizer became unavailable"
            }
        }
    }
}

// MARK: - Voice Input View Component
struct VoiceInputView: View {
    @ObservedObject var voiceManager: VoiceInputManager
    @Binding var inputText: String

    @State private var pulseAnimation = false
    @State private var waveAnimation = false

    var body: some View {
        VStack(spacing: 12) {
            // MARK: - Microphone Button
            Button {
                voiceManager.toggleListening()
            } label: {
                ZStack {
                    // Background circle
                    Circle()
                        .fill(voiceManager.isListening ? Color.glow : Color.novaGray)
                        .frame(width: 48, height: 48)
                        .scaleEffect(pulseAnimation ? 1.1 : 1.0)
                        .animation(
                            voiceManager.isListening ?
                                .easeInOut(duration: 0.8).repeatForever(autoreverses: true) :
                                .easeInOut(duration: 0.2),
                            value: pulseAnimation
                        )

                    // Microphone icon
                    Image(systemName: voiceManager.isListening ? "mic.fill" : "mic")
                        .systemFont(Font.system(size: 20, weight: .medium))
                        .foregroundColor(voiceManager.isListening ? .novaBsack : .foregroundPrimary)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .onAppear {
                pulseAnimation = voiceManager.isListening
            }
            .onChange(of: voiceManager.isListening) { listening in
                pulseAnimation = listening
            }

            // MARK: - Audio Visualization
            if voiceManager.isListening {
                HStack(spacing: 3) {
                    ForEach(0..<voiceManager.visualizationData.count, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.glow)
                            .frame(width: 3, height: max(4, CGFloat(voiceManager.visualizationData[index]) * 30))
                            .animation(.easeInOut(duration: 0.1), value: voiceManager.visualizationData[index])
                    }
                }
                .frame(height: 32)
                .transition(.opacity)
            }

            // MARK: - Transcribed Text Preview
            if !voiceManager.transcribedText.isEmpty {
                Text(voiceManager.transcribedText)
                    .systemFont(Font.custom("SF Pro", size: 12))
                    .foregroundColor(.foregroundSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.novaGray.opacity(0.5))
                    .cornerRadius(8)
                    .transition(.opacity.combined(with: .scale))
            }

            // MARK: - Hands-Free Toggle
            HStack {
                Image(systemName: "hands.and.sparkles")
                    .systemFont(Font.system(size: 12))
                    .foregroundColor(.glow)

                Text("Handsfree")
                    .systemFont(Font.custom("SF Pro", size: 12))
                    .foregroundColor(.foregroundPrimary)

                Toggle("", isOn: $voiceManager.isHandsFreeMode)
                    .toggleStyle(SwitchToggleStyle(tint: .glow))
                    .scaleEffect(0.8)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.novaGray.opacity(0.3))
            .cornerRadius(8)

            // MARK: - Error Message
            if let errorMessage = voiceManager.errorMessage {
                Text(errorMessage)
                    .systemFont(Font.custom("SF Pro", size: 10))
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .transition(.opacity)
            }
        }
        .padding(.padding(.all))
        .onChange(of: voiceManager.transcribedText) { newText in
            if !newText.isEmpty && !voiceManager.isProcessing {
                // Auto-insert transcribed text
                let processed = voiceManager.processTranscription()
                if !processed.isEmpty {
                    inputText += (inputText.isEmpty ? "" : " ") + processed
                }
            }
        }
        .onAppear {
            voiceManager.requestPermissions()
        }
    }
}

// MARK: - Preview
struct VoiceInputView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceInputView(
            voiceManager: VoiceInputManager(),
            inputText: .constant("")
        )
        .padding(.padding(.all))
    }
}
