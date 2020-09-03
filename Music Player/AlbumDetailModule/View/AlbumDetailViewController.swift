//
//  AlbumViewController.swift
//  Music Player
//
//  Created by Кирилл Романенко on 05/06/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import UIKit

class AlbumDetailViewController: RoutableViewController<AlbumDetailPresenting> {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var nameArtist: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var mixButton: UIButton!
    
    private enum Buttons {
        static let play = "playButton"
        static let pause = "pauseButton"
    }
    
    static let identifier = "AlbumViewController"
    
    var album: Album? {
        get {
            presenter.album
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.view = self
        
        startSetup()
        
        setTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        presenter.checkSongObserver()
    }
    
    //MARK: - selectors & IBActions
    
    @IBAction func playButtonAction(_ sender: Any) {
        if let album = self.album {
            presenter.playSongButtonAction(albumID: album.id)
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        mixButton.flash()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func mixAction(_ sender: Any) {
        presenter.mixTracklist()
    }

}

extension AlbumDetailViewController: AlbumDetailViewProtocol {
    func updateStatusPlaying(isPlaying: Bool) {
        //
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension AlbumDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        album?.tracklist.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlbumDetailViewCell.identifier, for: indexPath) as? AlbumDetailViewCell else { return UITableViewCell() }
        
        if let album = self.album {
            cell.imageIsImage = false
            cell.setSong(album.tracklist[indexPath.row])
            cell.albumID = album.id
            cell.presenter = presenter
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let album = self.album else { return }
        
        presenter.showDetailPlayer(from: self, indexPath: indexPath, albumID: album.id)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AlbumDetailViewController {
    //MARK: - Setups
    
    private func startSetup() {
        guard let album = self.album else { return }
        
        playButton.setBackgroundImage(UIImage.image(with: #colorLiteral(red: 0.8039215686, green: 0.662745098, blue: 0.6980392157, alpha: 1)), for: .normal)
        playButton.layer.cornerRadius = 10
        playButton.layer.masksToBounds = true
        
        mixButton.setBackgroundImage(UIImage.image(with: #colorLiteral(red: 0.8039215686, green: 0.662745098, blue: 0.6980392157, alpha: 1)), for: .normal)
        mixButton.layer.cornerRadius = 10
        mixButton.layer.masksToBounds = true
        
        albumImage.layer.cornerRadius = 10
        albumImage.layer.masksToBounds = true
        albumImage.image = UIImage(named: album.albumName)
        
        albumName.text = album.albumName
        albumName.adjustsFontSizeToFitWidth = true
        
        nameArtist.text = album.tracklist[0].nameArtist
    }
    
    private func setTableView() {
        myTableView.layer.borderWidth = 0.5
        myTableView.layer.borderColor = UIColor.lightGray.cgColor
        myTableView.separatorInset.right = 15
        myTableView.register(AlbumDetailViewCell.self, forCellReuseIdentifier: AlbumDetailViewCell.identifier)
    }
    
    private func setBackgroundImage() {
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        frost.frame = CGRect(x: 0, y:0, width: view.bounds.width, height: view.bounds.height)
        frost.alpha = 0.85
        view.addSubview(frost)
        view.sendSubviewToBack(frost)
    }
}
