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
    var bookingTimeDatas: [BookingTime] = [] {
        didSet {
         
            self.bookingTimeDatas.sort(by: <)
            calendarTableView.reloadData()
        }
    }
    
    var firebaseBookingData: [BookingTime] = [] {
        didSet {
         
            calendarTableView.reloadData()
            print("firebaseBookingData in set")
        }
    }

    @IBOutlet weak var calendarTableView: JKCalendarTableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        calendarTableView.calendar.delegate = self
        calendarTableView.calendar.dataSource = self

        calendarTableView.calendar.focusWeek = selectDay.weekOfMonth - 1
        
        FirebaseSingle.shared.dataBase().collection("Booking").getDocuments {[weak self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                return
            }
            if let error = error {                print("Error getting documents: \(error)")
            } else {
                for document in documents {
                    
                    guard let bookingTime = BookingTime(dictionary: document.data()) else {return}
                    self?.firebaseBookingData.append(bookingTime)
                }
            }
        }
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
        
        nextVC.bookingTimeDatas = self.bookingTimeDatas
        nextVC.bookingDatasChange = { [weak self] changeDatas in
            self?.bookingTimeDatas = changeDatas
        }
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
        for firebasedata in firebaseBookingData {
            
            if firebasedata.date.year == selectDay.year &&
                firebasedata.date.month == selectDay.month &&
                firebasedata.date.day == selectDay.day {
                
                    for hours in firebasedata.hour {
                        
                        if hours == hour {
                            
                            cell.setupCell(hour: hour)
                            cell.bookingButton.isHidden = true
                            cell.bookingView.backgroundColor = .red
                            cell.bookingView.isHidden = false
                            return cell
                        }
                    }
                }
        }
        
        
        
        
        cell.bookingButton.addTarget(self, action: #selector(addBooking(sender:)), for: .touchUpInside)
        for data in bookingTimeDatas {

            if data.date.year == selectDay.year &&
                data.date.month == selectDay.month &&
                data.date.day == selectDay.day {
                for hours in data.hour {
                    
                    if hours == hour {
                        
                        cell.setupCell(hour: hour)
                        cell.bookingButton.setImage(UIImage.asset(.substract), for: .normal)
                        cell.bookingView.isHidden = false
                        return cell
                    }
                }
            }
        }
        cell.setupCell(hour: hour)
        cell.bookingButton.setImage(UIImage.asset(.add), for: .normal)
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
        for booking in bookingTimeDatas {

            if booking.date == bookingDate {

                for hour in booking.hour {

                    if hour == sender.tag {
                        
                        if bookingTimeDatas[count].hour.count == 1 {
                            
                            bookingTimeDatas.remove(at: count)
                            return
                        }
                        bookingTimeDatas[count].hour.remove(at: counthour)
                        
                        return
                    }
                    counthour += 1
                }
                bookingTimeDatas[count].hour.append(sender.tag)
                return
            }
            count += 1
        }
        bookingTimeDatas.append(BookingTime(date: bookingDate, hour: [sender.tag]))
    }
}
