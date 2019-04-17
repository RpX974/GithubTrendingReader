//
//  API.swift
//  NeverLate
//
//  Created by Laurent Grondin on 05/06/2018.
//  Copyright © 2018 LG. All rights reserved.
//

import Foundation

// MARK: - Typealias

typealias ResultCompletion<T> = (Result<T>) -> Void
typealias ResultCompletionWithTU<T, U> = (Result<(T, U)>) -> Void
typealias SuccessCallBack = () -> ()

// MARK: - Enum

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

// MARK: - API

class API {
    
    // MARK: - Enum

    enum ERROR: Error {
        case noData
        case urlFailed
    }
    
    // MARK: - Properties

    static let shared = API()
    
    // MARK: - Custom Functions

    func getUrlString(from language: String, since: Since) -> String{
        switch language {
        case Constants.defaultLanguageUrlParam:
            return String.init(format: Constants.allLanguagesURL, since.rawValue)
        default:
            return String.init(format: Constants.baseUrl, language, since.rawValue)
        }
    }

    func retrieveData<T: Codable>(with url: URL, completion: @escaping ResultCompletion<T>){
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(ERROR.noData))
                return
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
    
    func getTrending<T: Codable>(fromLanguage language: String, since: Since, completion: @escaping ResultCompletion<T>){
        let urlString = self.getUrlString(from: language, since: since)
        guard let url = URL.init(string: urlString) else {
            log_error(ERROR.urlFailed.localizedDescription)
            return
        }
        self.retrieveData(with: url, completion: completion)
    }
    
    func getAllLanguages<T: Codable>(completion: @escaping ResultCompletion<T>){
        let urlString = Constants.languageURL
        guard let url = URL.init(string: urlString) else {
            log_error(ERROR.urlFailed.localizedDescription)
            return
        }
        self.retrieveData(with: url, completion: completion)
    }
}
