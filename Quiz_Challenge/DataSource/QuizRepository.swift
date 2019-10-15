//
//  QuizRepository.swift
//  Quiz_Challenge
//
//  Created by Rafael Martins on 05/10/19.
//  Copyright © 2019 Rafael Martins. All rights reserved.
//

import Foundation

typealias QuizWordsCallback = (Result<RightWords, Error>) -> Void

final class QuizRepository {
    private let remoteSource: QuizRemoteDataSource
    
    init(remoteSource: QuizRemoteDataSource = QuizRemoteSource()) {
        self.remoteSource = remoteSource
    }
    
    func fetchFromRemote(completion: @escaping QuizWordsCallback) {
        remoteSource.getRightWords { result in
            switch result {
            case let .success(javaWords):
                completion(.success(javaWords))
            case let .failure(error):
                completion(.failure(error))
            }
    }
    }
}
