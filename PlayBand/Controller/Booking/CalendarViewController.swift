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
    var bookingDatas: [BookingData] = [] {
        
        didSet {
            
            self.bookingDatas = self.bookingDatas.sorted(by: <)
        }
    }

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
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let nextVC = segue.destination as? ConfirmViewController else {return}
        nextVC.loadViewIfNeeded()
        nextVC.bookingDatas = self.bookingDatas
    }

}

extension CalendarViewController: JKCalendarDelegate {

    func calendar(_ calendar: JKCalendar, didTouch day: JKDay) {
        selectDay = day
        calendar.focusWeek = day < calendar.month
            ? 0
            : day > calendar.month ? calendar.month.weeksCount - 1: day.weekOfMonth - 1
        calendar.reloadData()
        calendarTableView.reloadData()
    }

    func heightOfFooterView(in claendar: JKCalendar) -> CGFloat {
        return 10
    }

    func viewOfFooter(in calendar: JKCalendar) -> UIView? {
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
        if selectDay == month {
            marks.append(JKCalendarMark(type: .circle,
                                        day: selectDay,
                                        color: markColor))
        }
        if firstMarkDay == month {
            marks.append(JKCalendarMark(type: .underline,
                                        day: firstMarkDay,
                                        color: markColor))
        }
        if secondMarkDay == month {
            marks.append(JKCalendarMark(type: .hollowCircle,
                                        day: secondMarkDay,
                                        color: markColor))
        }
        return marks
    }

    func calendar(_ calendar: JKCalendar, continuousMarksWith month: JKMonth) -> [JKCalendarContinuousMark]? {
        let startDay: JKDay = JKDay(year: 2018, month: 1, day: 17)!
        let endDay: JKDay = JKDay(year: 2018, month: 1, day: 18)!

        return [JKCalendarContinuousMark(type: .dot,
                                         start: startDay,
                                         end: endDay,
                                         color: markColor)]
    }

}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: CalendarTableViewCell.self),
            for: indexPath) as? CalendarTableViewCell else {return UITableViewCell()}

        let hour = indexPath.row + 10
        cell.bookingButton.addTarget(self, action: #selector(addBooking(sender:)), for: .touchUpInside)
        for data in bookingDatas {

            if data.date.year == selectDay.year &&
                data.date.month == selectDay.month &&
                data.date.day == selectDay.day {
                for hours in data.hour {
                    
                    if hours == hour {
                        
                        cell.bookingView.backgroundColor = .green
                        return cell
                    }
                }
            }
        }
        cell.setupCell(hour: hour)
        return cell
    }

}

extension CalendarViewController {

    @objc func addBooking(sender: UIButton) {

        let bookingDate = BookingDate(
            year: selectDay.year,
            month: selectDay.month,
            day: selectDay.day)
        var count = 0
        var counthour = 0
        guard let cell = calendarTableView.cellForRow(
            at: IndexPath(row: sender.tag - 10, section: 0)
            ) as? CalendarTableViewCell else {return}

        for booking in bookingDatas {

            if booking.date == bookingDate {

                for hour in booking.hour {

                    if hour == sender.tag {

                        bookingDatas[count].hour.remove(at: counthour)
                        cell.resetCell()
                        return
                    }
                    counthour += 1
                }
                bookingDatas[count].hour.append(sender.tag)
                cell.bookingView.backgroundColor = .green
                return
            }
            count += 1
        }
        bookingDatas.append(BookingData(date: bookingDate, hour: [sender.tag]))
        cell.bookingView.backgroundColor = .green
    }
}
