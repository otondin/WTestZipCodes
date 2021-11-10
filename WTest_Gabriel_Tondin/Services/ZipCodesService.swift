//
//  ZipCodeServie.swift
//  WTest_Gabriel_Tondin
//
//  Created by Gabriel Tondin on 29/10/2021.
//

import Foundation

enum ZipCodeServiceError: Error {
    case invalidURL
    case noResponse
    case noData
}

typealias ZipCodesServicesHandler = Result<[ZipCodeModel], ZipCodeServiceError>

class ZipCodesService {
    private let repository = UserDefaults.standard
    private let session = URLSession.shared
    private let endpoint = "https://raw.githubusercontent.com/centraldedados/codigos_postais/master/data/codigos_postais.csv"
    
    func fetchZipCodes(items: Int, completionHandler: @escaping (ZipCodesServicesHandler) -> Void) {
        if let zipCodeFileURL = repository.url(forKey: "zipCodes") {
            if let parsedCSV = parseCSV(from: zipCodeFileURL) {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: parsedCSV, options: .prettyPrinted)
                    let zipCodes = try JSONDecoder().decode([ZipCodeModel].self, from: jsonData)
                    completionHandler(.success(zipCodes))
                } catch {
                    completionHandler(.failure(.noData))
                }
            } else {
                completionHandler(.failure(.noData))
            }
        } else {
            guard let url = URL(string: endpoint) else {
                completionHandler(.failure(.invalidURL))
                return
            }
            let task = session.downloadTask(with: url) { localUrl, response, error in
                guard let _ = response else {
                    completionHandler(.failure(.noResponse))
                    return
                }
                guard let url = localUrl else {
                    completionHandler(.failure(.noData))
                    return
                }
                self.repository.set(url, forKey: "zipCodes")
                if let parsedCSV = self.parseCSV(from: url) {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: parsedCSV, options: .prettyPrinted)
                        let zipCodes = try JSONDecoder().decode([ZipCodeModel].self, from: jsonData)
                        completionHandler(.success(zipCodes))
                    } catch {
                        completionHandler(.failure(.noData))
                    }
                } else {
                    completionHandler(.failure(.noData))
                }
            }
            task.resume()
        }
    }
}

private extension ZipCodesService {
    func parseCSV(from url: URL) -> [[String: String]]? {
        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            let lines = content.components(separatedBy: "\n")
            let columnNames = lines[0].components(separatedBy: ",")
            var results = [[String: String]]()
//            for line in lines[1..<lines.count] {
            for line in lines[1...100] {
                let fieldValues = line.components(separatedBy: ",")
                var result = [String: String]()
                for i in 0..<fieldValues.count {
                    result.updateValue(fieldValues[i], forKey: columnNames[i])
                }
                results.append(result)
            }
            return results
        } catch {
            return nil
        }
    }
}
