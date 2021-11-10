//
//  ZipCodeListViewModel.swift
//  WTest_Gabriel_Tondin
//
//  Created by Gabriel Tondin on 29/10/2021.
//

import Foundation

// MARK:- ZipCodeListViewModelInput Protocol

protocol ZipCodeListViewModelInput {
    func fetchData()
}

// MARK:- ZipCodeListViewModelOutput Protocol

protocol ZipCodeListViewModelOutput {
    func showError(with message: String)
    func pull(data: [ZipCodeModel])
}

class ZipCodeListViewModel {
    var delegate: ZipCodeListViewModelOutput?
}

// MARK:- ZipCodeListViewModelOutput extension

extension ZipCodeListViewModel: ZipCodeListViewModelInput {
    func fetchData() {
        ZipCodesService().fetchZipCodes(with: 100) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.delegate?.showError(with: error.localizedDescription)
            case .success(let data):
                self?.delegate?.pull(data: data)
            }
        }
    }
}
