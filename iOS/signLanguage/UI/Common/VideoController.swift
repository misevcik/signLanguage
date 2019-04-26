//
//  VideoController.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 08/03/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit

protocol VideoControllerProtocol {
    func clickPlayVideo()
    func clickForward()
    func clickBackward()
    func clickSideVideo(_ isSelected : Bool)
    func clickSlowDown(_ isSelected : Bool)
}

class VideoController : UIView {
    
    public var delegate : VideoControllerProtocol?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var sideViewLabel: UILabel!
    @IBOutlet weak var slowDownLabel: UILabel!
    @IBOutlet weak var forwardButton: UIButton!
    
    @IBAction func playClick(_ sender: UIButton) {
        delegate?.clickPlayVideo()
    }
    
    
    @IBAction func slowDownClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        slowDownLabel.textColor = sender.isSelected ? #colorLiteral(red: 0.8919349313, green: 0.3245626688, blue: 0.4429816008, alpha: 1) : #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        delegate?.clickSlowDown(sender.isSelected)
    }
    
    @IBAction func goBackwardClick(_ sender: Any) {
        delegate?.clickBackward()
    }
    
    @IBAction func goForwardClick(_ sender: Any) {
       delegate?.clickForward()
    }
    
    @IBAction func sideVideoClick(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        sideViewLabel.textColor = sender.isSelected ? #colorLiteral(red: 0.8919349313, green: 0.3245626688, blue: 0.4429816008, alpha: 1) : #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        delegate?.clickSideVideo(sender.isSelected)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("VideoController", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
        
    }
}
