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
    @IBOutlet weak var graphView: GraphView!
    @IBOutlet weak var containerView: UIView!
    
    // MARK: - Logic Variables
    
    private var isGraphViewShowing = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
        
        if isGraphViewShowing {
            containerViewDidTapped(nil)
        }
    }
    
    @objc private func containerViewDidTapped(_ gesture: UITapGestureRecognizer?) {
        graphView.isHidden = false
        if isGraphViewShowing {
            UIView.transition(from: graphView, to: counterView, duration: 0.7, options: [.transitionFlipFromLeft, .showHideTransitionViews])
        } else {
            UIView.transition(from: counterView, to: graphView, duration: 0.7, options: [.transitionFlipFromRight, .showHideTransitionViews])
        }
        isGraphViewShowing.toggle()
    }
}

// MARK: - Private Methods

private extension ViewController {
    
    func setupView() {
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(containerViewDidTapped)))
    }
}
