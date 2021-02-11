//
//  ViewController.swift
//  Hangman
//
//  Created by Gökberk Köksoy on 28.12.2020.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    var allWords = [String]()
    var allClues = [String]()
    var promptWord = ""
    var usedLetters = [Character]()
    var level = 1
    var wordIndex = 0
    
    var scoreLabel: UILabel!
    var wordTextField: UITextField!
    var clearButton: UIButton!
    var submitButton: UIButton!
    var wordLabel: UILabel!
    var clueLabel: UILabel!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        wordLabel = UILabel()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.textAlignment = .center
        wordLabel.text = ""
        wordLabel.font = UIFont.systemFont(ofSize: 35)
        view.addSubview(wordLabel)
        
        clueLabel = UILabel()
        clueLabel.translatesAutoresizingMaskIntoConstraints = false
        clueLabel.text = "?????????"
        clueLabel.textAlignment = .center
        clueLabel.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(clueLabel)
        
        wordTextField = UITextField()
        wordTextField.translatesAutoresizingMaskIntoConstraints = false
        wordTextField.placeholder = "Submit a letter"
        wordTextField.textAlignment = .center
        wordTextField.font = UIFont.systemFont(ofSize: 20)
        wordTextField.isUserInteractionEnabled = true
        view.addSubview(wordTextField)
        
        clearButton = UIButton(type: .system)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.setTitle("Clear", for: .normal)
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clearButton)
        
        submitButton = UIButton(type: .system)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("Submit", for: .normal)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submitButton)
        
        NSLayoutConstraint.activate([scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     scoreLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                                     wordLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor,constant: 50),
                                     wordLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                                     clueLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                                     clueLabel.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 10),
                                     wordTextField.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 50),
                                     wordTextField.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                                     submitButton.topAnchor.constraint(equalTo: wordTextField.bottomAnchor, constant: 70),
                                     submitButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -70),
                                     submitButton.heightAnchor.constraint(equalToConstant: 44),
                                     clearButton.topAnchor.constraint(equalTo: wordTextField.bottomAnchor, constant: 70),
                                     clearButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor,constant: 70),
                                     clearButton.heightAnchor.constraint(equalToConstant: 44)])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        wordTextField.delegate = self
        performSelector(inBackground: #selector(loadLevel), with: nil)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        submit()
        return true
    }
    
    @objc func submitTapped(_ sender: UIButton) {
        submit()
    }

    @objc func clearTapped(_ sender: UIButton) {
        wordTextField.text = ""
    }
    
    func submit(){
        if let char = wordTextField.text?.uppercased().first{
            if !usedLetters.contains(char) {
                usedLetters.append(char)
            } else {
                let ac = UIAlertController(title: "Oops", message: "You have already added that letter", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(ac, animated: true)
            }
            for letter in allWords[wordIndex] {
                if usedLetters.contains(letter) {
                    promptWord += String(letter)
                    wordTextField.text = ""
                } else {
                    promptWord += "?"
                }
            }
        }
        wordLabel.text! = promptWord
        promptWord = ""
        if wordLabel.text! == allWords[wordIndex] {
            let ac = UIAlertController(title: "Nice job", message: "Lets move to the next word!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(ac, animated: true)
            wordIndex += 1
            score += 1
            usedLetters.removeAll()
            updateLevel()
        }
    }
    
    
    @objc func loadLevel() {
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt"){
            if let levelContents = try? String(contentsOf: levelFileURL){
                var lines = levelContents.components(separatedBy: "\n")
                lines.removeLast()
                lines.shuffle()
                for line in lines {
                    let parts = line.components(separatedBy: ": ")
                    allWords.append(parts[0])
                    allClues.append(parts[1])
                }
            }
        }
        performSelector(onMainThread: #selector(updateLevel), with: nil, waitUntilDone: false)
        print(allClues)
        print(allWords)
    }
    
    @objc func updateLevel(){
        wordLabel.text = ""
        for _ in 0..<allWords[wordIndex].count{
            wordLabel.text?.append("?")
        }
        clueLabel.text = allClues[wordIndex]
    }
    


}
