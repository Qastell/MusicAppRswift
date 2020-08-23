//
//  SecondViewController.swift
//  Music Player
//
//  Created by Кирилл Романенко on 23/05/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import UIKit
import AVFoundation

class AlbumViewController: RoutableViewController<AlbumPresenting> {

    @IBOutlet weak var myCollectionView: UICollectionView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private enum Buttons {
        static let currentSong = "currentSong"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setItem()
        
        view.backgroundColor = .black
        
        setupLayout()
        
        setupCollectionView()
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.albums.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumViewCell.identifier, for: indexPath) as? AlbumViewCell else { return UICollectionViewCell() }

        cell.album = presenter.albums[indexPath.row]
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        presenter.showAlbumDetailView(from: self, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: myCollectionView.frame.width*0.47, height: myCollectionView.frame.width*0.47)
    }

}

extension AlbumViewController {
    //MARK: - private
    
    private func setupLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        
        myCollectionView.collectionViewLayout = layout
    }
    
    private func setItem () {
        guard let navigationController = navigationController else {return}
        
        let titleView = UILabel()
        titleView.text = "Your Albums"
        titleView.textColor = #colorLiteral(red: 0.9568627451, green: 0.3411764706, blue: 0.4196078431, alpha: 1)
        titleView.textAlignment = .center
        titleView.font = UIFont.systemFont(ofSize: 30)
        titleView.frame = CGRect(x: ((navigationController.navigationBar.bounds.width)/2)-100, y: 40, width: (navigationController.navigationBar.frame.width)/2, height: 20)
        navigationController.navigationBar.insertSubview(titleView, at: 1)
    }
    
    private func setupCollectionView () {
        myCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        myCollectionView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.showsVerticalScrollIndicator = false
        myCollectionView.contentInset = UIEdgeInsets(top: 0, left: -1.5, bottom: 0, right: 18.5)
        myCollectionView.register(AlbumViewCell.self, forCellWithReuseIdentifier: AlbumViewCell.identifier)
    }
}
