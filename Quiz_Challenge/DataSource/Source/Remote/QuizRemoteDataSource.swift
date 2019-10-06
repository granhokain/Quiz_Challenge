//
//  QuizRemoteDataSource.swift
//  Quiz_Challenge
//
//  Created by Rafael Martins on 05/10/19.
//  Copyright © 2019 Rafael Martins. All rights reserved.
//

import Foundation

protocol QuizRemoteDataSource: QuizDataSource {}

final class QuizRemoteSource: QuizRemoteDataSource {
    
    func getRightWords(completion: @escaping QuizWordsCallback) {
        let jsonUrlString = "https://codechallenge.arctouch.com/quiz/1"
        
        guard let url = URL(string: jsonUrlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) {
            (data, response, err) in
            
            if let data = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                        return
                    }
                    let wordsResponse = RightWords(json: json)
                    DispatchQueue.main.async { completion(.success(wordsResponse)) }
                }catch let jsonErr {
                    print("Error serializing json", jsonErr)
                }
            } else {
                DispatchQueue.main.async { completion(.failure(RuntimeError("Unable to fetch response from API"))) }
            }

        }.resume()
    }
}
