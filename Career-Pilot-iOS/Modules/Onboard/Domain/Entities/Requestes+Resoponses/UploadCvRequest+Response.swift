//
//  UploadCvReques+Response.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 17/07/2026.
//

import Foundation

struct UploadCvRequest{
    var cv: URL
}

struct UploadCvResponse{
    var userData: OnBoardingUser
}
