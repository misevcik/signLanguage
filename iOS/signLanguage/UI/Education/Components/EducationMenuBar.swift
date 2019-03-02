//
//  EducationMenuBar.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 01/03/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit

enum EducationMenuBarType {
    case LectionViewSection
    case TestViewSection
}

protocol EducationMenuBarProtocol {
    func menuBarButtonClicked(_ type: EducationMenuBarType)
}

class EducationMenuBar : UIView {
    
    public var delegate : EducationMenuBarProtocol?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var lectionView: UIView!
    @IBOutlet weak var testView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("EducationMenuBar", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        lectionView.layer.cornerRadius = 10
        testView.layer.cornerRadius = 10
        highlightSelectedTab(true, false)
        
        let lectionGesture = UITapGestureRecognizer(target: self, action:  #selector(self.lectionViewClick))
        self.lectionView.addGestureRecognizer(lectionGesture)
        
        let testGesture = UITapGestureRecognizer(target: self, action:  #selector(self.testViewClick))
        self.testView.addGestureRecognizer(testGesture)
        
    }
    
    @objc func lectionViewClick(sender : UITapGestureRecognizer) {
        highlightSelectedTab(true, false)
        delegate?.menuBarButtonClicked(EducationMenuBarType.LectionViewSection)
    }
    
    @objc func testViewClick(sender : UITapGestureRecognizer) {
        highlightSelectedTab(false, true)
        delegate?.menuBarButtonClicked(EducationMenuBarType.TestViewSection)
    }
    
    private func highlightSelectedTab(_ lection : Bool, _ test : Bool) {
        
        if lection == true {
            lectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            testView.backgroundColor = #colorLiteral(red: 0.9656763673, green: 0.965699017, blue: 0.9656868577, alpha: 1)
            
        } else if test == true {
            testView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            lectionView.backgroundColor = #colorLiteral(red: 0.9656763673, green: 0.965699017, blue: 0.9656868577, alpha: 1)
        }
    }
    
}
