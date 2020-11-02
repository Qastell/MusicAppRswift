//
//  SongCell.swift
//  Music Player
//
//  Created by Кирилл Романенко on 09/08/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import UIKit

typealias StyleImageCell = Bool

class SongCell<T>: UITableViewCell {
    
    var nameSong = UILabel()
    var nameArtist = UILabel()
    var duration = UILabel()
    var buttonPlay = UIButton()
    var imageIs = StyleImageCell()
    
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
        
        setButtonSong()
        setLabelSong ()
        setLabelArtist()
        setDurationLabel()
        
        setConstraints ()
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
        [
            buttonPlay,
            nameSong,
            nameArtist,
            duration
            ].forEach{ $0.translatesAutoresizingMaskIntoConstraints = false }
        
        [
            buttonPlay.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            buttonPlay.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonPlay.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            buttonPlay.widthAnchor.constraint(equalTo: buttonPlay.heightAnchor),
            
            nameSong.leadingAnchor.constraint(equalTo: buttonPlay.trailingAnchor, constant: 10),
            nameSong.centerYAnchor.constraint(equalTo: buttonPlay.centerYAnchor, constant: -bounds.height/4),
            nameSong.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65),
            
            nameArtist.leadingAnchor.constraint(equalTo: buttonPlay.trailingAnchor, constant: 10),
            nameArtist.centerYAnchor.constraint(equalTo: buttonPlay.centerYAnchor, constant: bounds.height/4),
            nameArtist.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.65),
            
            duration.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -60),
            duration.centerYAnchor.constraint(equalTo: centerYAnchor)
            ].forEach{ $0.isActive = true }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

