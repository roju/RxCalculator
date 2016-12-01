//
//  ViewController.swift
//  RxCalculator
//
//  Created by Nikolas Burk on 09/11/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
  
  let disposeBag = DisposeBag()
  let calculator = Calculator()

  @IBOutlet weak var operationSegmentedControl: UISegmentedControl!
  @IBOutlet weak var firstValueTextField: UITextField!
  @IBOutlet weak var secondValueTextField: UITextField!
  @IBOutlet weak var operationLabel: UILabel!
  @IBOutlet weak var resultLabel: UILabel!
  

  // MARK: View Controller Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let firstValueObservable:Observable<Int> = firstValueTextField.rx.text.map {
      string in return Int(string!)!
    }
    
    let secondValueObservable:Observable<Int> = secondValueTextField.rx.text.map {
      string in return Int(string!)!
    }
    
    let operationObservable: Observable<Calculator.Operation> = operationSegmentedControl.rx.value.map {
      selectedSegmentIndex in
        return Calculator.Operation(rawValue: selectedSegmentIndex)!
    }
    
    operationObservable.map{ operation in
      return self.calculator.sign(for:operation)
      }.bindTo(operationLabel.rx.text).addDisposableTo(disposeBag)
    
    
    Observable.combineLatest(operationObservable, firstValueObservable, secondValueObservable) {
      (operation: Calculator.Operation, firstValue:Int, secondValue:Int) -> Int in
        switch operation {
          case .addition: return firstValue + secondValue
          case .subtraction: return firstValue - secondValue
        }
      }
      .map{
        result in
          return String(result)
      }
      .bindTo(resultLabel.rx.text)
      .addDisposableTo(disposeBag)
  }

}

