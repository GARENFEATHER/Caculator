//
//  CaculatorBrain.swift
//  Caculator
//
//  Created by Apple on 17/3/17.
//  Copyright © 2017年 NJU. All rights reserved.
//

import Foundation

class CaculatorBrain {
    private var accumulator = 0.0
    private var internalProgram=[AnyObject]()
    
    private enum Operations {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func addUnaryOperation(symbol: String, operation: @escaping (Double) -> Double) {
        operations[symbol]=Operations.UnaryOperation(operation)
        
    }
    
    private var operations: Dictionary<String, Operations>=[
        "pi": Operations.Constant(M_PI),
        "e": Operations.Constant(M_E),
        "±": Operations.UnaryOperation({ -$0 }),
        "√": Operations.UnaryOperation(sqrt),
        "cos": Operations.UnaryOperation(cos),
        "sin": Operations.UnaryOperation(sin),
        "×": Operations.BinaryOperation({ $0 * $1 }),
        "−": Operations.BinaryOperation({ $0 - $1 }),
        "÷": Operations.BinaryOperation({ $0 / $1 }),
        "+": Operations.BinaryOperation({ $0 + $1 }),
        "=": Operations.Equals
    ]
    
    private struct pendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    private var pending: pendingBinaryOperationInfo?
    
    func setoprand(operand: Double) {
        accumulator=operand
        internalProgram.append(operand as AnyObject)
    }
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol as AnyObject)
        if let constant=operations[symbol] {
            switch constant {
            case .Constant(let value): accumulator=value
                
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending=pendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                
            case .UnaryOperation(let function): accumulator=function(accumulator)
                
            case .Equals:
                executePendingBinaryOperation()
                
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator=pending!.binaryFunction(pending!.firstOperand,accumulator)
            pending=nil
        }
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return internalProgram as CaculatorBrain.PropertyList
        }
        set {
            clear()
            if let arrOfOps=newValue as? [AnyObject] {
                for op in arrOfOps {
                    if let operand=op as? Double {
                        setoprand(operand: operand)
                    } else if let operation=op as? String {
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }
    
    private func clear() {
        accumulator=0.0
        pending=nil
        internalProgram.removeAll()
    }
    
    var result: Double {
        get {
            return accumulator
        }
        set {
            
        }
    }
}
