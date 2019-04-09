//
//  RoverPicturesViewController.swift
//  MarsPics
//
//  Created by roberto fernandes filho on 06/04/2019.
//  Copyright © 2019 Betocorporation. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftDate

enum RoverName:String {
    case curiosity
    case opportunity
    case spirit
}

class RoverPicturesViewController: UIViewController {
    
    @IBOutlet weak var roverType: UISegmentedControl!
    @IBOutlet weak var roverPicsCollectionView: UICollectionView!
    
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var stackTraillingConstant: NSLayoutConstraint!
    @IBOutlet weak var stackLeadingConstant: NSLayoutConstraint!
    
    //Instancia o network manager para chamar os métodos da API
    private var networkManager: NetworkManager = {
        return NetworkManager()
    }()
    
    //MARK: Identificadores
    let cellReuseId = "RoverPicture"
    let segueDetailId = "selectedPictureSegue"
    
    //MARK: Nib Names
    let nibRoverColViewCellID = "RoverPictureCollectionViewCell"
    
    var loadedPictures: RoverPictures = RoverPictures()
    var loadedBatchPictures: RoverPictures = RoverPictures()
    
    let defaultDateFormat: String = "yyyy-MM-d"
    
    var isLocked = false
    var fetchingMore = false
    
    var selectedPicture: UIImage?
    var selectedCameraName: String?
    
    var currentDate = DateInRegion()
    var currentPage = 1
    var currentRover: String = RoverName.curiosity.rawValue
    var currentSection: Int = 0
    
    var curiosityLoadedManifest: RoverManifest?
    var opportunityLoadedManifest: RoverManifest?
    var spiritLoadedManifest: RoverManifest?
    let roverNames: [String] = [RoverName.curiosity.rawValue//,RoverName.opportunity.rawValue,
    //RoverName.spirit.rawValue
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRoverPicturesCollectionView()
        
        //Busca rover manifest
        loadRoverManifests()
        
    }
    
    //MARK: whenSwipeRovers - Quando usuário seleciona o rover no segmentcontroll
    @IBAction func whenSwipeRovers(_ sender: UISegmentedControl) {
        currentSection = sender.selectedSegmentIndex
        networkManager.router.cancel()
        fetchingMore = false
        isLocked = false
        
        switch currentSection {
        case 0: //Curiosity
            currentRover = RoverName.curiosity.rawValue
        case 1:
            currentRover = RoverName.opportunity.rawValue
        case 2:
            currentRover = RoverName.spirit.rawValue
        default:
            currentRover = RoverName.curiosity.rawValue
        }
        
        
        self.loadedPictures.roverPictures.removeAll()
        self.roverPicsCollectionView.reloadData()
    
        
        loadRoverPictures(roverType: currentRover)
        
    }
    
    //MARK: Configura o CollectionView Delegate e DataSource
    func setupRoverPicturesCollectionView(){
        roverPicsCollectionView.delegate = self
        roverPicsCollectionView.dataSource = self
        
        self.roverPicsCollectionView.register(UINib(nibName: nibRoverColViewCellID, bundle: nil), forCellWithReuseIdentifier: cellReuseId)
    }
    
    //MARK: loadRoverManifests - Carrega info
    func loadRoverManifests() {
        
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().async {
            for rover in self.roverNames {
                print("Rover = \(rover)")
                self.networkManager.getManifestRoverInfo(roverType: rover) { (manifest, error) in
                    
                    if error != nil {
                        print(error!)
                    }
                    
                    if let loadedManifest = manifest {
                        print("MAX DATE \(rover) = \(loadedManifest.photoManifest.maxDate)")
                        switch  rover {
                        case RoverName.curiosity.rawValue: self.curiosityLoadedManifest = loadedManifest
                        case RoverName.opportunity.rawValue: self.opportunityLoadedManifest = loadedManifest
                        case RoverName.spirit.rawValue: self.spiritLoadedManifest = loadedManifest
                        default: self.curiosityLoadedManifest = loadedManifest
                        }
                        
                        if rover == RoverName.curiosity.rawValue {
                            group.leave()
                        }
                    }
                }
            }
            
        }
        
        group.notify(queue: .main) {
            self.loadRoverPictures(roverType: self.currentRover)
        }
        
    }
    
    //MARK: loadRoverPictures - Carrega informação das fotos
    func loadRoverPictures(roverType: String){
        
        if roverType != RoverName.curiosity.rawValue {
            return
        }
        
        switch currentSection {
        case 0: currentDate = curiosityLoadedManifest?.photoManifest.maxDate.date(format: .custom(defaultDateFormat)) ?? DateInRegion()
        case 1: currentDate = opportunityLoadedManifest?.photoManifest.maxDate.date(format: .custom(defaultDateFormat)) ?? DateInRegion()
        case 2: currentDate = spiritLoadedManifest?.photoManifest.maxDate.date(format: .custom(defaultDateFormat)) ?? DateInRegion()
        default: currentDate = DateInRegion()
        }
//        print("RoverTYPE = \(roverType)")
        isLocked = false
        var isFetched: Bool = false
        DispatchQueue.global().async {
            while (self.loadedPictures.roverPictures.count <= 0) || !isFetched {
                if !self.isLocked {
                    self.isLocked = true
                    print("NOW = \(self.currentDate.string(custom: self.defaultDateFormat))")
                    
                    self.networkManager.getNewRoverPicturesInformation(roverType: roverType, date: self.currentDate.string(custom: self.defaultDateFormat), page: self.currentPage) { (roverPictures, error) in
                        if error != nil {
                            isFetched = false
                            self.currentDate = self.currentDate - 1.day
                            self.currentPage = 1
                            self.isLocked = false
                            
                        }
                        
                        if let roverPics = roverPictures {
                            isFetched = true
                            //                        self.curiosityLastRequestIndex?.startDate = self.currentDate
                            self.currentPage += 1
                            self.isLocked = true
                            self.fetchingMore = false
                            
                            self.loadedPictures.total = roverPics.roverPictures.count
                            
                            let firstIndex = self.loadedPictures.roverPictures.count
                            let lastIndex = (firstIndex + roverPics.roverPictures.count) - 1
                            
                            var indexPaths = [IndexPath]()
                            for index in firstIndex...lastIndex {
                                let indexPath = IndexPath(item: index, section: 0)
                                indexPaths.append(indexPath)
                            }
                            
                            for roverPicture in roverPics.roverPictures {
                                self.loadedPictures.roverPictures.append(roverPicture)
                            }
                    
                            if firstIndex == 0 {
                                DispatchQueue.main.async {
                                    self.roverPicsCollectionView.reloadData()
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.roverPicsCollectionView.performBatchUpdates({
                                        self.roverPicsCollectionView.insertItems(at: indexPaths)
                                    }, completion: { (finished) in
                                        self.roverPicsCollectionView.reloadItems(at: indexPaths)
                                    })
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedPictureSegue" {
            let backItem = UIBarButtonItem()
            backItem.title = "Voltar"
            navigationItem.backBarButtonItem = backItem
            let destination = segue.destination as! SelectedPictureViewController
            destination.segueImage = selectedPicture
            destination.segueText = selectedCameraName!
        }
    }
}

//MARK: Delegate e Datasource Functions
extension RoverPicturesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loadedPictures.roverPictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath) as! RoverPictureCollectionViewCell
        
        let url = loadedPictures.roverPictures[indexPath.row].imgSrc
        
        if !url.isEmpty {
            cell.imageURL = url
            cell.startLoading()
            DispatchQueue.global().async {
                cell.picture.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "mars"), options: .allowInvalidSSLCertificates) { (image, error, imageCachedType, url) in
                    cell.picture.image = image
                    cell.stopLoading()
                }
            }
            
            DispatchQueue.main.async {
                cell.date.text = self.currentDate.string(custom: "dd/MM/yyyy")
            }
            
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! RoverPictureCollectionViewCell
        selectedPicture = cell.picture.image
        selectedCameraName = loadedPictures.roverPictures[indexPath.row].camera.fullName
        
        performSegue(withIdentifier: segueDetailId, sender: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        //Controla quando se deve buscar mais registros
        if offsetY > contentHeight - scrollView.frame.height * 10 {
            if !fetchingMore {
                beginBatchFetch()
            }
        }
    }
    
    func beginBatchFetch() {
        fetchingMore = true
        
        loadRoverPictures(roverType: currentRover)
    }
}

//MARK:CollectionViewFlowDelegate Functions
extension RoverPicturesViewController: UICollectionViewDelegateFlowLayout {
    //MARK: sizeForItemAt - Configura layout das células dinamicamente de acordo com tamanho do celular. Nesta configuração para sempre caber 2 x 2 na tela, mas pode ser alterada para qualquer valor.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCollums = CGFloat(2)
        let numberOfRows = CGFloat(2)
        
        let width = (view.frame.width - (stackLeadingConstant.constant + stackTraillingConstant.constant + mainStack.spacing)) / numberOfCollums
        let height = (roverPicsCollectionView.frame.size.height - (mainStack.spacing * numberOfRows)) / numberOfRows
        
        return CGSize(width: width, height: height)
    }
}
