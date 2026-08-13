//
//  CapturedFrame.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 13/08/2026.
//
import CoreGraphics
import Foundation

/// A single sampled frame from the video interview stream.
///
/// Deliberately holds a `CGImage` rather than a `CVPixelBuffer` / `CMSampleBuffer` so this
/// type is safe to store on the view model and pass to the (future) Vision analysis layer
/// without pulling AVFoundation/CoreMedia into anything above the capture service.
struct CapturedFrame {
    let image: CGImage
    /// Seconds since the capture session started (monotonic, from the sample buffer's
    /// presentation timestamp where available).
    let timestamp: TimeInterval
}
