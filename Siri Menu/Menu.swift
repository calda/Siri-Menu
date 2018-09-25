//
//  Menu.swift
//  Siri Menu
//
//  Created by Cal Stephens on 9/25/18.
//  Copyright © 2018 Cal Stephens. All rights reserved.
//

import Foundation

struct Menu: Codable, CustomStringConvertible {
    
    // MARK: Types
    
    enum DayOfWeek: String, Codable, CaseIterable {
        case monday, tuesday, wednesday, thursday, friday
        
        var next: DayOfWeek? {
            switch self {
            case .monday:    return .tuesday
            case .tuesday:   return .wednesday
            case .wednesday: return .thursday
            case .thursday:  return .friday
            case .friday:    return nil
            }
        }
        
        init?(from string: String) {
            switch string {
            case "Monday":    self = .monday
            case "Tuesday":   self = .tuesday
            case "Wednesday": self = .wednesday
            case "Thursday":  self = .thursday
            case "Friday":    self = .friday
            default:          return nil
            }
        }
        
        static var current: DayOfWeek? {
            // use DateFormatter to pluck out localized day names
            let weekdayFormatter = DateFormatter()
            weekdayFormatter.dateFormat = "EEEE"
            return DayOfWeek(from: weekdayFormatter.string(from: Date()))
        }
    }
    
    enum Meal: String, Codable {
        case lunch, dinner
    }
    
    // MARK: Persistence
    
    static var current: Menu? {
        get {
            let decoder = JSONDecoder()
            if let data = UserDefaults.shared.data(forKey: "menu") {
                return try? decoder.decode(Menu.self, from: data)
            } else {
                return nil
            }
        }
        set {
            // serialize the menu
            let encoder = JSONEncoder()
            UserDefaults.shared.set(try! encoder.encode(newValue), forKey: "menu")
        }
    }
    
    
    // MARK: Data
    
    private let data: [DayOfWeek: [Meal: String]]
    
    var description: String {
        return "\(data)"
    }
    
    func meals(for day: DayOfWeek) -> (lunch: String, dinner: String?) {
        return (lunch: data[day]![.lunch]!, dinner: data[day]![.dinner] )
    }
    
    func lunch(on day: DayOfWeek) -> String {
        return meals(for: day).lunch
    }
    
    func dinner(on day: DayOfWeek) -> String? {
        return meals(for: day).dinner
    }
    
    func meal(_ meal: Meal, on day: DayOfWeek) -> String? {
        switch meal {
        case .lunch:  return lunch(on: day)
        case .dinner: return dinner(on: day)
        }
    }
    
    
    // MARK: Parsing
    
    init(from docxContents: String) {
        
        var data = [DayOfWeek: [Meal: String]]()
        
        var currentDay: DayOfWeek?
        var menuForDay = [Meal: String]()
        var menuItems = [String]()
        
        var lines = docxContents.components(separatedBy: "\n")
        lines.append("") // add an extra empty line to keep the behavior consistent
        
        for untrimmedLine in lines  {
            let line = untrimmedLine.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // if there isn't a day being parsed and we reach a new day, start parsing that day
            if currentDay == nil, let dayFromLine = DayOfWeek(from: line) {
                currentDay = dayFromLine
                menuForDay = [Meal: String]()
                menuItems = []
            }
            
            else if let day = currentDay {
                
                // if the line has content, add it to the menu item being built
                if !line.isEmpty {
                    menuItems.append(line.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .punctuationCharacters))
                }
                
                else if line.isEmpty {
                    if menuForDay[.lunch] == nil {
                        menuForDay[.lunch] = menuItems.joinedGramatically()
                        menuItems = []
                        
                        // friday has no dinner, commit now
                        if day == .friday {
                            data[.friday] = menuForDay
                            currentDay = nil
                        }
                        
                    } else {
                        menuForDay[.dinner] = menuItems.joinedGramatically()
                        
                        // commit the fully-built menu
                        data[day] = menuForDay
                        currentDay = nil
                    }
                }
            }
        }
        
        self.data = data
    }
    
}

extension UserDefaults {
    
    static var shared: UserDefaults {
        return UserDefaults(suiteName: "group.SiriMenu")!
    }
    
}

extension Array where Element == String {
    
    func joinedGramatically() -> String {
        if self.count == 0 { return "" }
        if self.count == 1 { return self[0] }
        
        var temp = self
        temp[temp.count - 1] = "and \(temp[temp.count - 1])"
        return temp.joined(separator: ", ")
        
    }
    
    
}
