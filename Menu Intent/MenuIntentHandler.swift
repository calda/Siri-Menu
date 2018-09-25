//
//  MenuIntentHandler.swift
//  Menu Intent
//
//  Created by Cal Stephens on 9/25/18.
//  Copyright © 2018 Cal Stephens. All rights reserved.
//

import Foundation

class MenuIntentHandler: NSObject, MenuIntentHandling {
    
    func handle(intent: MenuIntent, completion: @escaping (MenuIntentResponse) -> Void) {
        
        let dayOfWeek: Menu.DayOfWeek
        switch intent.day {
        case .monday:    dayOfWeek = .monday
        case .tuesday:   dayOfWeek = .tuesday
        case .wednesday: dayOfWeek = .wednesday
        case .thursday:  dayOfWeek = .thursday
        case .friday:    dayOfWeek = .friday
        case .today:
            if let today = Menu.DayOfWeek.current {
                dayOfWeek = today
            } else {
                fallthrough
            }
        case .unknown:
            let response = MenuIntentResponse(code: .invalidDay, userActivity: nil)
            response.day = intent.day
            completion(response)
            return
        }
        
        let meal: Menu.Meal
        switch intent.meal {
        case .lunch:  meal = .lunch
        case .dinner: meal = .dinner
        case .unknown:
            let response = MenuIntentResponse(code: .invalidMealForDay, userActivity: nil)
            response.day = intent.day
            response.meal = intent.meal
            completion(response)
            return
        }
        
        guard let menu = Menu.current else {
            completion(MenuIntentResponse(code: .missingMenu, userActivity: nil))
            return
        }
        
        let food = menu.meal(meal, on: dayOfWeek)
        
        
        let response = MenuIntentResponse(code: .success, userActivity: nil)
        response.day = intent.day
        response.meal = intent.meal
        response.food = food
        completion(response)
    }
    
}
