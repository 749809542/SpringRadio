//
//  JLASAudioPlayer.swift
//  SpringRadio
//
//  Created by jack on 2020/4/19.
//  Copyright © 2020 jack. All rights reserved.
//

import AVFoundation
import AVKit
import MediaPlayer

let bufferSize = 8192

class JLASAudioPlayer: NSObject, AudioPlayer {
    let queue = DispatchQueue(label: "com.springRadio.spectrum")
    lazy var audioPlayer: Streamer = {
        let audioPlayer = Streamer()
        audioPlayer.delegate = self
        return audioPlayer
    }()
    var currentAudioStation: Playable?
    var updateSpectrum: (([[Float]]) -> Void)?
    var analyzer:RealtimeAnalyzer = RealtimeAnalyzer(fftSize: bufferSize)
    
    
    override init() {
        super.init()
        self.setupRemoteCommandCenter()
    }
    
    func play<T>(stream item: T?) where T : Playable {
        guard let stream = item?.radioItem.streamURL, let url = URL(string: stream.rawValue) else {
                   fatalError("=========== Can`t play stream ===========")
               }
               
               if let station = self.currentAudioStation  {
                   if station.radioItem.streamURL != item?.radioItem.streamURL {
                       self.currentAudioStation?.isPlaying = false
                       self.currentAudioStation?.streamTitle = defaultStreamTitle
                   }
               }
               
               self.currentAudioStation = item
        audioPlayer.url = url
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.audioPlayer.play()
        }
        
    }
    
    func stop() {
        audioPlayer.stop()
    }
    
    
}