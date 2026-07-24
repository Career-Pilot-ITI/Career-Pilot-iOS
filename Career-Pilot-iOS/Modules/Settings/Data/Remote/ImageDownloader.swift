//
//  ImageDownloader.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 24/07/2026.
//

import Foundation
import UIKit


 class ImageLoader {
    static func loadImage(from url: URL) async throws -> Data {
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
             let imageData   =  data
            return imageData
        }
        catch{
            print("error in downloading the image \(error)")
            throw error
        }
    }
}

enum ImageLoadingError: Error {
    case invalidData
}
