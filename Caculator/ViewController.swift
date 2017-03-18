//
//  ViewController.swift
//  Caculator
//
//  Created by Apple on 17/3/17.
//  Copyright © 2017年 NJU. All rights reserved.
//

import UIKit

var caculatorCount=0

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    private var userIsInTheMiddleOfTyping=false
    private var displayVaule: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text=String(newValue)
        }
    }
    
    private var brain=CaculatorBrain()
    
    private var savedProgram: CaculatorBrain.PropertyList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        caculatorCount+=1
        print("load \(caculatorCount) times")
        brain.addUnaryOperation(symbol: "Z") { [weak me = self] in
            me?.display.textColor=UIColor.purple
            return sqrt($0)
        }
    }
    
    deinit {
        caculatorCount-=1
        print("exit \(caculatorCount) count now")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func save() {
        savedProgram=brain.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program=savedProgram!
            displayVaule=brain.result
        }
    }
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit=sender.currentTitle!
        print("press \(digit)")
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay=display.text!
            display.text=textCurrentlyInDisplay+digit
        } else {
            display.text=digit
        }
        userIsInTheMiddleOfTyping=true
    }

    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setoprand(operand: displayVaule)
        }
        userIsInTheMiddleOfTyping=false
        if let mathSymbol=sender.currentTitle {
            brain.performOperation(symbol: mathSymbol)
        }
        displayVaule=brain.result
    }
}

