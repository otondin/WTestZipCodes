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

class ZipCodeListViewModel { }

extension ZipCodeListViewModel: ZipCodeListViewModelDelegate {
    func fetchAllZipCodes(completion: @escaping ([ZipCodeModel]?) -> Void) {
        ZipCodesService.fetch(items: 20) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            case .success(let data):
                print(data)
                completion(ZipCodeModel.mock)
            }
        }
    }
}

