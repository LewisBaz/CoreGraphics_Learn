//
//  ViewController.swift
//  WaterCountApp
//
//  Created by Lewis on 12.01.2023.
//

import UIKit

final class ViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var counterView: CounterView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions

    @IBAction func pushButtonPressed(_ button: PushButton) {
        if button.isAddButton {
            counterView.counter += 1
        } else {
            if counterView.counter > 0 {
                counterView.counter -= 1
            }
        }
        counterLabel.text = String(counterView.counter)
    }
}

