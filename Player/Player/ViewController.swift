//
//  ViewController.swift
//  Player
//
//  Created by Smile on 2024/1/12.
//

import UIKit

class ViewController: UIViewController {
    
    private var playView: VideoView!
    private var tableView: UITableView!
    private var bounds: CGRect!
    
    private var playList: [PlayerConfig] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bounds = UIScreen.main.bounds
        print("bounds: \(self.bounds)")
        
        createPlayList()
        createPlayView()
        createTableView()
    }

    // table view
    private func createTableView() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .white
        
        tableView.bounces = true
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .singleLine
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.frame = CGRectMake(0, playView.frame.size.height, bounds.width, bounds.height - playView.frame.size.height)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
    }
    
    // play video
    private func createPlayView() {
         playView = VideoView(nil, playList[0], nil)
        self.view.addSubview(playView)
    }
    
    // play list demo
    private func createPlayList() {
        self.playList = [
            PlayerConfig(
                title: "本地视频测试",
                videoUrl: Bundle.main.path(forResource: "testMovie", ofType: "mp4"),
                playHoldImage: "radio_bg_video"
           ),
            
            PlayerConfig(
                title: "本地音频测试",
                audioUrl: Bundle.main.path(forResource: "testSong", ofType: "mp3"),
                playHoldImage: "radio_bg_video"
            ),
            
            PlayerConfig(
                title: "网络音频测试",
                audioUrl: "http://downsc.chinaz.net/Files/DownLoad/sound1/201906/11582.mp3",
                needCache: true,
                playHoldImage: "radio_bg_video"
            ),
            
            PlayerConfig(
                title: "网络视频测试1",
                videoUrl: "https://lf9-static.bytednsdoc.com/obj/tos-cn-i-siecs4i2o7/ogCSEAHeOfDATrwAEkhzIQN3IAocgCa6AD2FHx?filename=laohanzong.mp4",
                needCache: false,
                playHoldImage: "radio_bg_video"
            ),
            
            PlayerConfig(
                title: "网络视频测试2",
                videoUrl: "https://sf6-cdn-tos.huoshanstatic.com/obj/tos-cn-i-siecs4i2o7/o86VAPNzNELHxdkrICHgDejw2CFEXhQAfAAvIg?znjson.mp4",
                needCache: true,
                playHoldImage: "radio_bg_video"
            ),
            
            PlayerConfig(
                title: "网络视频测试3",
                videoUrl: "https://sf6-cdn-tos.toutiaostatic.com/obj/tos-cn-i-siecs4i2o7/o43fYKfaI6CIexZXSfwjeAw8BQ2agNlgAAn6ce?filename=laohanzong.mp4",
                needCache: true,
                playHoldImage: "radio_bg_video"
            ),
        ]
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let playConfig = self.playList[indexPath.row]
        cell.textLabel?.text = playConfig.title ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell at row \(indexPath.row) selected")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let playConfig = self.playList[indexPath.row]
        self.playView.videoView.updatePlayerConfig(playConfig)
        print("select: \(playConfig)")
    }
    
}

