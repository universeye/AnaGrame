//
//  ViewController.swift
//  AnaGrame
//
//  Created by Terry Kuo on 2021/6/29.
//

import UIKit

class ViewController: UITableViewController {
    
    private let gameLogic = GameLogic()
    
    lazy var addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = addButton
        gameLogic.getAllWords()
        
        startGame()
    }
    
    private func startGame() {
        title = gameLogic.getCurrentWord()
        gameLogic.currentWord = title ?? "Unknowned title"
        gameLogic.usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc private func promptForAnswer() {
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let self = self else { return }
            guard let answer = ac?.textFields?[0].text else { return }
            
            self.gameLogic.submit(answer, view: self) {
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(submitAction)
        present(ac, animated: true, completion: nil)
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameLogic.usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = gameLogic.usedWords[indexPath.row]
        
        return cell
    }

}

