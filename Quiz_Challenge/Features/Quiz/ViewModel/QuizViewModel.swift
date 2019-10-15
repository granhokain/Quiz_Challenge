//
//  QuizViewModel.swift
//  Quiz_Challenge
//
//  Created by Rafael Martins on 05/10/19.
//  Copyright © 2019 Rafael Martins. All rights reserved.
//

import Foundation

final class QuizViewModel{
    private let repository: QuizRepository
    
    var words = [String]()
    var testrespostas: (([String]) -> Void)?
    
    init(repository: QuizRepository = .init()) {
        self.repository = repository
    }
    
    func getQuizWords() {
        repository.fetchFromRemote(){[weak self] result in
            switch result {
            case let .success(javaWords):
                self?.words = javaWords.answer
            case .failure(_):
                break
            }
            
        }
    }
    
    func AnswersTest() -> [String]{
        var wordList = [String]()
        wordList = words
        
        return wordList
    }
}
