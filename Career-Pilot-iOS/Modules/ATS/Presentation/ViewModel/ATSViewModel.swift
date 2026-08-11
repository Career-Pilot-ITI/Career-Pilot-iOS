//
//  ATSViewModel.swift
//  Career-Pilot-iOS
//
//  Created by Moaz on 11/08/2026.
//

import Foundation

class ATSViewModel : ObservableObject {
    private let getJobUseCase: GetJobByURLUseCase
    
    init(getJobUseCase: GetJobByURLUseCase) {
        self.getJobUseCase = getJobUseCase
    }
    
    func fireRequest() async {
        do {
            let result = try await getJobUseCase.execute("https://www.linkedin.com/jobs/view/4288462516/")
            print(result)
        } catch(let error) {
            print("Error is \(error)")
        }
    }
}
