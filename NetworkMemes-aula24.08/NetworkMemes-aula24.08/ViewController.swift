//
//  ViewController.swift
//  NetworkMemes-aula24.08
//
//  Created by Maysa on 24/08/21.
//

import UIKit
import Alamofire


class ViewController: UIViewController {
    
    @IBOutlet weak var myImageMeme: UIImageView!
    
    @IBOutlet weak var nameMeme: UILabel!
    
    @IBOutlet weak var myTableView: UITableView!

    private var memes: [MemesClass] = []
    private var vc: ViewController = ViewController()
    var selectedMeme: MemesClass?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        
        AF.request("https://api.imgflip.com/get_memes").responseJSON { response in
            
            if response.response?.statusCode == 200 {
               
                if let data = response.data {
                    
                    do {
                        
                        let result: Result? = try JSONDecoder().decode(Result.self, from: data)
                        print(result?.data.memes.count as Any)
                        
                    }catch{
                        
                        print(error)
                    }
                    
                }
                
                print("status code = \(String(describing: response.response?.statusCode))")
            }
            
            
        }
        func imageFromWeb() {
            if let selectedMeme = self.selectedMeme {
                AF.request("\(selectedMeme.image)").responseJSON { response in
                    if response.response?.statusCode == 200 {
                        if let data = response.data {
                            print(data)
                            do {
                                if let image: UIImage = UIImage(data: data) {
                                    self.myImageMeme.image = image
                                }
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
            }
            
        }
    }


}
extension ViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = memes[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        return self.memes.count

    
}
}

