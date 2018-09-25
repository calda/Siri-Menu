//
//  ViewController.swift
//  Siri Menu
//
//  Created by Cal Stephens on 9/25/18.
//  Copyright © 2018 Cal Stephens. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        let sampleMenuUrl = Bundle.main.url(forResource: "Sample Menu", withExtension: "docx")!
        
        present(DocxParserViewController(
            with: sampleMenuUrl,
            completionHandler: { menu in
                
                
                print(menu.lunch(on: .tuesday))
                
                
                
        }), animated: true)
        
        
    }


}

