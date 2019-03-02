//
//  EducationGridView.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 29/12/2018.
//  Copyright © 2018 Zdeno Bacik. All rights reserved.
//

import UIKit


class EducationMainViewController : UIViewController, EducationMenuBarProtocol {
    
    //IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var educationMenuBar: EducationMenuBar!
    @IBOutlet weak var containerView: UIView!
    
    
    private lazy var lectionViewController: LectionViewController = {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LectionViewController") as! LectionViewController
  
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var testViewController: TestViewController = {

        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TestViewController") as! TestViewController
        
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        educationMenuBar.delegate = self
        add(asChildViewController: lectionViewController)
    }
    
    func menuBarButtonClicked(_ type: EducationMenuBarType) {
        
        switch type {
        case .LectionViewSection:
            remove(asChildViewController: testViewController)
            add(asChildViewController: lectionViewController)
            break
        case .TestViewSection:
            remove(asChildViewController: lectionViewController)
            add(asChildViewController: testViewController)
            break
        }
    }
    
    private func add(asChildViewController viewController: UIViewController) {

        addChild(viewController)
        containerView.addSubview(viewController.view)
        
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
}

