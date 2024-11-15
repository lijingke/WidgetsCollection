//
//  AudioPlayer.swift
//  WidgetsCollection
//
//  Created by 李京珂 on 2024/7/15.
//

import AVFoundation
import Foundation

public enum AudioPlayerError: Error {
    case fileExtension, fileNotFound
}

public class AudioPlayer: NSObject {
    public static let SoundDidFinishPlayingNotification = Notification.Name(rawValue: "SoundDidFinishPlayingNotification")
    public static let StopPlayingNotification = Notification.Name(rawValue: "StopPlayingNotification")

    public static let SoundDidFinishPlayingSuccessfully = "success"
    public typealias SoundDidFinishCompletion = (_ didFinish: Bool) -> Void

    // MARK: Properties

    /// Name of the used to initialize the object
    public var name: String?

    /// URL of the used to initialize the object
    public let url: URL?

    /// A callback closure that will be called when the audio finishes playing, or is stopped.
    public var completionHandler: SoundDidFinishCompletion?

    /// is it playing or not?
    public var isPlaying: Bool {
        if let nonNilsound = sound {
            return nonNilsound.isPlaying
        }
        return false
    }

    /// the duration of the sound.
    public var duration: TimeInterval {
        if let nonNilsound = sound {
            return nonNilsound.duration
        }
        return 0.0
    }

    /// currentTime is the offset into the sound of the current playback position.
    public var currentTime: TimeInterval {
        get {
            if let nonNilsound = sound {
                return nonNilsound.currentTime
            }
            return 0.0
        }
        set {
            sound?.currentTime = newValue
        }
    }

    /// The volume for the sound. The nominal range is from 0.0 to 1.0.
    public var volume: Float = 1.0 {
        didSet {
            volume = min(1.0, max(0.0, volume))
            targetVolume = volume
        }
    }

    /// "numberOfLoops" is the number of times that the sound will return to the beginning upon reaching the end.
    /// A value of zero means to play the sound just once.
    /// A value of one will result in playing the sound twice, and so on..
    /// Any negative number will loop indefinitely until stopped.
    public var numberOfLoops: Int = 0 {
        didSet {
            sound?.numberOfLoops = numberOfLoops
        }
    }

    /// set panning. -1.0 is left, 0.0 is center, 1.0 is right.
    public var pan: Float = 0.0 {
        didSet {
            sound?.pan = pan
        }
    }

    // MARK: Private properties

    fileprivate let sound: AVAudioPlayer?
    fileprivate var startVolume: Float = 1.0
    fileprivate var targetVolume: Float = 1.0 {
        didSet {
            sound?.volume = targetVolume
        }
    }

    fileprivate var fadeTime: TimeInterval = 0.0
    fileprivate var fadeStart: TimeInterval = 0.0
    fileprivate var timer: Timer?

    // MARK: Init

    public convenience init(fileName: String) throws {
        let soundFileComponents = fileName.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: ".")
        guard soundFileComponents.count == 2 else {
            throw AudioPlayerError.fileExtension
        }

        guard let url = Bundle.main.url(forResource: soundFileComponents[0], withExtension: soundFileComponents[1]) else {
            throw AudioPlayerError.fileNotFound
        }
        try self.init(contentsOf: url)
    }

    public convenience init(contentsOfPath path: String) throws {
        let fileURL = URL(fileURLWithPath: path)
        try self.init(contentsOf: fileURL)
    }

    public init(contentsOf url: URL) throws {
        self.url = url
        name = url.lastPathComponent
        sound = try AVAudioPlayer(contentsOf: url as URL)
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.ambient)
        super.init()
        sound?.delegate = self
    }

    deinit {
        timer?.invalidate()
        sound?.delegate = nil
    }
}

// MARK: - Play / Stop

public extension AudioPlayer {
    func play(withDelay delay: Int = 0) {
        if isPlaying == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay)) {
                self.sound?.play()
            }
        }
    }

    func stop() {
        if isPlaying {
            sound?.currentTime = 0
            soundDidFinishPlaying(successfully: false)
        }
    }

    func pause() {
        if isPlaying {
            sound?.pause()
        }
    }
}

// MARK: - Fade

public extension AudioPlayer {
    func fadeTo(volume: Float, duration: TimeInterval = 1.0) {
        startVolume = sound?.volume ?? 1
        targetVolume = volume
        fadeTime = duration
        fadeStart = NSDate().timeIntervalSinceReferenceDate
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.015, target: self, selector: #selector(handleFadeTo), userInfo: nil, repeats: true)
        }
    }

    func fadeIn(duration: TimeInterval = 1.0) {
        volume = 0.0
        fadeTo(volume: 1.0, duration: duration)
    }

    func fadeOut(duration: TimeInterval = 1.0) {
        fadeTo(volume: 0.0, duration: duration)
    }

    @objc internal func handleFadeTo() {
        let now = NSDate().timeIntervalSinceReferenceDate
        let delta: Float = (Float(now - fadeStart) / Float(fadeTime) * (targetVolume - startVolume))
        let volume = startVolume + delta
        sound?.volume = volume
        if delta > 0.0 && volume >= targetVolume ||
            delta < 0.0 && volume <= targetVolume || delta == 0.0
        {
            sound?.volume = targetVolume
            timer?.invalidate()
            timer = nil
            if sound?.volume == 0 {
                stop()
            }
        }
    }
}

// MARK: - AVAudioPlayerDelegate

extension AudioPlayer: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_: AVAudioPlayer, successfully flag: Bool) {
        soundDidFinishPlaying(successfully: flag)
    }

    fileprivate func soundDidFinishPlaying(successfully flag: Bool) {
        sound?.stop()
        timer?.invalidate()
        timer = nil

        if let nonNilCompletionHandler = completionHandler {
            nonNilCompletionHandler(flag)
        }

        let success = [AudioPlayer.SoundDidFinishPlayingSuccessfully: flag]
        NotificationCenter.default.post(name: AudioPlayer.SoundDidFinishPlayingNotification, object: self, userInfo: success)
    }
}
