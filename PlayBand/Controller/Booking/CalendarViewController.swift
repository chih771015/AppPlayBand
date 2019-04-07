//
//  CalendarViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/8.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit
import JKCalendar

class TableViewCell: UITableViewCell{
    
    @IBOutlet weak var timeLabel: UILabel!
}


class CalendarViewController: UIViewController {

    let markColor = UIColor(red: 40/255, green: 178/255, blue: 253/255, alpha: 1)
    var selectDay: JKDay = JKDay(date: Date())
    
    @IBOutlet weak var calendarTableView: JKCalendarTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarTableView.calendar.delegate = self
        calendarTableView.calendar.dataSource = self
        
        calendarTableView.calendar.focusWeek = selectDay.weekOfMonth - 1
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleBackButtonClick(_ sender: Any) {
        let _ = navigationController?.popViewController(animated: true)
    }
    
}

extension CalendarViewController: JKCalendarDelegate{
    
    func calendar(_ calendar: JKCalendar, didTouch day: JKDay){
        selectDay = day
        calendar.focusWeek = day < calendar.month ? 0: day > calendar.month ? calendar.month.weeksCount - 1: day.weekOfMonth - 1
        calendar.reloadData()
    }
    
    func heightOfFooterView(in claendar: JKCalendar) -> CGFloat{
        return 10
    }
    
    func viewOfFooter(in calendar: JKCalendar) -> UIView?{
        let view = UIView()
        let line = UIView(frame: CGRect(x: 8, y: 9, width: calendar.frame.width - 16, height: 1))
        line.backgroundColor = UIColor.lightGray
        view.addSubview(line)
        return view
    }
}

extension CalendarViewController: JKCalendarDataSource {
    
    func calendar(_ calendar: JKCalendar, marksWith month: JKMonth) -> [JKCalendarMark]? {
        
        let firstMarkDay: JKDay = JKDay(year: 2018, month: 1, day: 9)!
        let secondMarkDay: JKDay = JKDay(year: 2018, month: 1, day: 20)!
        
        var marks: [JKCalendarMark] = []
        if selectDay == month{
            marks.append(JKCalendarMark(type: .circle,
                                        day: selectDay,
                                        color: markColor))
        }
        if firstMarkDay == month{
            marks.append(JKCalendarMark(type: .underline,
                                        day: firstMarkDay,
                                        color: markColor))
        }
        if secondMarkDay == month{
            marks.append(JKCalendarMark(type: .hollowCircle,
                                        day: secondMarkDay,
                                        color: markColor))
        }
        return marks
    }
    
    func calendar(_ calendar: JKCalendar, continuousMarksWith month: JKMonth) -> [JKCalendarContinuousMark]?{
        let startDay: JKDay = JKDay(year: 2018, month: 1, day: 17)!
        let endDay: JKDay = JKDay(year: 2018, month: 1, day: 18)!
        
        return [JKCalendarContinuousMark(type: .dot,
                                         start: startDay,
                                         end: endDay,
                                         color: markColor)]
    }
    
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        if indexPath.row % 2 == 0 && indexPath.row != 0 && indexPath.row != 47{
            let hour = indexPath.row / 2
            cell.timeLabel.text = (hour < 10 ? "0": "") + String(hour) + ":00"
        }else{
            cell.timeLabel.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}

