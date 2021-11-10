//
//  ZipCodeListViewModel.swift
//  WTest_Gabriel_Tondin
//
//  Created by Gabriel Tondin on 29/10/2021.
//

import Foundation

protocol ZipCodeListViewModelProtocol {
    func fetchAllZipCodes(completion: @escaping ([ZipCodeModel]?) -> Void)
}

protocol ZipCodeListViewModelOutput {
    func showErrorMessage(with message: String)
}

class ZipCodeListViewModel {
    private let service = ZipCodesService()
    var delegate: ZipCodeListViewModelOutput?
    
    public init() {}
}

extension ZipCodeListViewModel: ZipCodeListViewModelProtocol {
    func fetchAllZipCodes(completion: @escaping ([ZipCodeModel]?) -> Void) {
        service.fetch(items: 50) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.delegate?.showErrorMessage(with: error.localizedDescription)
                completion(nil)
            case .success(let data):
                completion(data)
            }
        }
    }
}

