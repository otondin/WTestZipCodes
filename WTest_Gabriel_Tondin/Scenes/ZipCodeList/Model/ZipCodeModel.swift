//
//  ZipCodeModel.swift
//  WTest_Gabriel_Tondin
//
//  Created by Gabriel Tondin on 29/10/2021.
//

import Foundation

struct ZipCodeModel: Codable {
    var id = UUID()
    let codDistrito: String? = nil
    let codConcelho: String? = nil
    let codLocalidade: String? = nil
    let nomeLocalidade: String? = nil
    let codArteria: String? = nil
    let tipoArteria: String? = nil
    let prep1: String? = nil
    let tituloArteria: String? = nil
    let prep2: String? = nil
    let nomeArteria: String? = nil
    let localArteria: String? = nil
    let troco: String? = nil
    let porta: String? = nil
    let cliente: String? = nil
    let numCodPostal: String?
    let extCodPostal: String? = nil
    let desigPostal: String?
    
    init(numCodPostal: String, desigPostal: String) {
        self.numCodPostal = numCodPostal
        self.desigPostal = desigPostal
    }

    enum CodingKeys: String, CodingKey {
        case codDistrito = "cod_distrito"
        case codConcelho = "cod_concelho"
        case codLocalidade = "cod_localidade"
        case nomeLocalidade = "nome_localidade"
        case codArteria = "cod_arteria"
        case tipoArteria = "tipo_arteria"
        case tituloArteria = "titulo_arteria"
        case nomeArteria = "nome_arteria"
        case localArteria = "local_arteria"
        case numCodPostal = "num_cod_postal"
        case extCodPostal = "ext_cod_postal"
        case desigPostal = "desig_postal"
    }

}

extension ZipCodeModel {
    static let mock = [
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
        ZipCodeModel(numCodPostal: "2900-256", desigPostal: "Foobar"),
    ]
}
