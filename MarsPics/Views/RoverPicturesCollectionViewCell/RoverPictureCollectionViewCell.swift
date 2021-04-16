//
//  RoverPictureCollectionViewCell.swift
//  MarsPics
//
//  Created by roberto fernandes filho on 06/04/2019.
//  Copyright © 2019 Betocorporation. All rights reserved.
//

import UIKit

class RoverPictureCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var date: UILabel!
    
    var networkManager : NetworkManager?
    var row: Int? 
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        ai.color = .white
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    
    //Recebe URL da imagem a ser baixada
    var imageURL: String? = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupImageView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    
        picture.image = nil
        if let ntManager = networkManager {
            ntManager.router.cancel()
        }
        
    }
    
    //MARK: setupImageView - Configura ImageView
    func setupImageView(){
        contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight,UIView.AutoresizingMask.flexibleWidth]
        picture.contentMode = .scaleAspectFill
        isUserInteractionEnabled = true
        
        //Configura o Activity indicator
        contentView.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    func startLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.picture?.alpha = CGFloat(0.5)
            self.picture?.backgroundColor = UIColor.lightGray
            self.isUserInteractionEnabled = false
        }
        
    }

    func stopLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.picture.alpha = 1
            self.picture.backgroundColor = UIColor.clear
            self.isUserInteractionEnabled = true
        }
    }
}
