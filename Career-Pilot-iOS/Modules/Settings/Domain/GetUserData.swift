//
//  GetUserData.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 17/07/2026.
//

import Foundation
class GetUserDataUseCase{
    var profileProtocolRepo : ProfileProtocolRepo
    
    init(profileProtocolRepo: ProfileProtocolRepo) {
        self.profileProtocolRepo = profileProtocolRepo
    }
    func getData() {
        profileProtocolRepo.fetchUserData(id: "10")
    }
    
}
