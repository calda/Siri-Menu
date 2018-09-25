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
            
            let yearFormatter = DateFormatter()
            yearFormatter.dateFormat = "MM/dd/yyyy"
            
            let knownSunday = yearFormatter.date(from: "1/2/2000")!
            let correspondingDay = knownSunday.addingTimeInterval(60 * 24 * 24)
            return DayOfWeek(from: weekdayFormatter.string(from: correspondingDay))
        }
    }
    
    enum Meal: String, Codable {
        case lunch, dinner
    }
    
    // MARK: Persistence
    
    static var current: Menu? {
        get {
            let decoder = JSONDecoder()
            let data = UserDefaults.standard.data(forKey: "menu")!
            return try! decoder.decode(Menu.self, from: data)
        }
        set {
            // serialize the menu
            let encoder = JSONEncoder()
            UserDefaults.standard.set(try! encoder.encode(newValue), forKey: "menu")
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
    
    
    // MARK: Parsing
    
    init(from docxContents: String) {
        
        var data = [DayOfWeek: [Meal: String]]()
        
        var currentDay: DayOfWeek?
        var menuForDay = [Meal: String]()
        var menuItemBeingBuilt = ""
        
        var lines = docxContents.components(separatedBy: "\n")
        lines.append("") // add an extra empty line to keep the behavior consistent
        
        for untrimmedLine in lines  {
            let line = untrimmedLine.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // if there isn't a day being parsed and we reach a new day, start parsing that day
            if currentDay == nil, let dayFromLine = DayOfWeek(from: line) {
                currentDay = dayFromLine
                menuForDay = [Meal: String]()
                menuItemBeingBuilt = ""
            }
            
            else if let day = currentDay {
                
                // if the line has content, add it to the menu item being built
                if !line.isEmpty {
                    menuItemBeingBuilt = [menuItemBeingBuilt, line].joined(separator: "\n")
                }
                
                else if line.isEmpty {
                    if menuForDay[.lunch] == nil {
                        menuForDay[.lunch] = menuItemBeingBuilt.trimmingCharacters(in: .whitespacesAndNewlines)
                        menuItemBeingBuilt = ""
                        
                        // friday has no dinner, commit now
                        if day == .friday {
                            data[.friday] = menuForDay
                            currentDay = nil
                        }
                        
                    } else {
                        menuForDay[.dinner] = menuItemBeingBuilt.trimmingCharacters(in: .whitespacesAndNewlines)
                        
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
