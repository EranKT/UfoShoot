//
//  KTF_Date.swift
//  UfoShoot
//
//  Created by EKT DIGIDESIGN on 2/12/18.
//  Copyright © 2018 EKT DIGIDESIGN. All rights reserved.
//

import Foundation

let SAVED_DATE_LAST_PLAYED = "date_last_played" // INT

class KTF_Date {
    
    func isFirstTimeToday() -> Bool
    {

      /*  //Ref date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let oldDate = dateFormatter.date(from: "03/10/2015") // - CHANGE TO SAVED DATE
      */
        //Get calendar
        let calendar = NSCalendar.current
        let currentDate = Date()
        //Get just MM/dd/yyyy from current date
        let Currentcomponents = calendar.dateComponents([.year, .month, .day], from: currentDate)
       
        let oldDate = KTF_DISK().getDate(forKey: SAVED_DATE_LAST_PLAYED)

        
        //Convert to NSDate
        let today = calendar.date(from: Currentcomponents)
        
        if oldDate == today {
            //someDate is berofe than today
            print("SAME DATE",today!)
            return false
       } else {
            //someDate is equal or after than today
            print("DEFFERENT DATE OLD", oldDate)
            print("DEFFERENT DATE NOW", today!)
            KTF_DISK().saveDate(date: today!, forKey: SAVED_DATE_LAST_PLAYED)
            
            print("DEFFERENT DATE SAVED", KTF_DISK().getDate(forKey: SAVED_DATE_LAST_PLAYED))

 // SAVE NEW DATE
            return true
        }
}
}

