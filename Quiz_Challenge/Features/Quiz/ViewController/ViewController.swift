//
//  ViewController.swift
//  Quiz_Challenge
//
//  Created by Rafael Martins on 04/10/19.
//  Copyright © 2019 Rafael Martins. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var wordsTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private let viewModel =  QuizViewModel()
    
    var wordsTable = [String]()
    var rightWords = [String]()
    var score = Int()
    
    var prodSeconds = "300" // This value is set in a different view controller
    lazy var intProdSeconds = Int(prodSeconds)
    var timer = Timer()
    var isTimerRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        wordsTextField.isUserInteractionEnabled = false
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        bindViewModel()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            bottomConstraint.constant = keyboardHeight
        }
    }
    @objc func keyboardWillHide(notification _: NSNotification) {
        bottomConstraint.constant = 0
    }
    
    
    @IBAction func startGameButton(_ sender: UIButton) {
        if startButton.titleLabel?.text == "Start" {
            start()
        } else if startButton.titleLabel?.text == "Restart" {
            restart()
        }
        
    }
    
    func start() {
        wordsTextField.isUserInteractionEnabled = true
        startButton.setTitle("Restart", for: .normal)
        if isTimerRunning == false {
            runProdTimer()
        }
    }
    
    func restart() {
        wordsTextField.isUserInteractionEnabled = true
        wordsTable = []
        tableView.reloadData()
        score = 0
        scoreLabel.text = "00/50"
        intProdSeconds = Int(prodSeconds)
        updateProdTimer()
    }
    
    
    @IBAction func addWordsTextField(_ sender: Any) {
        
        guard let text = wordsTextField.text else {
            return
        }
        
        rightWords = viewModel.AnswersTest()
        
        if validateWord(text: text) {
            wordsTextField.text = ""
            wordsTable.append(text)
            tableView.reloadData()
            score = score + 1
            scoreLabel.text = "\(score)/50"
            endGame()
        }
    }
    
    func validateWord(text: String) -> Bool {
        var result = false
        
        for word in rightWords {
            if text == word && !wordsTable.contains(text) {
                result = true
            }
        }
        
        return result
    }
    
    func endGame() {
        if score == 50 {
            wordsTextField.isUserInteractionEnabled = false
            let title = "Congratulations"
            let message = "Good job! You found  all the answers on time. Keep up with the great work."
            let buttonTittle = "Play Again"
            showSimpleAlert(title: title, message: message, buttonTitle: buttonTittle)
        } else if intProdSeconds! < 1 {
            wordsTextField.isUserInteractionEnabled = false
            let title = "Time finished"
            let message = "Sorry! Time is up you got \(score) out of 50 answers."
            let buttonTittle = "Try Again"
            showSimpleAlert(title: title, message: message, buttonTitle: buttonTittle)
        }
    }
    
    func showSimpleAlert(title: String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: { _ in
            self.restart()
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Timer
    func runProdTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateProdTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
    }

    @objc func updateProdTimer() {
        if intProdSeconds! < 1 {
            endGame()
            timer.invalidate()
            timerLabel.text = "00:00"
        }
        else {
            intProdSeconds! -= 1
            timerLabel.text = prodTimeString(time: TimeInterval(intProdSeconds!))
        }
    }

    func prodTimeString(time: TimeInterval) -> String {
        let prodMinutes = Int(time) / 60 % 60
        let prodSeconds = Int(time) % 60

        return String(format: "%02d:%02d", prodMinutes, prodSeconds)
    }
    
    //MARK: TableView
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wordsTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath) as UITableViewCell
        
        cell.textLabel?.text = wordsTable[indexPath.row]
        
        return cell
    }
    
    //MARK: ViewModel
    private func bindViewModel() {
        viewModel.getQuizWords()
    }
}

