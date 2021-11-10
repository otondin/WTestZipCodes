//
//  ZipCodeListViewModel.swift
//  WTest_Gabriel_Tondin
//
//  Created by Gabriel Tondin on 29/10/2021.
//

import Foundation

protocol ZipCodeListViewModelDelegate {
    func fetchAllZipCodes(completion: @escaping ([ZipCodeModel]?) -> Void)
}

class ZipCodeListViewModel {
    private let service = ZipCodesService()
}

extension ZipCodeListViewModel: ZipCodeListViewModelDelegate {
    func fetchAllZipCodes(completion: @escaping ([ZipCodeModel]?) -> Void) {
        service.fetch(items: 300) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            case .success(let data):
                completion(data)
            }
        }
    }
}

