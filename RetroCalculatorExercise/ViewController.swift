//
//  ViewController.swift
//  RetroCalculatorExercise
//
//  Created by Minooc Choo on 8/12/17.
//  Copyright © 2017 Minooc Choo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    var calcOperation = "empty"
    var reset = true
    var runningNumber = ""
    var leftValue: Double = 0
    var rightValue: Double = 0
    var result: Double = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        

    }

    @IBOutlet weak var numberLabel: UILabel!

    @IBAction func numberPressed(_ sender: UIButton) {
        
        if (calcOperation == "empty") {
            
            reset = true
        }
        
        
        if (sender.tag > 0) {
            
            // 1 ~ 9
            
            if (runningNumber == "0") {
                runningNumber = ""
            }
            
            runningNumber += "\(sender.tag)"
            numberLabel.text = runningNumber
        }
        

        if (sender.tag == 0) {
            
            // 0
            
            if (runningNumber == "") {
                runningNumber = "0"
                numberLabel.text = runningNumber
            }
            
            if (runningNumber != "0") {
                runningNumber += "\(sender.tag)"
                numberLabel.text = runningNumber
            }
        }
        
        
    }

    @IBAction func operationPressed(_ sender: UIButton) {
        
        // Operation is pressed
        if (sender.tag < 0 && sender.tag >= -4) {
            
            if (runningNumber != "") {
                
                if (reset) {

                    // Initial condition
                    
                    leftValue = Double(runningNumber)!
                    runningNumber = ""
                    
                } else {
                
                    // When calculation is ready
                    
                    rightValue = Double(runningNumber)!
                    calculation()
                
                }
            }

        
            if (sender.tag == -1) {
                calcOperation = "multiply"
            } else if (sender.tag == -2) {
                calcOperation = "divide"
            } else if (sender.tag == -3) {
                calcOperation = "subtract"
            } else if (sender.tag == -4) {
                calcOperation = "add"
            }
            
            reset = false
            
        }
        
        // Equal is pressed with right condition
        if (sender.tag == -5 && runningNumber != "") {
            rightValue = Double(runningNumber)!
            calculation()
            calcOperation = "empty"
        }
        
        
    }

    
    @IBAction func clearPressed(_ sender: UIButton) {
        if (sender.tag == -6) {
            calcOperation = "empty"
            reset = true
            runningNumber = ""
            leftValue = 0
            rightValue = 0
            result = 0
            
            numberLabel.text = "0"
        }
    }
    
    func calculation() {
        if (calcOperation == "add") {
            result = leftValue + rightValue
        } else if (calcOperation == "subtract") {
            result = leftValue - rightValue
        } else if (calcOperation == "multiply") {
            result = leftValue * rightValue
        } else if (calcOperation == "divide") {
            result = leftValue / rightValue
        }
        
        numberLabel.text = "\(result)"
        leftValue = result
        runningNumber = ""
    }


}

