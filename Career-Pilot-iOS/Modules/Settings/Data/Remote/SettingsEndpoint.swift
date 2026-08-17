//
//  SettingsEndpoint.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 22/07/2026.
//

import Foundation
enum SettingsEndpoint : APIEndpoint{
    case logout
    case getUserData
    case getSubscribtionsPrice
    case updateUserData(UpdateProfileRequestDTO)
    case updataUserCv
    case updateUserAvatar(AvatarUploadDTO)
    case getCurrentSubscribtion
    case downgradeSubscribtion
    case cancelSubscribtion
    
    var path: String{
        switch self {
        case.getUserData:
            return "api/v1/profile"
        case .getSubscribtionsPrice:
            return "api/v1/subscriptions/tiers"
        case .logout:
            return "api/v1/auth/logout"
        case.updateUserData:
            return "api/v1/profile"
        case .updateUserAvatar:
            return "api/v1/files/upload"
        case .updataUserCv:
            return "api/v1/updateCv"
        case .getCurrentSubscribtion:
            return "api/v1/subscriptions/current"
        case .downgradeSubscribtion:
            return "api/v1/subscriptions/downgrade"
        case .cancelSubscribtion:
            return "api/v1/subscriptions/cancel"
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case.getUserData  :
            return .get
        case .getSubscribtionsPrice, .getCurrentSubscribtion :
            return .get
        case .updateUserData , .updataUserCv :
            return .patch
        case  .logout , .updateUserAvatar ,.downgradeSubscribtion , .cancelSubscribtion:
            return .post
            
        }
    }
    var body: Data? {
        switch self {
        case .getUserData ,.logout ,.getSubscribtionsPrice , .updataUserCv , .getCurrentSubscribtion , .downgradeSubscribtion ,.cancelSubscribtion:
            return nil
        case .updateUserData(let userData):
            return Self.encode(userData)
        case .updateUserAvatar(let avatar):
            return buildMultipartBody(dto: avatar)
    
        
        }
        }
    var requiresAuthentication: Bool {
            true
        }
    var headers: [String: String] {
        let tokenString :String
        do {
                  
                  if let tokens = try KeychainAuthTokenStore().loadTokens() {
                      print("Token is \(tokens.accessToken)")
                      tokenString = tokens.accessToken
                      
                  } else {
                      tokenString = ""
                      print("Token is not found")

                  }
              } catch {
                  tokenString = ""
              }



        switch self {
        case .getUserData , .logout , .getSubscribtionsPrice , .updateUserData(_) , .updataUserCv , .getCurrentSubscribtion , .downgradeSubscribtion ,.cancelSubscribtion  :
          return  [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(tokenString)"
            ]
        case .updateUserAvatar(let avatar) :
          return  [
            "Content-Type": "multipart/form-data; boundary=\(avatar.boundry)",
                "Authorization": "Bearer \(tokenString)"
            ]
     
        }


    }
    
    private func buildMultipartBody(dto: AvatarUploadDTO) -> Data {
        var body = Data()
        let lineBreak = "\r\n"
        let boundary = dto.boundry
        
        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"type\"\(lineBreak)\(lineBreak)".data(using: .utf8)!)
        body.append("\(dto.fileType)\(lineBreak)".data(using: .utf8)!)
        
        body.append("--\(boundary)\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"avatar.jpg\"\(lineBreak)".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\(lineBreak)\(lineBreak)".data(using: .utf8)!)
        body.append(dto.imageData)
        body.append(lineBreak.data(using: .utf8)!)
        
        body.append("--\(boundary)--\(lineBreak)".data(using: .utf8)!)
        
        return body
    }

    
    
    
    
}
