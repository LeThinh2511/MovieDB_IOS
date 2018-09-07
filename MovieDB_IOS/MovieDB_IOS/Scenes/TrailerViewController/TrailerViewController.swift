//
//  TrailerViewController.swift
//  MovieDB_IOS
//
//  Created by ThinhLe on 9/3/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class TrailerViewController: UIViewController, YTPlayerViewDelegate {

    @IBOutlet weak var youtubePlayerView: YTPlayerView!

    var videoYoutubeID: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.youtubePlayerView.delegate = self
        let params = ["playsinline": 1, "rel": 0]
        self.youtubePlayerView.load(withVideoId: videoYoutubeID, playerVars: params)
    }
}
