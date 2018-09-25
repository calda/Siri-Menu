//
//  ViewController.swift
//  Siri Menu
//
//  Created by Cal Stephens on 9/25/18.
//  Copyright © 2018 Cal Stephens. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var menu: Menu? = .current
    
    @IBOutlet weak var tableView: UITableView!
    
    public func saveMenu(from url: URL) {
        present(DocxParserViewController(
            with: url,
            completionHandler: { menu in

                Menu.current = menu
                self.menu = menu
                self.tableView.reloadData()
          
        }), animated: true)
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if menu == nil { return 0 }
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1, 2, 3: return 2
        case 4: return 1
        default: fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let menu = menu else { return UITableViewCell() }
        
        let dayOfWeek: Menu.DayOfWeek
        switch indexPath.section {
        case 0: dayOfWeek = .monday
        case 1: dayOfWeek = .tuesday
        case 2: dayOfWeek = .wednesday
        case 3: dayOfWeek = .thursday
        case 4: dayOfWeek = .friday
        default: fatalError()
        }
        
        let mealName: String
        let mealText: String
        
        switch indexPath.item {
        case 0:
            mealName = "Lunch"
            mealText = menu.lunch(on: dayOfWeek)
        case 1:
            mealName = "Dinner"
            mealText = menu.dinner(on: dayOfWeek)!
        default:
            fatalError()
        }
        
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(mealName): \(mealText.replacingOccurrences(of: "\n", with: ", "))"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Monday"
        case 1: return "Tuesday"
        case 2: return "Wednesday"
        case 3: return "Thursday"
        case 4: return "Friday"
        default: return nil
        }
    }
    
    
}
