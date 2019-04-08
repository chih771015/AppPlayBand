//
//  CalendarViewController.swift
//  PlayBand
//
//  Created by 姜旦旦 on 2019/4/8.
//  Copyright © 2019 姜旦旦. All rights reserved.
//

import UIKit
import JKCalendar


class CalendarViewController: UIViewController {

    let markColor = UIColor(red: 40/255, green: 178/255, blue: 253/255, alpha: 1)
    var selectDay: JKDay = JKDay(date: Date())
    var bookingDatas: [BookingData] = []
    
    
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
        calendarTableView.reloadData()
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
        return 14
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CalendarTableViewCell.self), for: indexPath) as? CalendarTableViewCell else {return UITableViewCell()}
        
        let hour = indexPath.row + 10
        cell.bookingButton.addTarget(self, action: #selector(addBooking(sender:)), for: .touchUpInside)
        for data in bookingDatas {
            
            if data.year == selectDay.year && data.month == selectDay.month && data.day == selectDay.day && data.hour == hour {
                
                cell.bookingView.backgroundColor = .green
                return cell
            }
        }
        cell.setupCell(hour: hour)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}


extension CalendarViewController {

    @objc func addBooking(sender: UIButton) {
        
        let bookingData = BookingData(year: selectDay.year, month: selectDay.month, day: selectDay.day, hour: sender.tag)
        var conut = 0
        guard let cell = calendarTableView.cellForRow(at: IndexPath(row: sender.tag - 10, section: 0)) as? CalendarTableViewCell else {return}
        for data in bookingDatas {
            
            if data == bookingData  {
                bookingDatas.remove(at: conut)
                cell.resetCell()
                return
            }
            conut += 1
        }
        self.bookingDatas.append(bookingData)
        cell.bookingView.backgroundColor = .green
    }
}