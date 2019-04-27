import UIKit
import MobileCoreServices
import AVFoundation
import Firebase
import Kingfisher
import FirebaseStorage

class PicScrollingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var gameView: UIView!
    //@IBOutlet weak var clickCounterLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var showSolutionButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    //@IBOutlet weak var difficultyControl: UISegmentedControl!
    @IBOutlet weak var muteToggle: UISwitch!
    @IBOutlet weak var time4: UILabel!
    @IBOutlet weak var score4: UILabel!
    
    
    var gameViewWidth : CGFloat!
    var blockWidth : CGFloat!
    var visibleBlocks : Int!
    var rowSize : Int!
    var xCenter : CGFloat!
    var yCenter : CGFloat!
    var finalBlock : MyBlock!
    var blockArray: NSMutableArray = []
    var centersArray: NSMutableArray = []
    var images: [UIImage] = []
    var gameImage : UIImage!
    var empty: CGPoint!
    var clickCount : Int = 0
    var audioPlayer = AVAudioPlayer()
    var gameOver : Bool = false
    
    var create: DatabaseReference!
    

   
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var myImageView: UIImageView!
    
    
    @IBAction func gameGiveUp(_ sender: Any) {
        
        displayGiveUpAlert()
        
    }
    
    
    
     let imagePicker = UIImagePickerController()
     var ref = DatabaseReference.init()
    

    
    override func viewDidAppear(_ animated: Bool) {
        
        //downloadPic()
        
        
//        let database = Database.database().reference()
//        let storageRef = Storage.storage().reference()
//        let imagesRef = storageRef.child("Image/myimage.png")
//
//        //let imageDL = UIImage(named: myimage.png)
//
//
//        imagesRef.getData(maxSize: 1*1000*1000) { (data, error) in
//            if error == nil {
//                print(data!)
//                self.myImageView.image = UIImage(data: data!)
//                self.gameImage = self.myImageView.image
//
//
//            } else {
//                print(error?.localizedDescription as Any)
//
//            }
//
//        }
//
//
    
        // getAllFIRData()
        
    }
    
    
   
    
    override func viewDidLoad() {
        
        updateTimer()
        
        //downloadPic()

        
        self.ref = Database.database().reference()
        //start tinmer
        runTimer()
        
        super.viewDidLoad()
        //downloadPic()
        gameImage = #imageLiteral(resourceName: "IMG_9125.JPG")
        myImageView.image = gameImage
        rowSize = 3
        //difficultyControl.selectedSegmentIndex =  1
        scaleToScreen()
        makeBlocks()
        // playBackgroundMusic()
       // muteToggle.addTarget(self, action: #selector(toggleMusic), for: UIControlEvents.valueChanged)
        //self.ResetButton(Any.self)
        
        ResetButton()
        
    
       
    
        
    }
    
//    func downloadPic() {
//
//        create = Database.database().reference().child("Location")
//        create.observe(DataEventType.value, with: {(snapshot) in
//
//            var ChatModel: ChattModel?{
//                didSet{
//                    let url = URL(string: (ChatModel?.profileImageURL)!)
//                    if let url = url{
//                        KingfisherManager.shared.retrieveImage(with: url as Resource, options: nil,
//                                                               progressBlock: nil) { (image, error, cache, imageURL) in
//                                                                self.myImageView.image = image
//                                                                self.myImageView.kf.indicatorType = .activity
//                                                                self.myImageView.image = self.gameImage
//
//
//                        }
//                    }
//                }
//            }
//
//        })
//
//
//    }
    
    
//    func saveFIRData() {
//        self.uploadImage(self.myImageView.image!){ url in
//
//            self.saveImage(name: "name" ,profileURL: url!){ success in
//                if success != nil{
//                    print("Yeah")
//                }
//            }
//        }
//
//    }
    
    func scaleToScreen() {
        gameView.frame.size.height = gameView.frame.size.width
        //timerLabel.frame.size.width = gameView.frame.size.width
        //uploadImageButton.frame.size.width = (gameView.frame.size.width / 2) - 5
        //uploadImageButton.frame.size.width = (gameView.frame.size.width / 2) - 5
        //resetButton.frame.size.width = gameView.frame.size.width
    }
    
    func makeBlocks() {
        blockArray = []
        centersArray = []
        visibleBlocks = (rowSize * rowSize) - 1
        
        gameViewWidth = gameView.frame.size.width
        blockWidth = gameViewWidth / CGFloat(rowSize)
        
        xCenter = blockWidth / 2
        yCenter = blockWidth / 2
        
        images = slice(image: gameImage, into:rowSize)
        var picNum = 0
        
        for _ in 0..<rowSize {
            for _ in 0..<rowSize {
                let blockFrame : CGRect = CGRect(x: 0, y: 0, width: blockWidth, height: blockWidth)
                let block: MyBlock = MyBlock (frame: blockFrame)
                let thisCenter : CGPoint = CGPoint(x: xCenter, y: yCenter)
                
                block.isUserInteractionEnabled = true
                block.image = images[picNum]
                picNum += 1
                
                block.center = thisCenter
                block.originalCenter = thisCenter
                gameView.addSubview(block)
                blockArray.add(block)
                
                xCenter = xCenter + blockWidth
                centersArray.add(thisCenter)
            }
            xCenter = blockWidth / 2
            yCenter = yCenter + blockWidth
        }
        
        finalBlock = blockArray[visibleBlocks] as! MyBlock
        finalBlock.removeFromSuperview()
        blockArray.removeObject(identicalTo: finalBlock)
        
    }
    
    func slice(image: UIImage, into howMany: Int) -> [UIImage] {
        
        let width: CGFloat = image.size.width
        let height: CGFloat = image.size.height
        let tileWidth = Int(width / CGFloat(howMany))
        let tileHeight = Int(height / CGFloat(howMany))
        let scale = Int(image.scale)
        var imageSections = [UIImage]()
        let cgImage = image.cgImage!
        var adjustedHeight = tileHeight
        
        var y = 0
        for row in 0 ..< howMany {
            if row == (howMany - 1) {
                adjustedHeight = Int(height) - y
            }
            var adjustedWidth = tileWidth
            var x = 0
            for column in 0 ..< howMany {
                if column == (howMany - 1) {
                    adjustedWidth = Int(width) - x
                }
                let origin = CGPoint(x: x * scale, y: y * scale)
                let size = CGSize(width: adjustedWidth * scale, height: adjustedHeight * scale)
                let tileCgImage = cgImage.cropping(to: CGRect(origin: origin, size: size))!
                imageSections.append(UIImage(cgImage: tileCgImage, scale: image.scale, orientation: image.imageOrientation))
                x += tileWidth
            }
            y += tileHeight
        }
        return imageSections
    }
    
    //    func playBackgroundMusic() {
    //        let aSound = NSDataAsset(name: "background_music")
    //        do {
    //            audioPlayer = try AVAudioPlayer(data:(aSound?.data)!, fileTypeHint: "mp3")
    //            audioPlayer.numberOfLoops = -1
    //            audioPlayer.prepareToPlay()
    //            audioPlayer.play()
    //        } catch {
    //            print("Cannot play the file")
    //        }
    //    }
    
//    @objc func toggleMusic(switchState: UISwitch) {
//        if switchState.isOn {
//            audioPlayer.play()
//        } else {
//            audioPlayer.stop()
//        }
//    }
    
    func ResetButton() {
        clickCount = 0
        //clickCounterLabel.text = String.init(format: "%d", clickCount)
        finalBlock.removeFromSuperview()
        gameOver = false
        setUserInteractionStateForAllBlocks(state: true)
        scramble()
        resetTimer()
        runTimer()
    }
//กรณีทำได้
    @IBAction func showEndAlert(_ sender: Any) {
        let alert = UIAlertController(title: "Congrats!!!", message: "You did it in \(seconds) seconds \n YOU GOT \(scoree) POINT!", preferredStyle: .alert)
        let scoreUpload = scoree
        //alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Next", style: .default, handler: { (nil) in
            
            let MemberRef : DatabaseReference! = Database.database().reference(withPath: "Ranking")
            
            let SettingData: Dictionary<String,AnyObject> =
                ["Picture" : Int(scoreUpload) as AnyObject]
            //////แก้
            //let ScoreItemRef = MemberRef.child("\(UserHomeViewController.Channelname)/\(ViewController.userEmail!)") << Real
            let ScoreItemRef = MemberRef.child(UserHomeViewController.Channelname).child("Group").child(ViewController.Groupname).child(ViewController.userEmail)
              ScoreItemRef.updateChildValues(SettingData)//ส่งขึ้น firebase
            
            let homeView = self.storyboard?.instantiateViewController(withIdentifier: "userhomeview") as! UserHomeViewController
            
            self.present(homeView, animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true)
        
    }
    
//กรณีเวลาหมด
    @IBAction func timeUpAlert(_ sender: Any) {
        let alert = UIAlertController(title: "Time Up!!!", message: "YOU GOT \(scoree) POINT", preferredStyle: .alert)
        let scoreUpload = scoree
        //alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Next", style: .default, handler: { (nil) in
            
            let MemberRef : DatabaseReference! = Database.database().reference(withPath: "Ranking")
            
            let SettingData: Dictionary<String,AnyObject> =
                ["Picture" : Int(scoreUpload) as AnyObject]
            //////แก้
            //let ScoreItemRef = MemberRef.child("\(UserHomeViewController.Channelname)/\(ViewController.userEmail!)") << Real
           let ScoreItemRef = MemberRef.child(UserHomeViewController.Channelname).child("Group").child(ViewController.Groupname).child(ViewController.userEmail)
               ScoreItemRef.updateChildValues(SettingData)//ส่งขึ้น firebase
            let homeView = self.storyboard?.instantiateViewController(withIdentifier: "userhomeview") as! UserHomeViewController
            
            self.present(homeView, animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true)
    }

//กรณีกดยอมแพ้
    @IBAction func timeGiveUp(_ sender: Any) {
        let alert = UIAlertController(title: "Give Up!!!", message: "YOU GOT 0 POINT", preferredStyle: .alert)
        let scoreUpload = 0
        //alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Next", style: .default, handler: { (nil) in
            
            let MemberRef : DatabaseReference! = Database.database().reference(withPath: "Ranking")
            
            let SettingData: Dictionary<String,AnyObject> =
                ["Picture" : Int(scoreUpload) as AnyObject]
            //////แก้
            //let ScoreItemRef = MemberRef.child("\(UserHomeViewController.Channelname)/\(ViewController.userEmail!)") << Real
            let ScoreItemRef = MemberRef.child(UserHomeViewController.Channelname).child("Group").child(ViewController.Groupname).child(ViewController.userEmail)
                ScoreItemRef.updateChildValues(SettingData)//ส่งขึ้น firebase
            
            let homeView = self.storyboard?.instantiateViewController(withIdentifier: "userhomeview") as! UserHomeViewController
            
            self.present(homeView, animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true)
    }
    
    func scramble() {
        let temporaryCentersArray: NSMutableArray = centersArray.mutableCopy() as! NSMutableArray
        for anyBlock in blockArray {
            let randomIndex: Int = Int(arc4random()) % temporaryCentersArray.count
            let randomCenter: CGPoint = temporaryCentersArray[randomIndex] as! CGPoint
            (anyBlock as! MyBlock).center = randomCenter
            temporaryCentersArray.removeObject(at: randomIndex)
        }
        empty = temporaryCentersArray[0] as! CGPoint
    }
    
    func clearBlocks(){
        for i in 0..<visibleBlocks {
            (blockArray[i] as! MyBlock).removeFromSuperview()
        }
        finalBlock.removeFromSuperview()
        blockArray = []
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let myTouch : UITouch = touches.first!
        if (blockArray.contains(myTouch.view as Any))        {
            
            let touchView: MyBlock = (myTouch.view)! as! MyBlock
            
            let xOffset: CGFloat = touchView.center.x - empty.x
            let yOffset: CGFloat = touchView.center.y - empty.y
            
            let distanceBetweenCenters : CGFloat = sqrt(pow(xOffset, 2) + pow(yOffset, 2))
            
            if (Int(distanceBetweenCenters) == Int(blockWidth)) {
                let temporaryCenter : CGPoint = touchView.center
                
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.2)
                touchView.center = empty
                UIView.commitAnimations()
                
                //self.clickAction()
                empty = temporaryCenter
                checkBlocks()
                
                if gameOver == true {
                    setUserInteractionStateForAllBlocks(state: false)
                    displayFinalBlock()
                    displayGameOverAlert()
                    //NextgameAR()
                    
                    
                }
            }
        }
    }
    
    
//    func NextgameAR() {
//
//
//        let scoreUpload = scoree
//
//        let alert = UIAlertController(title: "Success", message: "You got score:\(scoree)!!" , preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
//
//        alert.addAction(UIAlertAction(title: "Next", style: .default, handler: { (nil) in
//
//            let dict = ["name": "Kivy", "Score": scoreUpload] as [String: Any]
//            self.ref.child("score").childByAutoId().setValue(dict)
//
//            //ถ้าเข้าร่วมกลุ่ม  ให้เด้งไปหน้า Nextpage
//            //(withIdentifier: "next") ใส่ตรง StorybordID ของหน้าที่ต้องการให้เด้งไปนะจ๊ะ
////            let homeView = self.storyboard?.instantiateViewController(withIdentifier: "nextgame") as! next
////            self.present(homeView, animated: true, completion: nil)
//        }))
//        present(alert, animated: true, completion: nil)
//    }
    
    
    
    
    
//    @objc func clickAction() {
//        clickCount += 1
//        clickCounterLabel.text = String.init(format: "%d", clickCount)
//    }
    
    func checkBlocks() {
        var correctBlockCounter = 0
        
        for i in 0..<visibleBlocks {
            if (blockArray[i] as! MyBlock).center == (blockArray[i] as! MyBlock).originalCenter {
                correctBlockCounter += 1
            }
        }
        if correctBlockCounter == visibleBlocks {
            //gameOver = true
            gameOver = true
            
        }
        
        else {
            gameOver = false
        }
    }
    
    func setUserInteractionStateForAllBlocks(state: Bool) {
        for i in 0..<visibleBlocks {
            (blockArray[i] as! MyBlock).isUserInteractionEnabled = state
        }
    }
    
    func displayFinalBlock() {
        gameView.addSubview(finalBlock)
    }
    
    func displayGameOverAlert() {
        self.showEndAlert(Any.self)
    }
    
    func displayTimeUpAlert() {
        self.timeUpAlert(Any.self)
    }
    
    func displayGiveUpAlert() {
        self.timeGiveUp(Any.self)
    }
    
//    @IBAction func showSolutionTapped(_ sender: Any) {
//        showSolutionButton.isUserInteractionEnabled = false
//        //difficultyControl.isUserInteractionEnabled = false
//        resetButton.isUserInteractionEnabled = false
//        
//        if (gameOver == false) {
//            let tempCentersArray : NSMutableArray = []
//            (self.finalBlock).center = self.empty
//            
//            for i in 0..<visibleBlocks {
//                tempCentersArray.add((blockArray[i] as! MyBlock).center)
//            }
//            
//            UIView.animate(withDuration: 1, animations: {
//                for i in 0..<self.visibleBlocks {
//                    (self.self.blockArray[i] as! MyBlock).center = (self.blockArray[i] as! MyBlock).originalCenter
//                }
//                self.gameView.addSubview(self.finalBlock)
//                (self.finalBlock).center = (self.finalBlock).originalCenter
//            }) { _ in
//                UIView.animate(withDuration: 2, delay: 3, animations: {
//                    for i in 0..<self.visibleBlocks {
//                        (self.blockArray[i] as! MyBlock).center = (tempCentersArray[i] as! CGPoint)
//                    }
//                    (self.finalBlock).center = self.empty
//                }) { _ in
//                    UIView.animate(withDuration: 2, animations: {
//                        self.finalBlock.removeFromSuperview()
//                        (self.finalBlock).center = (self.finalBlock).originalCenter
//                    }) { _ in
//                        //self.difficultyControl.isUserInteractionEnabled = true
//                        self.resetButton.isUserInteractionEnabled = true
//                        self.showSolutionButton.isUserInteractionEnabled = true
//                    }
//                }
//            }
//        }
//    }
    
    
    //    @IBAction func difficultyTapped(_ sender: Any) {
    //        clearBlocks()
    //        switch difficultyControl.selectedSegmentIndex
    //        {
    //            case 0:
    //            rowSize = 4
    ////            case 1:
    ////            rowSize = 4
    ////            case 2:
    ////            rowSize = 5
    //        default:
    //            rowSize = 4
    //        }
    //        visibleBlocks = (rowSize * rowSize) - 1
    //        makeBlocks()
    //        self.ResetButton(Any.self)
    //    }
    
    //****ดึงรูปจากเครื่อง มาอัพโหลดขึ้น Firebase****//
    
//    @IBAction func uploadImageTapped(_ sender: Any) {
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//            imagePicker.mediaTypes = [kUTTypeImage as String]
//            imagePicker.allowsEditing = false
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
//        if mediaType.isEqual(to: kUTTypeImage as String) {
//            gameImage = info[UIImagePickerControllerOriginalImage] as! UIImage
//            myImageView.image = gameImage
//            clearBlocks()
//            //makeBlocks()
//            //self.ResetButton(Any.self)
//            self.saveFIRData()
//            self.getAllFIRData()
//        }
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    @objc func imageError (image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
//        if error != nil {
//            let alert = UIAlertController(title: "Save failed", message: "Failed to save image", preferredStyle: .alert)
//            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            alert.addAction(cancelAction)
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
    ////////////////////////////////
    
    // MARK: - timer
    
    //to store how many sceonds the game is played for
    var seconds = 30
    var scoree = 10
    //timer
    var timer = Timer()
    
    //to keep track of whether the timer is on
    var isTimerRunning = false
    
    //to run the timer
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    
    
    //decrements seconds by 1, updates the timerLabel and calls gameOver if seconds is 0
    @objc func updateTimer() {
//        if seconds == 300 {
//            timer.invalidate()
//
//            //gameOverr()
//        }
        
        if seconds == 40 {
            seconds += 1
            time4.text = "\(seconds)"
            scoree -= 1
            score4.text = "\(scoree)"
        }
        else if seconds == 80 {
            seconds += 1
            time4.text = "\(seconds)"
            scoree -= 1
            score4.text = "\(scoree)"
        }
        else if seconds == 120 {
            seconds += 1
            time4.text = "\(seconds)"
            scoree -= 1
            score4.text = "\(scoree)"
        }
        else if seconds == 160 {
            seconds += 1
            time4.text = "\(seconds)"
            scoree -= 1
            score4.text = "\(scoree)"
        }
        else if seconds == 200 {
            seconds += 1
            time4.text = "\(seconds)"
            scoree -= 1
            score4.text = "\(scoree)"
        }
        else if seconds == 240 {
            seconds += 1
            time4.text = "\(seconds)"
            scoree -= 1
            score4.text = "\(scoree)"
        }
        else if seconds == 280 {
            seconds += 1
            time4.text = "\(seconds)"
            scoree -= 1
            score4.text = "\(scoree)"
        }
        else if seconds == 320 {
            seconds += 1
            time4.text = "\(seconds)"
            scoree -= 1
            score4.text = "\(scoree)"
        }
        else if seconds == 360 {
            seconds += 1
            time4.text = "\(seconds)"
            scoree -= 1
            score4.text = "\(scoree)"
        }
        else if seconds == 400 {
            gameOver = true
            if gameOver == true {
                setUserInteractionStateForAllBlocks(state: false)
                displayFinalBlock()
                displayTimeUpAlert()
                //NextgameAR()
            }
        }
            
            
        else if gameOver == true {
            
            time4.text = "\(seconds)"
            
            score4.text = "\(scoree)"
 
        }
            
        else{
            seconds += 1
            time4.text = "\(seconds)"
        }
    }
    
    //resets the timer
    func resetTimer(){
        timer.invalidate()
        seconds = 0
        time4.text = "\(seconds)"
        scoree = 10
        score4.text = "\(scoree)"
        
    }
    

    
    // MARK: - score
    
    
    
    
    
    
    
    //
    //   @objc func Updategamescore(){
    //        if seconds == 5 {
    //            scoree -= 1
    //            score4.text = "\(scoree)"
    //        }
    ////        //store the score in UserDefaults
    ////        let defaults = UserDefaults.standard
    ////        defaults.set(scoree, forKey: "score")
    ////
    ////        //go back to the Home View Controller
    ////        self.dismiss(animated: true, completion: nil)
    //    }
    //
    //////////////////////////////////////////
    
  
 
    
    
    
    
    
  

    
    
    
    
    
//    func getAllFIRData(){
//
////
//        self.ref.child("test").queryOrderedByKey().observe(.value) { (snapshot) in
//            self.arrData.removeAll()
//            if let snapShot = snapshot.children.allObjects as? [DataSnapshot]{
//                for snap in snapShot {
//                    if let mainDict = snap.value as? [String: AnyObject]{
//                        let name = mainDict["name"] as? String
//                        let profileImageURL = mainDict["profileImageURL"] as? String ?? ""
//                        //self.arrData.append(ChattModel(name: name!, profileImageURL: profileImageURL))
//
//
//                        print(name!)
//                        print(profileImageURL)
//
//                        //let imagedownload = ChattModel(name: name! , profileImageURL: profileImageURL)
//                        //attraction.name = title
//
//
//
//
//
//
//                    }
//                }
//            }
//
//        }
//    }
    
}


class MyBlock : UIImageView {
    var originalCenter: CGPoint!
}

//extension PicScrollingViewController {
//
//    func uploadImage(_ image:UIImage, completion: @escaping ((_ url: URL?) -> ())) {
//
//        let storageRef = Storage.storage().reference().child("myimage.png")
//        let imgData = UIImagePNGRepresentation(myImageView.image!)
//        let imageFromData = UIImage(data: imgData!)
//
//        let metaData = StorageMetadata()
//        metaData.contentType = "image/png"
//        storageRef.putData(imgData!, metadata: metaData) { (metadata, error) in
//            if error == nil{
//                print("success")
//                storageRef.downloadURL(completion: { (url, error) in
//                    completion(url)
//                })
//            }else{
//                print("error in save image")
//                completion(nil)
//            }
//
//
//        }
//
//    }

    /*
     let dict = ["name": "Kivy", "text": txtText.text!]
     self.ref.child("chat").childByAutoId().setValue(dict)
     */
    
//    func saveImage(name: String, profileURL:URL, completion: @escaping ((_ url: URL?) -> ())){
//
//        let dict = ["name": "Kivy", "profileUrl": profileURL.absoluteString] as [String: Any]
//        self.ref.child("test").childByAutoId().setValue(dict)
//
//
//
//    }
    
    
  
    
//}





//class ChattModel  {
//
//    var name: String?
//    var profileImageURL: String?
//
//    init(name: String, profileImageURL: String) {
//        self.name = name
//        self.profileImageURL = profileImageURL
//
//
//
//    }

    
    
//}
