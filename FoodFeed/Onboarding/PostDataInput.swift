//
//  PostDataInput.swift
//  FoodFeed

import UIKit

@available(iOS 13.0, *)
class PostDataInput: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var captionOutlet: UITextField!
    

    @IBAction func caption(_ sender: UITextField) {
    }
    
    @IBAction func bigText(_ sender: Any) {
    }
    
    @IBAction func user(_ sender: Any) {
    }
    
    @IBAction func hashtag(_ sender: UITextField) {
    }
    
    @IBAction func finish(_ sender: Any) {
        
            let newPost = PostData(context: context)
            newPost.caption = captionOutlet.text
            saveItems()
    }
    
    
    override func viewDidLoad() {
        
        whereIsMySQLite()
        loadJSON()
    }
    
    func saveItems(){
        do{
            
          try  context.save()
            
        } catch {
            print("Error saving context \(error)")
        }
        
    }
    
    func loadJSON(){
        
        let filePath = Bundle.main.resourcePath!
        let sourceData = "/Day" + String(day) + ".txt"
        
        let data = try! String(contentsOfFile: filePath + sourceData , encoding: String.Encoding.utf8).data(using: .utf8)

        if let parsedData = try! JSONSerialization.jsonObject(with: data!) as? [[String:Any]] {
            var i = 0
            for item in parsedData {
                let newPost = PostData(context: context)
                newPost.id = i as! Int32
               // print(item)
                for (category, value) in item{
                    //print(value)
                    switch category{
                        case "day": newPost.day = value as! Int32
                       // case "id": newPost.id = i as! Int32
                        case "bigtext": newPost.bigtext = value as? String
                        case "caption": newPost.caption = value as? String
                        case "type": newPost.type = value as? String
                        case "user": newPost.user = value as? String
                        case "gif":  newPost.gif = value as? String
                        case "image": newPost.image = value as? String
                        case "video":  newPost.video = value as? String
                        case "hashtag": newPost.hashtag = value as? String
                        case "votea": newPost.votea = value as? String
                        case "voteb": newPost.voteb = value as? String
                        case "votec": newPost.votec = value as? String
                        case "user": newPost.user = value as? String
                        default: break
                    }
                 
                }
                saveItems()
                i = i + 1
            }
        }
    }
    
    func whereIsMySQLite() {
        let path = FileManager
            .default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .last?
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding
        
        print(path ?? "Not found")
    }

}

extension UIImage {
    
    var toData: Data? {
        return pngData()
    }
}
