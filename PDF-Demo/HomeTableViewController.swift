//
//  HomeTableViewController.swift
//  
//
//  Created by Xiaodan Wang on 2/14/17.
//
//

import UIKit
import Alamofire
import MBProgressHUD
import WebKit

let pdfArray = ["https://developer.apple.com/programs/terms/apple_developer_agreement.pdf",
                "https://itunesconnect.apple.com/docs/iTunesConnect_DeveloperGuide.pdf",
                "http://www.iso.org/iso/annual_report_2009.pdf"]

class HomeTableViewController: UITableViewController,cellDelegate {

    var fileLocalURLDict = [Int:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.tableFooterView = UIView()
        self.title = "PDF Demo"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pdfArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.nameLabel.text = pdfArray[indexPath.row].components(separatedBy: "/").last!
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }

    //Mark: - custom cell delegate methods
    func didClickDownloadButton(cell: UITableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        print(indexPath?.row ?? "")
        
        
        if let index = indexPath?.row {
            (cell as! TableViewCell).viewButton.isEnabled = true
            downloadFileWithIndex(ind: index)
        }
        
    }
    
    func didClickViewButton(cell: UITableViewCell) {
        let indexPath = self.tableView.indexPath(for: cell)
        print(indexPath?.row ?? "")
        
        
        if let index = indexPath?.row {
            
            print()
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReaderViewController") as! ReaderViewController
            
            let urlString:String! = fileLocalURLDict[index]
            vc.urlString = urlString
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
    
    func downloadFileWithIndex(ind:Int) {
        
        //--2.--//
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.annularDeterminate
        hud.label.text = "Loading..."
        //--2.--//
        
        //--1.--//
        
        let urlString = pdfArray[ind]
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL:NSURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
            print("***documentURL: ",documentsURL)
            let fileURL = documentsURL.appendingPathComponent("\(ind).pdf")
            print("***fileURL: ",fileURL ?? "")
            return (fileURL!,[.removePreviousFile, .createIntermediateDirectories])
        }

        Alamofire.download(urlString, to: destination).downloadProgress(closure: { (prog) in
            hud.progress = Float(prog.fractionCompleted)
        }).response { response in
            //print(response)
            hud.hide(animated: true)
            if response.error == nil, let filePath = response.destinationURL?.path {
                print("mmmm",filePath)
                self.fileLocalURLDict[ind] = filePath
            }
        }
        //--1.--//
        
    }
    

}
