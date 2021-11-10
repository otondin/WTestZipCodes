//
//  ZipCodeListViewModel.swift
//  WTest_Gabriel_Tondin
//
//  Created by Gabriel Tondin on 29/10/2021.
//

import Foundation

protocol ZipCodeListViewModelInput {
    func fetchData(items: Int)
}

protocol ZipCodeListViewModelOutput {
    func showError(with message: String)
    func pull(data: [ZipCodeModel])
}

class ZipCodeListViewModel {
    var delegate: ZipCodeListViewModelOutput?
}

extension ZipCodeListViewModel: ZipCodeListViewModelInput {
    func fetchData(items: Int) {
        ZipCodesService().fetchZipCodes(items: items) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.delegate?.showError(with: error.localizedDescription)
            case .success(let data):
                self?.delegate?.pull(data: data)
            }
        }
    }
}
