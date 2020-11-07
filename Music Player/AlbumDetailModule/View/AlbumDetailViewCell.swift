//
//  AlbumTableViewCell.swift
//  Music Player
//
//  Created by Кирилл Романенко on 05/06/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import UIKit

class AlbumDetailViewCell: SongCell<AlbumDetailPresenting> {

    static let identifier = "AlbumTableViewCell"
    
    var albumID = Int()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        buttonPlay.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
        buttonPlay.setTitleColor(.black, for: .normal)
        buttonPlay.titleLabel?.font = UIFont.systemFont(ofSize: 20)
    }
    
    @objc private func playButtonAction() {
        guard let song = song else { return }
        
        buttonPlay.flash()
        presenter?.playSongCell(song: song, albumID: albumID)
    }
    
    required init?(coder: NSCoder) {
       super.init(coder: coder)
    }
}
