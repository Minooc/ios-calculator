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
    var continuing = false
    var runningNumber = ""
    var leftValue: Double = 0
    var rightValue: Double = 0
    var result: Double = 0
    var hasDot: Bool = false
    
    var lowerPriorityValue: Double = 0
    var hasLowPriorityOperation = 0     //  0 means there is no low-priority operator.
    // it will be assigned to -3 when subtract is pressed, and -4 when add is pressed.
    
    
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
            
            if (continuing) {
                if (sender.tag == -3) {
                    hasLowPriorityOperation = -3
                } else if (sender.tag == -4) {
                    hasLowPriorityOperation = -4
                }
                continuing = false
            }
            
            if (runningNumber != "") {
                
                if (reset) {

                    // Initial condition
                    
                    // When lower priority operator (+ or -) is pressed
                    if (sender.tag == -3) {
                        hasLowPriorityOperation = -3
                    } else if (sender.tag == -4) {
                        hasLowPriorityOperation = -4
                    }
                    
                    leftValue = Double(runningNumber)!
                    runningNumber = ""
                    
                } else {
                
                    // When calculation is ready
                    
                    if ((sender.tag == -1 || sender.tag == -2) && (hasLowPriorityOperation != 0 && lowerPriorityValue == 0)) {
                        
                        // This case is when calculation is not yet ready, but has to set priority.
                        
                        lowerPriorityValue = leftValue
                        leftValue = Double(runningNumber)!
                        runningNumber = ""
                        
                    
                    } else if ((sender.tag == -3 || sender.tag == -4) && lowerPriorityValue != 0) {
                        
                        priorityCalculation()
                        
                    } else {
                        
                        rightValue = Double(runningNumber)!
                        calculation()
                    }
                    


                
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
            
            if (lowerPriorityValue != 0) {

                priorityCalculation()
                hasLowPriorityOperation = 0
                calcOperation = "empty"
                
            } else {
                rightValue = Double(runningNumber)!
                calculation()
                calcOperation = "empty"
            }
            
            continuing = true
        }
        
        hasDot = false
        
        
    }

    @IBAction func dotPressed(_ sender: Any) {
        if (hasDot == false && runningNumber != "") {
            runningNumber += "."
            numberLabel.text = runningNumber
            hasDot = true
        }
        
    }
    
    @IBAction func clearPressed(_ sender: UIButton) {
        if (sender.tag == -6) {
            calcOperation = "empty"
            reset = true
            continuing = false
            runningNumber = ""
            leftValue = 0
            rightValue = 0
            lowerPriorityValue = 0
            result = 0
            hasDot = false
            hasLowPriorityOperation = 0
            
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
    
    func priorityCalculation() {
        // this handles higher priority one
        
        rightValue = Double(runningNumber)!
        calculation()
        
        // this handles low priority one
        
        
        rightValue = leftValue
        leftValue = lowerPriorityValue
        lowerPriorityValue = 0
        
        if (hasLowPriorityOperation == -3) {
            calcOperation = "subtract"
        } else if (hasLowPriorityOperation == -4) {
            calcOperation = "add"
        }
        
        calculation()
    }


}

