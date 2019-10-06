//
//  RightWords.swift
//  Quiz_Challenge
//
//  Created by Rafael Martins on 05/10/19.
//  Copyright © 2019 Rafael Martins. All rights reserved.
//

import Foundation

struct RightWords: Decodable {
    let question: String
    let answer: [String]
    
    init(json: [String: Any]) {
        self.question = json["question"] as? String ?? ""
        self.answer = json["answer"] as? [String] ?? []
    }
}
