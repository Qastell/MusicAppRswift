//
//  SongCollectionViewCell.swift
//  Music Player
//
//  Created by Кирилл Романенко on 24/05/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import UIKit
import SnapKit

class AlbumViewCell: UICollectionViewCell {
    
    static let identifier = "SongCollectionViewCell"
    
    var imageViewSong = UIImageView()
    
    var album: Album? {
        didSet {
            guard let album = self.album else { return }
            imageViewSong.image = UIImage(named: album.name)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImageSong()
    }
    
    private func setImageSong() {
        imageViewSong.contentMode = .scaleAspectFill
        addSubview(imageViewSong)
        setImageConstraints ()
    }
    
    private func setImageConstraints() {
        imageViewSong.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.height.equalToSuperview()
            make.width.equalTo(imageViewSong.snp.height)
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
