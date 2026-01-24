//
//  SpeechRecognizerClient.swift
//  Simplest_widgets
//
//  Created for TCA refactoring
//

import Foundation
import Speech
import AVFoundation
import ComposableArchitecture

// MARK: - SpeechRecognizerClient

@DependencyClient
struct SpeechRecognizerClient {
    var requestAuthorization: () async -> SFSpeechRecognizerAuthorizationStatus = { .denied }
    var startTranscribing: () -> AsyncStream<String> = { AsyncStream { _ in } }
    var stopTranscribing: () async -> Void
}

// MARK: - SpeechRecognizerError

enum SpeechRecognizerError: Error, Equatable {
    case notAuthorized
    case recognizerNotAvailable
    case audioSessionFailed(String)
}

// MARK: - Live Implementation

private actor SpeechRecognizerActor {
    private var audioEngine: AVAudioEngine?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))

    func requestAuthorization() async -> SFSpeechRecognizerAuthorizationStatus {
        await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }
    }

    func startTranscribing() -> AsyncStream<String> {
        AsyncStream { continuation in
            Task {
                do {
                    try await startRecognition(continuation: continuation)
                } catch {
                    continuation.finish()
                }
            }
        }
    }

    private func startRecognition(continuation: AsyncStream<String>.Continuation) async throws {
        // 이전 세션 정리
        recognitionTask?.cancel()
        recognitionTask = nil

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        audioEngine = AVAudioEngine()

        guard let audioEngine = audioEngine,
              let speechRecognizer = speechRecognizer,
              speechRecognizer.isAvailable else {
            throw SpeechRecognizerError.recognizerNotAvailable
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }

        recognitionRequest.shouldReportPartialResults = true

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)

        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()

        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                let transcribedText = result.bestTranscription.formattedString
                continuation.yield(transcribedText)
            }

            if error != nil || (result?.isFinal ?? false) {
                continuation.finish()
            }
        }
    }

    func stopTranscribing() {
        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()

        audioEngine = nil
        recognitionRequest = nil
        recognitionTask = nil
    }
}

// MARK: - DependencyKey

extension SpeechRecognizerClient: DependencyKey {
    static let liveValue: SpeechRecognizerClient = {
        let actor = SpeechRecognizerActor()

        return SpeechRecognizerClient(
            requestAuthorization: {
                await actor.requestAuthorization()
            },
            startTranscribing: {
                actor.startTranscribing()
            },
            stopTranscribing: {
                await actor.stopTranscribing()
            }
        )
    }()

    static let testValue = SpeechRecognizerClient()
}

// MARK: - DependencyValues Extension

extension DependencyValues {
    var speechRecognizerClient: SpeechRecognizerClient {
        get { self[SpeechRecognizerClient.self] }
        set { self[SpeechRecognizerClient.self] = newValue }
    }
}
