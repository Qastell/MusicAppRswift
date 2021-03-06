//
//  SongViewController.swift
//  Music Player
//
//  Created by Кирилл Романенко on 30/05/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

class DetailPlayerViewController: RoutableViewController<DetailPlayerPresenting> {
    
    @IBOutlet weak var imageSong: UIImageView!
    @IBOutlet weak var nameSong: UILabel!
    @IBOutlet weak var nameArtist: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var goForwardButton: UIButton!
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var songDurationSlider: UISlider!
    @IBOutlet weak var volumeSlider: UISlider!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var currentTime: UILabel!
    @IBOutlet weak var residualTime: UILabel!
    @IBOutlet weak var currentProgress: UILabel!
    @IBOutlet weak var durationSong: UILabel!
    
    var timer = Timer()
    
    var valueVolumeSlider = Float() {
        didSet {
            if valueVolumeSlider == 0 {
                volumeSlider.setThumbImage(R.image.soundnotEnable(), for: .normal)
            } else if valueVolumeSlider > 0 && valueVolumeSlider < volumeSlider.maximumValue*0.75{
                volumeSlider.setThumbImage(R.image.soundEnableLittle(), for: .normal)
            } else if valueVolumeSlider >= volumeSlider.maximumValue*0.75 {
                volumeSlider.setThumbImage(R.image.soundEnable(), for: .normal)
            }
        }
    }
    
    var currentSong: Song? {
        didSet {
            guard let song = currentSong else { return }
            imageSong.image = UIImage(named: song.imageSong)
            backgroundImage.image = UIImage(named: song.imageSong)
            nameSong.text = song.nameSong
            nameArtist.text = song.nameArtist
            songDurationSlider.maximumValue = Float(song.duration)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startSetup()
        
        presenter.view = self
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
        
        setBackgroundImage()
        setConstraints ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if !timer.isValid {
            timer.fire()
        }
        
        if valueVolumeSlider == 0 {
            volumeSlider.setThumbImage(R.image.soundnotEnable(), for: .normal)
        } else if valueVolumeSlider > 0 && valueVolumeSlider < volumeSlider.maximumValue*0.75{
            volumeSlider.setThumbImage(R.image.soundEnableLittle(), for: .normal)
        } else if valueVolumeSlider >= volumeSlider.maximumValue*0.75 {
            volumeSlider.setThumbImage(R.image.soundEnable(), for: .normal)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        timer.invalidate()
    }
    
    private func startSetup() {
        if let currentSong = presenter.currentSong {
            nameArtist.text = currentSong.nameArtist
            nameSong.text = currentSong.nameSong
            imageSong.image = UIImage(named: currentSong.imageSong)
            backgroundImage.image = UIImage(named: currentSong.imageSong)
            songDurationSlider.maximumValue = Float(currentSong.duration)
        }
        
        if presenter.volumeFloat != nil {
            if let volumeFloat = presenter.volumeFloat{
                presenter.volume = volumeFloat
                volumeSlider.value = volumeFloat
                valueVolumeSlider = volumeFloat
            }
        } else {
            if let volume = presenter.volume{
                volumeSlider.value = volume
                valueVolumeSlider = volume
            }
        }
        
        let isPlaying = presenter.isPlaying == true
        let image = isPlaying ? R.image.pauseButton() : R.image.playButton()
        playButton.setImage(image, for: .normal)
        
        songDurationSlider.isContinuous = false
        
        volumeSlider.setThumbImage(R.image.soundEnable(), for: .normal)
    }
    
    @objc func updateData () {
        currentProgress.text = "\(String(format: "%02d", Int(presenter.currentTime) / 60)):\(String(format: "%02d", Int(presenter.currentTime) % 60))"
        durationSong.text = "-\(String(format: "%02d", (Int(presenter.duration)-Int(presenter.currentTime)) / 60)):\(String(format: "%02d", (Int(presenter.duration)-Int(presenter.currentTime)) % 60))"
        
        if !songDurationSlider.isHighlighted {
            songDurationSlider.value = Float(presenter.currentTime)
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func playPauseButton(_ sender: Any) {
        if presenter.isPlaying{
            playButton.setImage(R.image.playButton(), for: .normal)
            presenter.pause()
        } else {
            playButton.setImage(R.image.pauseButton(), for: .normal)
            presenter.play()
        }
    }
    
    
    @IBAction func goBackAction(_ sender: Any) {
        presenter.playPreviousSong()
    }
    
    @IBAction func goForward(_ sender: Any) {
        presenter.playNextSong()
    }
    
    @IBAction func volumeSliderAction(_ sender: UISlider) {
        presenter.volumeFloat = sender.value
        valueVolumeSlider = sender.value
    }


    @IBAction func songDuration(_ sender: UISlider) {
        presenter.currentTime = TimeInterval(sender.value)
        presenter.play()
        
        playButton.setImage(R.image.pauseButton(), for: .normal)
        
        if sender.value == self.songDurationSlider.minimumValue {
            presenter.stop()
            playButton.setImage(R.image.playButton(), for: .normal)
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension DetailPlayerViewController: DetailPlayerViewProtocol {
    func statusPlayingDidChange(isPlaying: Bool) {
        let image = isPlaying ? R.image.pauseButton() : R.image.playButton()
        playButton.setImage(image, for: .normal)
    }
    
    func songDidChange(currentSong: Song?) {
        self.currentSong = currentSong
    }
}

extension DetailPlayerViewController {
    private func setBackgroundImage() {
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        frost.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        frost.alpha = 0.85
        view.addSubview(frost)
        view.sendSubviewToBack(frost)
        view.sendSubviewToBack(backgroundImage)
    }
    
    private func setConstraints () {
        backgroundImage.contentMode = .scaleAspectFit
        backgroundImage.snp.makeConstraints { make in
            make.centerY.equalTo(view.snp.centerY)
            make.centerX.equalTo(view.snp.centerX)
            make.width.height.equalTo(view.snp.height)
        }
    }
}
