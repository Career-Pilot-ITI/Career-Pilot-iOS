//
//  OnBordingEndPointes.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 19/07/2026.
//

import Foundation


enum OnBordingEndPointes: APIEndpoint{

    case getAllTrackes
    
    var baseURL: String{
        ""
    }
    
    var path: String{
        switch self{
        case.getAllTrackes:
            return "api/v1/tracks"
        }
    }
    
    var method: HTTPMethod{
        switch self{
        case.getAllTrackes:
            return.get
        }
    }
    
}
