//
//  ShortcutsViewController.swift
//  Siri Menu
//
//  Created by Cal Stephens on 9/25/18.
//  Copyright © 2018 Cal Stephens. All rights reserved.
//

import UIKit
import IntentsUI

class ShortcutsViewController: UITableViewController {
    
    let days = [MenuDay.today, .tomorrow, .monday, .tuesday, .wednesday, .thursday, .friday]
    
}

extension ShortcutsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return days.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch days[section] {
        case .friday:
            return 1
        default:
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch days[section] {
        case .today:     return "Today"
        case .tomorrow:  return "Tomorrow"
        case .monday:    return "Monday"
        case .tuesday:   return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday:  return "Thursday"
        case .friday:    return "Friday"
        case .unknown:   return "Unknown"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let intent = MenuIntent()
        intent.setImage(INImage(uiImage: UIImage(named: "carlos")!), forParameterNamed: \.meal)
        intent.day = days[indexPath.section]
        
        let cell = UITableViewCell()
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        
        let sectionTitle = self.tableView(tableView, titleForHeaderInSection: indexPath.section)!
        
        if indexPath.item == 0 {
            intent.meal = .lunch
            cell.textLabel?.text = "Lunch (\(sectionTitle))"
        } else {
            intent.meal = .dinner
            cell.textLabel?.text = "Dinner (\(sectionTitle))"
        }
        
        let shortcutButton = INUIAddVoiceShortcutButton(style: .black)
        shortcutButton.translatesAutoresizingMaskIntoConstraints = false
        shortcutButton.shortcut = INShortcut(intent: intent)
        shortcutButton.delegate = self
        cell.contentView.addSubview(shortcutButton)
        cell.layoutMarginsGuide.trailingAnchor.constraint(equalTo: shortcutButton.trailingAnchor).isActive = true
        cell.centerYAnchor.constraint(equalTo: shortcutButton.centerYAnchor).isActive = true
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

extension ShortcutsViewController: INUIAddVoiceShortcutButtonDelegate {
    
    func present(
        _ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController,
        for addVoiceShortcutButton: INUIAddVoiceShortcutButton)
    {
        addVoiceShortcutViewController.delegate = self
        self.present(addVoiceShortcutViewController, animated: true, completion: nil)
    }
    
    func present(
        _ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController,
        for addVoiceShortcutButton: INUIAddVoiceShortcutButton)
    {
        editVoiceShortcutViewController.delegate = self
        self.present(editVoiceShortcutViewController, animated: true, completion: nil)
    }
    
}

extension ShortcutsViewController: INUIAddVoiceShortcutViewControllerDelegate {
    
    func addVoiceShortcutViewController(
        _ controller: INUIAddVoiceShortcutViewController,
        didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

extension ShortcutsViewController: INUIEditVoiceShortcutViewControllerDelegate {
    
    func editVoiceShortcutViewController(
        _ controller: INUIEditVoiceShortcutViewController,
        didUpdate voiceShortcut: INVoiceShortcut?, error: Error?)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewController(
        _ controller: INUIEditVoiceShortcutViewController,
        didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }

}
