//
//  MicrophonePermissionManager.swift
//  Career-Pilot-iOS
//
//  Created by Ahmed El-Sayyad Mohamed on 26/07/2026.
//

import AVFoundation

protocol MicrophonePermissionManaging {
    func permissionStatus() -> AVAudioSession.RecordPermission
    func requestPermission(_ completion: @escaping (Bool) -> Void)
}

final class MicrophonePermissionManager: MicrophonePermissionManaging {

    func permissionStatus() -> AVAudioSession.RecordPermission {
        AVAudioSession.sharedInstance().recordPermission
    }

    func requestPermission(_ completion: @escaping (Bool) -> Void) {

        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
}
