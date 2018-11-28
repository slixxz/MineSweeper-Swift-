//
//  ViewController.swift
//  MineSweeper
//
//  Created by AAK on 2/11/17.
//  Copyright © 2017 SSU. All rights reserved.
//

import UIKit


class MinesweeperViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var gameScore: UILabel!
    @IBOutlet weak var inputErrorMessageLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var numRowsTextField: UITextField!
    @IBOutlet weak var numColumnsTextField: UITextField!
    @IBOutlet weak var gameOver: UILabel!
    @IBOutlet weak var MineFlagView: UITextView!
    @IBOutlet weak var gameOverImage: UIImageView!
    @IBOutlet weak var winnerImageView: UIImageView!
    @IBAction func mineSweepFlag(_ sender: UISegmentedControl) {
        if flagBut == true{
            flagBut = false
        }
        else{
            flagBut = true
        }
    }
    let maxNumberOfRows = 100
    let maxNumberOfColumns = 100
    let gapBetweenTiles = 2.0
    var numberOfRows = 0
    var numberOfColumns = 0
    var flagBut = false
    var mineModel = MineSweeperModel()
    var widthOfATile = 0.0
    var idx = 0
    var mineButtons = [[UIButton]]()
    var mineViewArray: [UIView] = []
    var numberLabelTile: [UILabel] = []
    var mineCounter = 0
    var HowMannyTilesAreMines = 0
    var amountOfTilesRevealed = 0
    var score = 0
    
    func makeButton(x: Double, y: Double, widthHeight: Double) -> UIButton {
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: x, y: y, width: widthHeight, height: widthHeight)
        button.backgroundColor = UIColor.orange
        button.layer.cornerRadius = 5.0
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }

    override func viewDidLoad() {
        gameScore.isHidden = true
        winnerImageView.isHidden = true
        gameOverImage.isHidden = true
        gameOver.isHidden = true
        MineFlagView.text = "MineFlag --->"
        //newGameButton.isHidden = true
        super.viewDidLoad()
        startButton.alpha = 0
        numRowsTextField.delegate = self
        numColumnsTextField.delegate = self
        inputErrorMessageLabel.textColor = UIColor.orange
        view.backgroundColor = UIColor.white //color of background
        let mineView = MineView(frame: CGRect(x: 100, y: 100, width: 140, height: 140))
        mineView.backgroundColor = UIColor.brown
        
        
//        view.addSubview(mineView)
//        let tiles = mineModel.startGameWith(rows: 10, columns: 10)
//        updateTiles(tiles: tiles)
/*
        for i in  0 ..< 10 {
            let button = makeButton(x: 15 + Double(i) * 27.0, y: 50.0)
            button.setTitle("\(i)", for: UIControlState.normal)
            button.tag = i
            view.addSubview(button)
        }
*/
        
    }

    
    func updateTiles(tiles: [[TileAttributes]]) {
        let frame = view.frame
        print(tiles)
        print(frame)
        //view.addSubview(newGameButton)
        //newGameButton.isHidden = false
        widthOfATile = (Double(frame.size.width) - 2 * gapBetweenTiles) / (Double(numberOfColumns) + gapBetweenTiles)
        print("width of a tile \(widthOfATile)")
        var v = 0
        var idx = 0
        for row in tiles {
            let y = (widthOfATile + gapBetweenTiles) * Double(row[0].row) + 40.0
            var rowOfButtons = [UIButton]()
                for column in row {
                ////////////////////////////////////////////////
                v += 1
                let x = (widthOfATile + gapBetweenTiles) * Double(column.column) + gapBetweenTiles
                let button = makeButton(x: x, y: y, widthHeight: widthOfATile)
                    if column.tiles[0] == TileType.MineTile {
                        mineCounter += 1
                        HowMannyTilesAreMines += 1
                        button.layer.shadowColor = UIColor.black.cgColor
                        button.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
                        button.layer.shadowRadius = 5
                        button.layer.shadowOpacity = 1.0
                        button.tag = -1
                        rowOfButtons.append(button)
                        view.addSubview(button)
                        
                        let mineView = MineView(frame: CGRect(x: x, y: y, width: widthOfATile, height: widthOfATile))
                        mineView.backgroundColor = UIColor(white: 1, alpha: 0)
                        mineView.layer.shadowColor = UIColor.black.cgColor
                        mineView.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
                        mineView.layer.shadowRadius = 4.0
                        mineView.layer.shadowOpacity = 1.0
                        mineViewArray.append(mineView)
                        view.addSubview(mineView)
                        view.addSubview(button)
                        
                      
                    }
                    else {
                        button.layer.shadowColor = UIColor.black.cgColor
                        button.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
                        button.layer.shadowRadius = 5
                        button.layer.shadowOpacity = 1.0
                        rowOfButtons.append(button)
                        let label = UILabel(frame: CGRect(x: x, y: y, width: widthOfATile, height: widthOfATile))
                        label.backgroundColor = UIColor(white: 1, alpha: 0)
                        let numBombs = numberOfAdjBombs(row: idx / numberOfColumns, col: idx % numberOfColumns)
                        label.text = String(numBombs)
                        label.textAlignment = .center
                        button.tag = idx
                        numberLabelTile.append(label)
                        view.addSubview(label)
                        view.addSubview(button)
                        
                        
                    }
                idx += 1
            }
            mineButtons.append(rowOfButtons)
        }
    }


    //Helper function, returns how manny adjacent mines that tile has.
    func numberOfAdjBombs(row: Int , col: Int) -> Int
    {
        var mine_Counter = 0
        for i in -1 ..< 2 {
                if (row + i) >= 0 && (row + i) < numberOfRows {
                    for j in -1 ..< 2 {
                        if(col + j) >= 0 && (col + j) < numberOfColumns {
                            if mineModel.actionTiles()[row + i][col + j].tiles[0] == TileType.MineTile {
                                mine_Counter += 1
                            }
                        }
                    }
                }
            }
        return mine_Counter
    }
 
   
    @IBAction func didTapStartButton(_ sender: UIButton) {
        print("Did tap the start button.")
        sender.isEnabled = false
        let tiles = mineModel.startGameWith(rows: numberOfRows, columns: numberOfColumns)
        updateTiles(tiles: tiles)
    }
    
    @IBAction func newGameButtonClicked(_ sender: UIButton) {
        print("NewGameButtonCLICKED")
        destroyGame()
    }
    
    
    func revealMines()
    {
    gameOver.text = "BOOM! GAME OVER!"
        for i in 0 ..< numberOfRows {
            for j in 0 ..< numberOfColumns {
                if mineButtons[i][j].tag == -1 {
                    mineButtons[i][j].isHidden = true
                }
            }
        }
    gameOverPlayAgain()
    }
    
    func revealNeighboringZeros(r: Int, c: Int)
    {
        if numberOfAdjBombs(row: r, col: c) == 0 {
            var queue = Queue <TileAttributes>()
            queue.enqueue(mineModel.actionTiles()[r][c])
            while queue.isEmpty != true {
                print(queue.count)
                let tile = queue.dequeue()
                //amountOfTilesRevealed += 1
                let row = tile!.row
                let col = tile!.column
                mineButtons[row][col].isHidden = true //reveal itself
                for i in -1 ..< 2{
                    if(row + i) >= 0 && (row + i) < numberOfRows{
                        for j in -1 ..< 2{
                            if (col + j) >= 0 && (col + j) < numberOfColumns {
                                if mineButtons[row + i][col + j].isHidden == false {
                                    mineButtons[row + i][col + j].isHidden = true
                                    amountOfTilesRevealed += 1
                                    var num = numberOfAdjBombs(row: row + i, col: col + j)
                                    if  num == 0  {
                                        queue.enqueue(mineModel.actionTiles()[row + i][col + j])//add any neigbors that=0
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func didTapButton(_ button: UIButton) {
     
    if button.backgroundColor == UIColor.red && flagBut == false
    {
        //do nothing
        print("do nothing")
    }
    else{
        //IF MINE FLAG IS TRUE
        if flagBut == true {
            if  (button.backgroundColor == UIColor.orange) {
                button.backgroundColor = UIColor.red
                if button.tag == -1{
                    mineCounter -= 1//put mineCounter down one
                }
            }
            else {
                if button.backgroundColor == UIColor.red {
                    button.backgroundColor = UIColor.orange
                    HowMannyTilesAreMines += 1
                    if button.tag == -1{
                        mineCounter += 1//put mineCounter down one
                    }
                }
            }
        }
        if flagBut == false{
            if button.tag == -1 {
                gameOverImage.isHidden = false
                //newGameButton.isHidden = true
                revealMines() // reveal board //call inside revealmine gameOverPlayAgain()
                print("game over")
                score = amountOfTilesRevealed
                gameScore.text = ("Score: " + String(score))
                gameScore.isHidden = false
                
            }
            else{
                amountOfTilesRevealed += 1
                button.isHidden = true
                revealNeighboringZeros(r: button.tag / numberOfColumns, c: button.tag % numberOfColumns)
                }
            }
        }
        print("amountOfTilesRevealed: " + String(amountOfTilesRevealed))
        print(numberOfRows * numberOfColumns - HowMannyTilesAreMines)
        print("HowMannyTilesAreMines: " + String(HowMannyTilesAreMines))
        print("mine counter: " + String(mineCounter))
        if (numberOfRows * numberOfColumns - HowMannyTilesAreMines == amountOfTilesRevealed){
        if mineCounter == 0{
            winnerImageView.isHidden = false
            gameOver.text = ("YOU WIN")
            score = amountOfTilesRevealed
            gameScore.text = ("Score: " + String(score))
            gameScore.isHidden = false
            for i in 0 ..< numberOfRows {
                for j in 0 ..< numberOfColumns {
                    if mineButtons[i][j].tag == -1 {
                        mineButtons[i][j].isHidden = true
                    }
                }
            }
            gameOver.isHidden = false
            disableButtons()
            }
        }
    }
    
    func destroyGame()
    {
        for i in mineViewArray {
                i.removeFromSuperview()
        }
        for i in 0 ..< numberOfRows{
            for j in 0 ..< numberOfColumns {
                 mineButtons[i][j].removeFromSuperview()
            }
        }
        for i in numberLabelTile {
            i.removeFromSuperview()
        }
        
        numberOfRows = 0
        numberOfColumns = 0
        mineModel = MineSweeperModel()
        widthOfATile = 0.0
        idx = 0
        mineCounter = 0
        score = 0
        HowMannyTilesAreMines = 0
        amountOfTilesRevealed = 0
        winnerImageView.isHidden = true
        gameOverImage.isHidden = true
        gameOver.isHidden = true
        gameScore.isHidden = true
        //newGameButton.isHidden = true
        startButton.alpha = 0
        mineButtons = [[UIButton]]()
        mineViewArray = [UIView]()
        numberLabelTile = [UILabel]()
        numRowsTextField.isEnabled = true
        numColumnsTextField.isEnabled = true
        numRowsTextField.alpha = 1.0
        numColumnsTextField.alpha = 1.0
        numColumnsTextField.text = ""
        numRowsTextField.text = ""
        viewDidLoad()
        startButton.isEnabled = true
        
    }
        
    //loop through the array of view obkects and for every UIView v call v.removeFromSuperView
    func gameOverPlayAgain()
    {
        gameOver.isHidden = false
        //newGameButton.isHidden = false
        //MineFlagView.isHidden = true
        disableButtons()
        //they cant do anything untill they click the smily face
    }
 
    func disableButtons()
    {
        for i in 0 ..< numberOfRows {
            for j in 0 ..< numberOfColumns {
            mineButtons[i][j].isEnabled = false
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// TextField delegates
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        inputErrorMessageLabel.text = ""
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        inputErrorMessageLabel.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        if let text = numRowsTextField.text, let value = Int(text) {
            if value > maxNumberOfRows {
                inputErrorMessageLabel.text = "Rows should be less than \(maxNumberOfRows). Try again."
                return false
            }
            numberOfRows = value
        }
        
        if let text = numColumnsTextField.text, let value = Int(text) {
            if value > maxNumberOfColumns {
                inputErrorMessageLabel.text = "Columns should be less than \(maxNumberOfColumns). Try again."
                return false
            }
            numberOfColumns = value
        }

        textField.resignFirstResponder()
        print("Rows = \(numberOfRows) columns = \(numberOfColumns)")
        if numberOfRows > 0 && numberOfColumns > 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.numRowsTextField.alpha = 0.0
                self.numColumnsTextField.alpha = 0.0
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, animations: {
                    self.startButton.alpha = 1.0
                }, completion: { _ in })
            })
        }
        numRowsTextField.isEnabled = false
        numColumnsTextField.isEnabled = false
        return true
    }


}

