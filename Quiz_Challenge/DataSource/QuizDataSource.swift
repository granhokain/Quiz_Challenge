//
//  QuizDataSource.swift
//  Quiz_Challenge
//
//  Created by Rafael Martins on 05/10/19.
//  Copyright © 2019 Rafael Martins. All rights reserved.
//

import Foundation

protocol QuizDataSource {
    func getRightWords(completion: @escaping QuizWordsCallback)
}
