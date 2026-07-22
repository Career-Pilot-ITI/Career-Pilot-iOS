//
//  ProfileProtocolRepo.swift
//  Career-Pilot-iOS
//
//  Created by Eyad waleed on 17/07/2026.
//

import Foundation
protocol  ProfileProtocolRepo{
    func fetchUserData(id : String) -> User 
}
