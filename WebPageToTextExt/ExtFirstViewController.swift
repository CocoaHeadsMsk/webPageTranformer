//
//  ExtFirstViewController.swift
//  WebPageToTextExtension
//
//  Created by Nikita Pestrov on 28.06.14.
//  Copyright (c) 2014 NikitaPestrov. All rights reserved.
//

import UIKit
import MobileCoreServices

class ExtFirstViewController: UIViewController {

    @IBOutlet var mainTextView: UITextView
    let baseURL = "http://boilerpipe-web.appspot.com/extract"
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        for item: AnyObject in self.extensionContext.inputItems! {
            let inputItem = item as NSExtensionItem
            for provider: AnyObject in inputItem.attachments! {
                let itemProvider = provider as NSItemProvider
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypePropertyList) {
                    itemProvider.loadItemForTypeIdentifier(kUTTypePropertyList, options: nil, completionHandler: { (results, error) in
                        if let dictWithValues = results as? NSDictionary {
                            for (key : AnyObject, value : AnyObject) in dictWithValues {
                                if (key as String == NSExtensionJavaScriptPreprocessingResultsKey) {
                                    if let url:NSString = value["baseURI"] as? String {
                                        self.extractTextFromWebPage(url)
                                    }
                                }
                                
                            }
                        }
                        })
                }
            }
        }
    }
    
    func extractTextFromWebPage (hyperlink:String) {
        let request = HTTPTask()
        request.GET(baseURL, parameters: ["url": hyperlink, "output": "json"], success: {(response: AnyObject?) -> Void in
            let data = response as NSData
            let responseDictionary : NSDictionary =  NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
            if (responseDictionary["status"] as String  == "success") {
                let finalData:NSDictionary = responseDictionary["response"] as NSDictionary
                let content = finalData["content"] as String
                dispatch_sync(dispatch_get_main_queue()) {
                    self.mainTextView.text = finalData["content"] as String
                }
            }
            },failure: {(error: NSError) -> Void in
                println("error: \(error)")
            })
    }
}
