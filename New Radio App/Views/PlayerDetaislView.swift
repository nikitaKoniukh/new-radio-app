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
     var podcasts = [Podcast]()
    
    @IBOutlet weak var chatButton: UIButton!
    @IBAction func feedbackButtonpPressed(_ sender: UIButton) {
        
        switch podcast.isFeedbackOn {
        case true:
            podcast.isFeedbackOn = false

        case false:
            
            addToFeedback()

            podcast.isFeedbackOn = true
            
            let mainTabController =  UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
            mainTabController?.minimizePlayerDetails()
        }
        
    }
    

    @IBOutlet weak var likebutton: UIButton!
    
    fileprivate func addToFavorites() {
        //let's check if we have already saved this podcast as fav
        let savedPodcasts = UserDefaults.standard.savePodcasts()
        let hasFavorited = savedPodcasts.index(where: { $0.name == self.podcast?.name }) != nil
        if hasFavorited {
        } else {
            guard let podcast = self.podcast else {return}
            var listOfPodcasts = UserDefaults.standard.savePodcasts()
            listOfPodcasts.append(podcast)
            let data = try! NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: UserDefaults.favoritePodcastKey)
            showBadgeHighlight()
        }
    }
    
    
    fileprivate func addToFeedback() {
        //let's check if we have already saved this podcast as fav
        let savedFeedbacks = UserDefaults.standard.saveFeedback()
        let hasFavorited = savedFeedbacks.index(where: { $0._id == self.podcast?._id }) != nil
        if hasFavorited {
        } else {
            guard let podcast = self.podcast else {return}
            var listOfPodcasts = UserDefaults.standard.saveFeedback()
            listOfPodcasts.append(podcast)
            let data = try! NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: UserDefaults.feedbackPodcastKey)
            showBadgeFeedback()
        }
    }
    
    
    
    @IBAction func likeButtonPressed(_ favBtn: UIButton)  {
        switch podcast.isFavorites {
        case true:
            podcast.isFavorites = false
           // favBtn.setImage(UIImage(named: "icons8-hearts2"), for: .normal)
            
        case false:
            podcast.isFavorites = true
            favBtn.setImage(UIImage(named: "like"), for: .normal)
            addToFavorites()
        }
       
        
        
        
    }
    fileprivate func showBadgeFeedback(){
        UIApplication.mainTabController()?.viewControllers?[2].tabBarItem.badgeValue = "feedback"
    }

    
    fileprivate func showBadgeHighlight(){
        UIApplication.mainTabController()?.viewControllers?[1].tabBarItem.badgeValue = "חדש"
    }
    
    var podcast: Podcast!{
        didSet{
            episodeTitleLabel.text = podcast.name
            podcastImageView.image = podcast.imageLocal
            miniTitileLabel.text = podcast.name
            miniEpisodeImageView.image = podcast.imageLocal
            setUpNowPlayingInfo()
            setupAudioSession()
            playPodcast()
            
            
            //Set image to lockscreen/notification
            var nowPlayingInfo =
                MPNowPlayingInfoCenter.default().nowPlayingInfo
            let image =  podcast!.imageLocal
  
            let artwork = MPMediaItemArtwork(boundsSize: image.size) { (_) -> UIImage in
              return image
            }
            nowPlayingInfo?[MPMediaItemPropertyArtwork] = artwork
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        }
    }
    
    
   
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = true
        return avPlayer
    }()
    

    
    fileprivate func playPodcast(){        
        let urlD = podcast.urlAddress
        
        //url encode from hebrew
        let urlHebrew = urlD!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let url = URL(string: urlHebrew ?? "") else {return}

        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        //chatButton.isHidden = false
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
        setupInterruptionObserver()
        
        
    }
    

    
     static func initFromNib() -> PlayerDetaislView{
        return Bundle.main.loadNibNamed("PlayerDetaislView", owner: self, options: nil)?.first as! PlayerDetaislView
    }
    
fileprivate func setupInterruptionObserver(){
        let notificationCenter = NotificationCenter.default
        let session = AVAudioSession.sharedInstance()
        
        

        notificationCenter.addObserver(self,
                                       selector: #selector(handleInterruption),
                                       name: AVAudioSession.interruptionNotification,
                                       object: nil)
    }

    @objc fileprivate func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                return
        }
        if type.rawValue == AVAudioSession.InterruptionType.began.rawValue {
            print("Interruption began")
            
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            miniPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            
        } else {
            print("Interruption ended...")
            
            guard let options = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            
            if options == AVAudioSession.InterruptionOptions.shouldResume.rawValue {
                player.play()
                playPauseButton.setImage(UIImage(named: "play"), for: .normal)
                miniPlayPauseButton.setImage(UIImage(named: "play"), for: .normal)
            }
            
            
        }
    }
    
    
    
    
    
    
    
    
    
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
