//
//  VideoController.swift
//  signLanguage
//
//  Created by Zdeno Bacik on 08/03/2019.
//  Copyright © 2019 Zdeno Bacik. All rights reserved.
//

import UIKit

protocol VideoControllerProtocol {
    func clickForward()
    func clickBackward()
    func clickSideVideo()
    func clickSlowDown()
}

class VideoController : UIView {
    
    public var delegate : VideoControllerProtocol?
    
    @IBOutlet weak var contentView: UIView!
    
    @IBAction func slowDownClick(_ sender: Any) {
        delegate?.clickSlowDown()
    }
    
    @IBAction func goBackwardClick(_ sender: Any) {
        delegate?.clickBackward()
    }
    
    @IBAction func goForwardClick(_ sender: Any) {
       delegate?.clickForward()
    }
    
    @IBAction func sideVideoClick(_ sender: Any) {
        delegate?.clickSideVideo()
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
