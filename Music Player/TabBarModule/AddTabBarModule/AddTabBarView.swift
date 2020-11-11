//
//  AdditionalTabBarView.swift
//  Music Player
//
//  Created by Кирилл Романенко on 30/07/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import UIKit
import SnapKit

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
        presenter.playPause(playButton: barPlayButton, setPlayImage: R.image.playButton()!, setPauseImage: R.image.pauseButton()!)
    }
    
    @objc private func forwardButtonAction() {
        presenter.playNextSong()
    }
    
    private func setup() {
        if presenter.currentSong == nil {
            alpha = 0
        } else {
            alpha = 1
            
            let playButtonImage = presenter.isPlaying ? R.image.pauseButton() : R.image.playButton()
            let forwardButtonImage = presenter.isPlaying ? R.image.goForward() : R.image.exit()
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
        let playButtonImage = isPlaying ? R.image.pauseButton() : R.image.playButton()
        let forwardButtonImage = isPlaying ? R.image.goForward() : R.image.exit()
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

        barPlayButton.setImage(R.image.playButton(), for: .normal)
        barPlayButton.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        self.addSubview(barPlayButton)

        barForwardButton.setImage(R.image.goForward(), for: .normal)
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
        barPlayButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(25)
        }
        
        barForwardButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.height.equalTo(25)
            make.width.equalTo(barForwardButton.snp.height).multipliedBy(1.3)
        }
        
        labelSong.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(barPlayButton.snp.right).offset(20)
            make.right.equalTo(barForwardButton.snp.left).offset(-20)
        }
    }
}
