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
    
    
    private lazy var lessonViewController: LessonViewController = {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LessonViewController") as! LessonViewController
  
        return viewController
    }()
    
    private lazy var testViewController: TestViewController = {

        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TestViewController") as! TestViewController
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        educationMenuBar.delegate = self
        add(asChildViewController: lessonViewController)
    }
    
    func setupLayout() {
        
        let tabBar = self.tabBarController!.tabBar
        tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: #colorLiteral(red: 0.4549019608, green: 0.862745098, blue: 0.9686274529, alpha: 1), size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height:  tabBar.frame.height), lineWidth: 3.0)
        
    }
    
    func menuBarButtonClicked(_ type: EducationMenuBarType) {
        
        switch type {
        case .LectionViewSection:
            remove(asChildViewController: testViewController)
            add(asChildViewController: lessonViewController)
            break
        case .TestViewSection:
            remove(asChildViewController: lessonViewController)
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

