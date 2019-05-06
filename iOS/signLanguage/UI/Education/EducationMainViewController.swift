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
  
        return viewController
    }()
    
    private lazy var testViewController: TestViewController = {

        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TestViewController") as! TestViewController
        
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
        
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(viewController.view)
        
        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            viewController.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            viewController.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            viewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
            ])
        
        viewController.didMove(toParent: self)
        
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
}

