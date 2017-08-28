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
    var reset = true    // Initial condition, or when clear is pressed
    var runningNumber = ""
    var leftValue: Double = 0
    var rightValue: Double = 0
    var result: Double = 0
    var hasDot: Bool = false
    
    var lowerPriorityValue: Double = 0
    var hasLowPriorityOperation = 0     //  0 means there is no low-priority operator. it will be assigned to -3 when subtract is pressed, and -4 when add is pressed.
   
  
    var operatorButton = false   // This becomes true when operator is pressd, and false if everything else is pressed. This variable is for preventing bugs occured when different operators are pressed consecutively.

    
    
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
        
        operatorButton = false
        
    }

    @IBAction func operationPressed(_ sender: UIButton) {
        

        // Operation is pressed
        if (sender.tag < 0 && sender.tag >= -4) {
            
            
            if (runningNumber != "") {
                

                // Initial condition
                if (reset) {
                    
                    leftValue = Double(runningNumber)!
                    runningNumber = ""
                    
                // After initial condition
                } else {
                    
                    
                    // This case is when calculation is not yet ready, but has to set priority.
                    if ((sender.tag == -1 || sender.tag == -2) && (hasLowPriorityOperation != 0 && lowerPriorityValue == 0)) {
                        
                        lowerPriorityValue = leftValue
                        leftValue = Double(runningNumber)!
                        runningNumber = ""
                    
                    }
                     
                    // This is for calculating both of high-priority and low-priority calculation
                    else if ((sender.tag == -3 || sender.tag == -4) && lowerPriorityValue != 0) {
                        
                        priorityCalculation()
                    
                    // This is for calculating only high-priority calculation
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
                hasLowPriorityOperation = -3
            } else if (sender.tag == -4) {
                calcOperation = "add"
                hasLowPriorityOperation = -4
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
            
        }
        
        hasDot = false
        operatorButton = true
        
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
            runningNumber = ""
            leftValue = 0
            rightValue = 0
            lowerPriorityValue = 0
            result = 0
            hasDot = false
            hasLowPriorityOperation = 0
            operatorButton = false
            
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

