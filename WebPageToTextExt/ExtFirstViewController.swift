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
                                if (NSExtensionJavaScriptPreprocessingResultsKey == key as NSString) {
                                    if let url:NSString = value["baseURI"] as? NSString {
                                        self.mainTextView.text = url
                                    }
                                }
                                let dictFromJS:NSDictionary? = value as? NSDictionary
                                
                            }
                        }
                        })
                }
            }
        }
    }
}
