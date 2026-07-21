//
//  UploadeCvErrors.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 16/07/2026.
//

import Foundation

enum UploadCVErrors: Error{
    case CanNotUploadCv
    
    var description: String{
        switch self{
        case.CanNotUploadCv:
            return "Can Not Uplad This Cv"
        }
    }
}
