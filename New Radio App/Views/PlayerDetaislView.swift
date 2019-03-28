//
//  PlayerDetaislView.swift
//  New Radio App
//
//  Created by Nikita Koniukh on 24/03/2019.
//  Copyright © 2019 Nikita Koniukh. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class PlayerDetaislView: UIView {
    
    
    


    @IBAction func likeButtonPressed(_ sender: UIButton) {
        
        //let's check if we have already saved this podcast as fav
        let savedPodcasts = UserDefaults.standard.savePodcasts()
        let hasFavorited = savedPodcasts.index(where: { $0.name == self.podcast?.name }) != nil
        if hasFavorited {
            
            print("have allready!")
        } else {
           
            guard let podcast = self.podcast else {return}
            var listOfPodcasts = UserDefaults.standard.savePodcasts()
            listOfPodcasts.append(podcast)
            let data = try! NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: UserDefaults.favoritePodcastKey)
            showBadgeHighlight()
        }
        
        
    }
    
    fileprivate func showBadgeHighlight(){
        UIApplication.mainTabController()?.viewControllers?[0].tabBarItem.badgeValue = "חדש"
    }
    
    
    @IBAction func fetchButtonPressed(_ sender: UIButton) {
//        let value = UserDefaults.standard.value(forKey: UserDefaults.favoritePodcastKey) as? String
//        print(value ?? "")
//        guard let data = UserDefaults.standard.data(forKey: UserDefaults.favoritePodcastKey) else {return}
//
//            let savedPodcasts = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Podcast]
//
//            savedPodcasts?.forEach({ (p) in
//                print(p.name ?? "")
//            })
    }
    
    
    
    
    
    var podcast: Podcast!{
        didSet{
            episodeTitleLabel.text = podcast.name
            miniTitileLabel.text = podcast.name
            setUpNowPlayingInfo()
            setupAudioSession()
            playPodcast()
            
            //CHAECK IMAGE
            
//            var nowPlayingInfo =
//                MPNowPlayingInfoCenter.default().nowPlayingInfo
//             var image = UIImage(cgImage: podcastImageView as! CGImage)
//            let artwork = MPMediaItemArtwork(boundsSize: image.size) { (_) -> UIImage in
//                return image
//            }
//            nowPlayingInfo![MPMediaItemArtwork] = artwork
//
//            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }
    }
   
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    

    
    fileprivate func playPodcast(){
        guard let url = URL(string: podcast.urlAddress ?? "") else {return}
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    var panGesture: UIPanGestureRecognizer!
    
    fileprivate func setupGestures(){
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        minimizedStackView.addGestureRecognizer(panGesture)
        
        maximizedStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissPan)))
    }
    
    @objc func handleDismissPan(gesture: UIPanGestureRecognizer){
        if gesture.state == .changed{
            let translation = gesture.translation(in: superview)
            maximizedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        }else if gesture.state == .ended{
            let translation = gesture.translation(in: superview)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.maximizedStackView.transform = .identity
                
                if translation.y > 50{
                    let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
                    mainTabBarController?.minimizePlayerDetails()
                }
            })
        }
    }
    
    fileprivate func observeBoundaryTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            self?.enlargePodcastImageView()
            self?.setupLockScreenDuration()
        }
    }
    
    fileprivate func setupLockScreenDuration(){
        guard let duraction = player.currentItem?.duration else {return}
        let durationSeconds = CMTimeGetSeconds(duraction)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationSeconds
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupRemoteControl()
        setupGestures()
        observePlayerCurrentTime()
        observeBoundaryTime()
      //  setupInterruptionObserver()
    }
    

    
     static func initFromNib() -> PlayerDetaislView{
        return Bundle.main.loadNibNamed("PlayerDetaislView", owner: self, options: nil)?.first as! PlayerDetaislView
    }
    
//    fileprivate func setupInterruptionObserver(){
//        let notificationCenter = NotificationCenter.default
//
//        notificationCenter.addObserver(self,
//                                       selector: #selector(handleInterruption),
//                                       name: .AVAudioSession.interruptionNotification,
//                                       object: nil)
//    }
//
//    @objc fileprivate func handleInterruption(notification: Notification) {
//        //https://developer.apple.com/documentation/avfoundation/avaudiosession/responding_to_audio_session_interruptions
//    }
    
    fileprivate func setupAudioSession(){
        
        do{
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        }catch let sessionErr{
            print("Failed to activate session: ", sessionErr)
        }
        
    }
    
    fileprivate func setupRemoteControl(){
        
        UIApplication.shared.beginReceivingRemoteControlEvents()
        //Add handler for background audio
        let commandCenter = MPRemoteCommandCenter.shared()
        // Add handler for Play Command
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.play()
            self.playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            self.miniPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            //self.setupElapsedTime(playBackRate: 1)
            self.setupElapsedTime()
            return .success
        }
        // Add handler for Pause Command
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.pause()
            self.playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            self.miniPlayPauseButton.setImage(UIImage(named: "play"), for: .normal)
           // self.setupElapsedTime(playBackRate: 0)
            self.setupElapsedTime()
            return .success
        }
        //enable play/pause command for earfhones
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.handlePlayPause()
            return .success
        }
    }
    
    fileprivate func setupElapsedTime(){
        let elapsedTime = CMTimeGetSeconds(player.currentTime())
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
//        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playBackRate
    }
    
    fileprivate func setUpNowPlayingInfo(){
        
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = podcast.name
        //nowPlayingInfol[MPMediaItemPropertyArtist] = podcast.
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    
    fileprivate func observePlayerCurrentTime() {
        //notes us when player is slowly apdates in periodic interval
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            
            //set time to currentTimeLabel
            self?.currentTimeLabel.text = time.toDisplayString()
            
            let duractionTime = self?.player.currentItem?.duration//get seconds and minutes
            self?.duractionLabel.text = duractionTime?.toDisplayString()
            
            self?.updateCurrentTimeSlider()
        }
    }
    
    
    fileprivate func updateCurrentTimeSlider(){
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        
        let duractionSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        
        let percentage = currentTimeSeconds / duractionSeconds
        
        self.currenrTimeSlider.value = Float(percentage)
    }
    
    
    //MARK:- IB actions and outlets
    
    @IBAction func handleCurrentTimeSliderChange(_ sender: Any) {
        let percentage = currenrTimeSlider.value
        guard let duration = player.currentItem?.duration else {return}
        let duretiInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(percentage) * duretiInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTimeInSeconds
        player.seek(to: seekTime)
    }
    @IBAction func handleRewind(_ sender: Any) {
        seekToCurrentTime(delta: -10)
    }
    @IBAction func handleForward(_ sender: Any) {
        seekToCurrentTime(delta: 10)
    }
    
    fileprivate func seekToCurrentTime(delta: Int64){
        let fifteentSeconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(  player.currentTime(), fifteentSeconds)
        player.seek(to: seekTime)
    }
    
   
   
    @IBOutlet weak var miniPlayPauseButton: UIButton!{
        didSet{
            miniFastForwardButton.imageEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
            miniPlayPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    @IBOutlet weak var miniFastForwardButton: UIButton!{
        didSet{
            miniFastForwardButton.imageEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
            miniFastForwardButton.addTarget(self, action: #selector(handleForward(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var miniTitileLabel: UILabel!
    @IBOutlet weak var miniEpisodeImageView: UIImageView!
    @IBOutlet weak var minimizedStackView: UIView!
    @IBOutlet weak var maximizedStackView: UIStackView!
    @IBOutlet weak var currenrTimeSlider: UISlider!
    @IBOutlet weak var duractionLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
   
    @IBAction func handleDismiss(_ sender: Any) {
        let mainTabController =  UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabController?.minimizePlayerDetails()
    }
    
    @IBOutlet weak var playPauseButton: UIButton!{
        didSet{
        
            playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    
    @objc func handlePlayPause(){
        if player.timeControlStatus == .playing{
            player.pause()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            miniPlayPauseButton.setImage(UIImage(named: "play"), for: .normal)
            shrinkPodcastImageView()
           
           
            self.setupElapsedTime(playBackRate: 1)
        }else if player.timeControlStatus == .paused{
            player.play()
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            miniPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            enlargePodcastImageView()
            self.setupElapsedTime(playBackRate: 0)
        }
        
    }
    
    fileprivate func setupElapsedTime(playBackRate: Float) {
        let elapsedTime = CMTimeGetSeconds(player.currentTime())
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = playBackRate
    }
    
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var podcastImageView: UIImageView!{
        didSet{
            
            //custom view of image
            podcastImageView.layer.cornerRadius = 5
            //resize image
            podcastImageView.transform = self.shrunkenTransform
        }
    }
    
    //MARK:- Image animation

    fileprivate let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    
    fileprivate func enlargePodcastImageView(){
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.podcastImageView.transform = .identity
        })
    }
    
    fileprivate func shrinkPodcastImageView(){
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.podcastImageView.transform = self.shrunkenTransform
            
        })
    }
}
