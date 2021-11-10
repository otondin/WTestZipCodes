//
//  ZipCodeServie.swift
//  WTest_Gabriel_Tondin
//
//  Created by Gabriel Tondin on 29/10/2021.
//

import Foundation

enum ZipCodeServiceError: Error {
    case invalidURL
    case noData
    case noResponse
    case onReadingData
    case onDecodingData
}

typealias ZipCodesServicesHandler = Result<[ZipCodeModel], ZipCodeServiceError>

struct ZipCodesService {
    private let repository = UserDefaults.standard
    private let endpoint = "https://raw.githubusercontent.com/centraldedados/codigos_postais/master/data/codigos_postais.csv"
    private let session = URLSession.shared
    
    func fetch(items: Int, completionHandler: @escaping (ZipCodesServicesHandler) -> Void) {
        if let zipCodeFileURL = repository.url(forKey: "zipCodes") {
            do {
                let content = try String(contentsOf: zipCodeFileURL, encoding: .utf8)
                let parsedCSV: [String] = content.components(separatedBy: "\n")
                var zipCodes = [ZipCodeModel]()
                for i in 0..<items {
                    guard i > 0 else { continue }
                    let item = parsedCSV[i].components(separatedBy: ",")
                    let zipCode = ZipCodeModel(numCodPostal: item[14], extCodPostal: item[15], desigPostal: item[16])
                    zipCodes.append(zipCode)
                }
                completionHandler(.success(zipCodes))
            } catch {
                completionHandler(.failure(.onReadingData))
            }
        } else {
            guard let url = URL(string: endpoint) else {
                completionHandler(.failure(.invalidURL))
                return
            }
            let task = session.downloadTask(with: url) { localUrl, response, error in
                guard let response = response else {
                    completionHandler(.failure(.noResponse))
                    return
                }
                print(response)
                guard let url = localUrl else {
                    completionHandler(.failure(.noData))
                    return
                }
                repository.set(url, forKey: "zipCodes")
                do {
                    let content = try String(contentsOf: url, encoding: .utf8)
                    let parsedCSV: [String] = content.components(separatedBy: "\n")
                    var zipCodes = [ZipCodeModel]()
                    for i in 0..<parsedCSV.count {
                        guard i > 0 else { continue }
                        let item = parsedCSV[i].components(separatedBy: ",")
                        let zipCode = ZipCodeModel(numCodPostal: item[14], extCodPostal: item[15], desigPostal: item[16])
                        zipCodes.append(zipCode)
                    }
                    completionHandler(.success(zipCodes))
                } catch {
                    completionHandler(.failure(.onReadingData))
                }
            }
            task.resume()
        }
    }
}
