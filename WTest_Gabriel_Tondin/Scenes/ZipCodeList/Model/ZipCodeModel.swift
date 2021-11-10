//
//  ZipCodeModel.swift
//  WTest_Gabriel_Tondin
//
//  Created by Gabriel Tondin on 29/10/2021.
//

import Foundation

struct ZipCodeModel: Codable {
    var id = UUID()
    let numCodPostal: String
    let extCodPostal: String
    let desigPostal: String
    
    enum CodingKeys: String, CodingKey {
        case numCodPostal = "num_cod_postal"
        case extCodPostal = "ext_cod_postal"
        case desigPostal = "desig_postal"
    }
    
    func getCodPostal() -> String {
        "\(numCodPostal)-\(extCodPostal)"
    }
}

extension ZipCodeModel {
    static let mock = [
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900", extCodPostal: "256", desigPostal: "Foobar"),
    ]
}
