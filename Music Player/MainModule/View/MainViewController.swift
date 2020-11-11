//
//  FirstViewController.swift
//  Music Player
//
//  Created by Кирилл Романенко on 23/05/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: RoutableViewController<MainPresenting> {
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startSetup()
        setupDelegates()
        setItems ()
        
        myTableView.separatorInset.right = 15
        myTableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        
    }
    
    override func changeContentInset(_ bool: Bool) {
        self.myTableView.contentInset.bottom = bool ? 0 : 40
    }
    
    //MARK: - private
    
    private func setupDelegates() {
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.dragInteractionEnabled = true
        myTableView.dragDelegate = self
        myTableView.dropDelegate = self
    }
    
    private func startSetup() {
        presenter.startSetup()
        presenter.mainViewDidStart()
    }
    
    //MARK: - selectors
    
    @objc func mixTracklist(sender: UIButton) {
        presenter.mixTracklist()
        presenter.showDetailPlayerView(from: self)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        presenter.didMoveRow(moveRowAt: sourceIndexPath, to: destinationIndexPath)
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.userPlaylist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.mainTableViewCell, for: indexPath) else { return UITableViewCell() }
        
        cell.setup(styleImage: .image, song: presenter.userPlaylist[indexPath.row], presenter: presenter)
        cell.playlist = presenter.userPlaylist
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.presentDetailPlayerView(from: self, indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - UITableViewDragDelegate, UITableViewDropDelegate

extension MainViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
}

extension MainViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        
        if session.localDragSession != nil { // Drag originated from the same app.
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    }
}

//MARK: - Objects

extension MainViewController {
    
    private func setItems () {
        guard let navigationController = navigationController else {return}
        
        let titleView = UILabel()
        titleView.text = R.string.localizable.yourTracks()
        titleView.textColor = #colorLiteral(red: 0.9568627451, green: 0.3411764706, blue: 0.4196078431, alpha: 1)
        titleView.textAlignment = .center
        titleView.font = R.font.cm_GARDEN_R(size: 30)
        titleView.frame = CGRect(x: (navigationController.navigationBar.bounds.width/2)-100, y: 40, width: (navigationController.navigationBar.frame.width)/2, height: 30)
        navigationController.navigationBar.insertSubview(titleView, at: 1)
        
        let standart = CGRect(x: (navigationController.navigationBar.bounds.width/2)-125, y: titleView.frame.minY-3, width: navigationController.navigationBar.frame.height/3, height: navigationController.navigationBar.frame.height/3)
        
        let frameRandomButton = CGRect(x: (navigationController.navigationBar.bounds.width/2)-185, y: standart.origin.y, width: standart.height*1.2, height: standart.height)
        _ = NavigationBarButton(image: R.image.randomSong()!,
                      navigationController: navigationController,
                      frame: frameRandomButton,
                      target: self,
                      action: #selector(mixTracklist))
    }
}
