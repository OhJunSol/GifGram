//
//  SettingVIewController.swift
//  GifGram
//
//  Created by 오준솔 on 2022/09/22.
//

import UIKit
import Combine

class SettingViewController: UIViewController {
    
    @IBOutlet weak var columnSegmentedControl: UISegmentedControl!
    @IBOutlet weak var animationSwitch: UISwitch!
    
    private var cancellables: Set<AnyCancellable> = []
    
    deinit {
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        columnSegmentedControl.selectionPublisher.sink { value in
            switch value {
            case 0:
                SettingManager.defaultManager.numberOfColumns = 2
            case 1:
                SettingManager.defaultManager.numberOfColumns = 3
            default:
                break
            }
        }.store(in: &cancellables)
        
        animationSwitch.statePublisher.sink { state in
            SettingManager.defaultManager.isAnimating = state
        }.store(in: &cancellables)
    }


}
