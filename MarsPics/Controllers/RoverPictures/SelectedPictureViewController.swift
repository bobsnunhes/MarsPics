//
//  SelectedPictureViewController.swift
//  MarsPics
//
//  Created by roberto fernandes filho on 07/04/2019.
//  Copyright © 2019 Betocorporation. All rights reserved.
//

import UIKit

class SelectedPictureViewController: UIViewController {
    
    @IBOutlet weak var cameraLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var segueImage: UIImage?
    var segueText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraLabel.text = segueText
        image.image = segueImage
    }
}
