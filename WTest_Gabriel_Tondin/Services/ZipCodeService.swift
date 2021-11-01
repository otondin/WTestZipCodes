//
//  ZipCodeServie.swift
//  WTest_Gabriel_Tondin
//
//  Created by Gabriel Tondin on 29/10/2021.
//

import Foundation

struct ZipCodesService {
    
    private static let repository = UserDefaults.standard
    private static let endpoint = "https://raw.githubusercontent.com/centraldedados/codigos_postais/master/data/codigos_postais.csv"
    private static let session = URLSession.shared
    
    typealias ZipCodesServicesHandler = Result<[ZipCodeModel], ZipCodeServiceError>
    
    static func fetch(items: Int, handler: @escaping (ZipCodesServicesHandler) -> Void) {
        if let zipCodeFileURL = repository.url(forKey: "zipCodes") {
            do {
                let content = try String(contentsOf: zipCodeFileURL, encoding: .utf8)
                let parsedCSV: [String] = content.components(separatedBy: "\n")
                var zipCodes = [ZipCodeModel]()
                for i in 0..<items {
                    guard i > 0 else { continue }
                    let item = parsedCSV[i].components(separatedBy: ",")
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: item, options: JSONSerialization.WritingOptions.prettyPrinted)
                        let zipCode = try JSONDecoder().decode(ZipCodeModel.self, from: jsonData)
                        zipCodes.append(zipCode)
                    } catch {
//                        handler(.failure(.onDecodingData)
                        zipCodes = ZipCodeModel.mock
                    }
                }
                handler(.success(zipCodes))
            } catch {
                handler(.failure(.onReadingData))
            }
        } else {
            guard let url = URL(string: endpoint) else {
                handler(.failure(.invalidURL))
                return
            }
            let task = session.downloadTask(with: url) { localUrl, response, error in
                guard let response = response else {
                    handler(.failure(.noResponse))
                    return
                }
                print(response)
                guard let url = localUrl else {
                    handler(.failure(.noData))
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
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: item, options: JSONSerialization.WritingOptions.prettyPrinted)
                            let zipCode = try JSONDecoder().decode(ZipCodeModel.self, from: jsonData)
                            zipCodes.append(zipCode)
                            handler(.success(zipCodes))
                        } catch {
//                            handler(.failure(.onDecodingData)
                            zipCodes = ZipCodeModel.mock
                        }
                    }
                } catch {
                    handler(.failure(.onReadingData))
                }
            }
            task.resume()
        }
    }
}

enum ZipCodeServiceError: Error {
    case invalidURL
    case noData
    case noResponse
    case onReadingData
    case onDecodingData
}

