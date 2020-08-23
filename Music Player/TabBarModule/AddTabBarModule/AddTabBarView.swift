//
//  AdditionalTabBarView.swift
//  Music Player
//
//  Created by Кирилл Романенко on 30/07/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import UIKit

class AdditionalTabBarView: UIView {
    
    var presenter = AddTabBarPresenter()
    
    let barPlayButton = UIButton()
    let barForwardButton = UIButton()
    let labelSong = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        presenter.view = self
        setupAddBarItems(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func playButtonAction() {
        presenter.playPause(playButton: barPlayButton, setPlayImage: BarButtons.play, setPauseImage: BarButtons.pause)
    }
    
    @objc private func forwardButtonAction() {
        presenter.playNextSong()
    }
    
    private func setup() {
        if presenter.currentSong == nil {
            alpha = 0
        } else {
            alpha = 1
            
            let playButtonImage = presenter.isPlaying ? UIImage(named: BarButtons.pause) : UIImage(named: BarButtons.play)
            let forwardButtonImage = presenter.isPlaying ? UIImage(named: BarButtons.forward) : UIImage(named: BarButtons.exit)
            barPlayButton.setImage(playButtonImage, for: .normal)
            barForwardButton.setImage(forwardButtonImage, for: .normal)
            
            if let currentSong = presenter.currentSong {
                labelSong.text = "\(currentSong.nameArtist) - \(currentSong.nameSong)"
            }
        }
    }
}

extension AdditionalTabBarView: AddTabBarViewProtocol {
    func songDidChange(currentSong: Song?) {
        if let currentSong = currentSong {
            labelSong.text = "\(currentSong.nameArtist) - \(currentSong.nameSong)"
        }
    }
    
    func statusPlayingDidChange(isPlaying: Bool) {
        let playButtonImage = isPlaying ? UIImage(named: BarButtons.pause) : UIImage(named: BarButtons.play)
        let forwardButtonImage = isPlaying ? UIImage(named: BarButtons.forward) : UIImage(named: BarButtons.exit)
        barPlayButton.setImage(playButtonImage, for: .normal)
        barForwardButton.setImage(forwardButtonImage, for: .normal)
    }
}

extension AdditionalTabBarView {
    
    private func setupAddBarItems(frame: CGRect) {
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        frost.alpha = 0.80
        frost.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        self.addSubview(frost)

        barPlayButton.setImage(UIImage(named: BarButtons.play), for: .normal)
        barPlayButton.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        self.addSubview(barPlayButton)

        barForwardButton.setImage(UIImage(named: BarButtons.forward), for: .normal)
        barForwardButton.addTarget(self, action: #selector(forwardButtonAction), for: .touchUpInside)
        self.addSubview(barForwardButton)
        
        labelSong.text = "Name Artist - Name Song"
        labelSong.textAlignment = .center
        labelSong.font = UIFont.systemFont(ofSize: 15)
        labelSong.textColor = .white
        self.addSubview(labelSong)
        
        setConstraints()
    }
    
    private func setConstraints() {
        
        barPlayButton.translatesAutoresizingMaskIntoConstraints = false
        barPlayButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        barPlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        barPlayButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        barPlayButton.widthAnchor.constraint(equalTo: barPlayButton.heightAnchor).isActive = true
        
        barForwardButton.translatesAutoresizingMaskIntoConstraints = false
        barForwardButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        barForwardButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        barForwardButton.heightAnchor.constraint(equalTo: barPlayButton.heightAnchor).isActive = true
        barForwardButton.widthAnchor.constraint(equalTo: barForwardButton.heightAnchor, multiplier: 1.3).isActive = true
        
        labelSong.translatesAutoresizingMaskIntoConstraints = false
        labelSong.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        labelSong.leadingAnchor.constraint(equalTo: barPlayButton.trailingAnchor, constant: 20).isActive = true
        labelSong.trailingAnchor.constraint(equalTo: barForwardButton.leadingAnchor, constant: -20).isActive = true
    }
}
