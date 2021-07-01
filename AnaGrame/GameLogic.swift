//
//  GameLogic.swift
//  AnaGrame
//
//  Created by Terry Kuo on 2021/7/1.
//

import UIKit

class GameLogic {
    
    var usedWords = [String]()
    private var allWords = [String]()
    var currentWord: String? = ""
    
    private func isPossible(word: String) -> Bool {
        guard var tempWord = currentWord?.lowercased() else { return  false}
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
        
    }
    
    private func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }
    
    private func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func submit(_ answer: String,view: UIViewController, handler: () -> Void) {
        let lowerAnswer = answer.lowercased()
        let alertTitle: String
        let alertMessage: String
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) { //the word hasn't benn used yet
                if isReal(word: lowerAnswer) { //the word is a real word
                    usedWords.insert(answer, at: 0) //insert the new word in usedWords array at index 0
                    handler()
                    return
                } else {
                    alertTitle = "Word not recognised"
                    alertMessage = "You can't just make them up, you know!"
                }
            } else {
                alertTitle = "Word used Already"
                alertMessage = "Be more original!"
            }
        } else {
            guard let title = currentWord?.lowercased() else {
                print("Failed")
                return
            }
            alertTitle = "Word not possible"
            alertMessage = "You can't spell that word from \(title)"
        }
        
        let ac = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        view.present(ac, animated: true, completion: nil)
    }
    
    func getAllWords() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
    }
    
    func getCurrentWord() -> String {
        return allWords.randomElement() ?? "Unknowned"
    }
}
