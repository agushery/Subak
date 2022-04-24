//
//  Wordsgenerator.swift
//  Subak
//
//  Created by Agus Hery on 23/04/22.
//

import Foundation

class WordsAPI {
    var words: [String] = ["Bali", "Temple", "Subak", "Rice", "Ritual", "Water", "Unesco", "Prajuru", "Terracing", "TriHitaKarana"]
    var loaded = true
    func getAllWords() -> [String] {
        if loaded {
            return self.words
        }
        else {
            return self.words
        }
    }
}

class WordsGenerator {
    private var wordsAPI: WordsAPI = WordsAPI()

    func generate(n: Int, minLength: Int = 4, maxLength: Int = 25) -> [String] {
        var randomWords: [String] = []

        for _ in 0...100 {
            let tmp: String = wordsAPI.getAllWords().randomElement()!

            if minLength...maxLength ~= tmp.count && !randomWords.contains(tmp) {
                randomWords.append(tmp)
            }

            if randomWords.count >= n {
                return randomWords
            }
        }

        return randomWords
    }
}

