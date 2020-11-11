//
//  SongCell.swift
//  Music Player
//
//  Created by Кирилл Романенко on 09/08/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import UIKit
import SnapKit

typealias StyleImageCell = Bool

class SongCell<T>: UITableViewCell, AudioServiceDelegate {
    
    var nameSong = UILabel()
    var nameArtist = UILabel()
    var duration = UILabel()
    var buttonPlay = UIButton()
    var imageIs = StyleImageCell()
    
    let songNotification = NotificationKeys.didChangeCurrentSongKey
    
    enum StyleImage {
        case image
        case title
    }
    
    var presenter: T!
    
    var song: Song? {
        didSet {
            guard let song = song else { return }
            nameSong.text = song.nameSong
            nameArtist.text = song.nameArtist
            buttonPlay.set(imageIs ? .setImage(from: song) : .setTitle(from: song))
            duration.text = getDuration(song)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = false
        
        audioService.delegates.add(self)
        
        setButtonSong()
        setLabelSong ()
        setLabelArtist()
        setDurationLabel()
        
        setConstraints ()
//        createObservers()
    }
    
    func didChangeSong(currentSong: Song?) {
        let songIsCurrent = song?.nameSong == currentSong?.nameSong && song?.nameArtist == currentSong?.nameArtist
        let color = songIsCurrent ? #colorLiteral(red: 0.9254901961, green: 0.9254901961, blue: 0.9254901961, alpha: 1) : .white
        backgroundColor = color
    }
    
    // second variant of realization image's style
    func setupSecondVersion(styleImage: StyleImage, song: Song, presenter: T) {
        switch styleImage {
        case .image:
            imageIs = .image
        case .title:
            imageIs = .title
        }
        setSong(song)
        self.presenter = presenter
    }
    
    func setup(styleImage: StyleImageCell, song: Song, presenter: T) {
        imageIs = styleImage
        setSong(song)
        self.presenter = presenter
    }
    
    func setSong(_ song: Song) {
        self.song = song
    }
    
    private func getDuration(_ song: Song) -> String {
        return "\(String(format: "%02d", Int(song.duration) / 60)):\(String(format: "%02d", Int(song.duration) % 60))"
    }
    
    private func setLabelSong() {
        nameSong.font = UIFont.systemFont(ofSize: 17)
        addSubview(nameSong)
    }
    
    private func setLabelArtist() {
        nameArtist.font = UIFont.systemFont(ofSize: 17)
        nameArtist.textColor = #colorLiteral(red: 0.6941548165, green: 0.6941548165, blue: 0.6941548165, alpha: 1)
        addSubview(nameArtist)
    }
    
    private func setButtonSong() {
        buttonPlay.imageView?.contentMode = .scaleAspectFill
        buttonPlay.layer.cornerRadius = 10
        buttonPlay.layer.masksToBounds = true
        addSubview(buttonPlay)
    }
    
    private func setDurationLabel() {
        duration.font = UIFont.systemFont(ofSize: 15)
        duration.textColor = #colorLiteral(red: 0.6941548165, green: 0.6941548165, blue: 0.6941548165, alpha: 1)
        addSubview(duration)
    }
    
    private func setConstraints() {
        buttonPlay.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.8)
            make.width.equalTo(buttonPlay.snp.height)
        }
        
        nameSong.snp.makeConstraints { make in
            make.left.equalTo(buttonPlay.snp.right).offset(10)
            make.centerY.equalTo(buttonPlay.snp.centerY).offset(-bounds.height/4)
            make.width.equalToSuperview().multipliedBy(0.65)
        }
        
        nameArtist.snp.makeConstraints { make in
            make.left.equalTo(buttonPlay.snp.right).offset(10)
            make.centerY.equalTo(buttonPlay.snp.centerY).offset(bounds.height/4)
            make.width.equalToSuperview().multipliedBy(0.65)
        }
        
        duration.snp.makeConstraints { make in
            make.left.equalTo(snp.right).offset(-60)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
