//
//  GameLogic.swift
//  AnaGrame
//
//  Created by Terry Kuo on 2021/7/1.
//
//insert a single roll for tableview, UITextChecker
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
        
        if word.count < 3 {
            return false
        }
        
        if word == currentWord {
            return false
        }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func submit(_ answer: String,view: UIViewController, handler: () -> Void) {
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) { //the word hasn't benn used yet
                if isReal(word: lowerAnswer) { //the word is a real word
                    usedWords.insert(lowerAnswer, at: 0) //insert the new word in usedWords array at index 0
                    handler()
                    return
                } else {
                    showAlert(alertTitle: AgAlert.isRealTitle.rawValue, alertMessage: AgAlert.isRealMessage.rawValue, view: view)
                }
            } else {
                showAlert(alertTitle: AgAlert.isOriginalTitle.rawValue, alertMessage: AgAlert.isOrginalMessage.rawValue, view: view)
            }
        } else {
            guard let title = currentWord?.lowercased() else {
                print("Failed")
                return
            }
            showAlert(alertTitle: AgAlert.isPossibleTitle.rawValue, alertMessage: AgAlert.isPossibleMessage.rawValue + " \(title)", view: view)
        }
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
    
    func showAlert(alertTitle: String, alertMessage: String, view: UIViewController) {
        let ac = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        view.present(ac, animated: true, completion: nil)
    }
}
