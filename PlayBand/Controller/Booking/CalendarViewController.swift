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

    private enum ButtonText {
        
        case buttonIsEnabled(Int)
        case buttonIsNotEnabled
        
        func returnString() -> String {
            
            switch self {
            case .buttonIsEnabled(let count):
                
                return "現有預定\(count)小時"
            case .buttonIsNotEnabled:
                
                return "你還沒預訂喔"
            }
        }
    }
    
    @IBOutlet weak var button: UIButton! {
        
        didSet {
            
            button.setupButtonModelPlayBand()
            buttonLogic()
        }
    }
    var markColor = UIColor(red: 40/255, green: 178/255, blue: 253/255, alpha: 1)
    var selectDay: JKDay = JKDay(date: Date())
    var bookingTimeDatas: [BookingTime] = [] {
        didSet {
         
            self.bookingTimeDatas.sort(by: <)
            buttonLogic()
            calendarTableView.reloadData()
        }
    }
    
    private var firebaseBookingData: [BookingTime] = [] {
        
        didSet {
         
            calendarTableView.reloadData()
        }
    }

    @IBOutlet weak var calendarTableView: JKCalendarTableView!

    var storeData: StoreData?

    override func viewDidLoad() {
        super.viewDidLoad()

        calendarTableView.calendar.delegate = self
        calendarTableView.calendar.dataSource = self
        calendarTableView.calendar.focusWeek = selectDay.weekOfMonth - 1
        
        getFirebaseBookingData()
        calendarTableView.rowHeight = 60
        guard let greenColor = UIColor.playBandColorEnd else {return}
        markColor = greenColor
    }

    private func getFirebaseBookingData() {
        
        guard let data = storeData else { return }
        
        FirebaseManger.shared.getStoreBookingInfo(name: data.name) { [weak self] (result) in
            
            switch result {
                
            case .success(let data):
                self?.firebaseBookingData = data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let nextVC = segue.destination as? ConfirmViewController else {return}
        nextVC.loadViewIfNeeded()
        
        nextVC.bookingTimeDatas = self.bookingTimeDatas
        nextVC.storeData = self.storeData
        nextVC.bookingDatasChange = { [weak self] changeDatas in
            self?.bookingTimeDatas = changeDatas
        }
    }
    private func buttonLogic() {
        
        switch bookingTimeDatas.count {
        case 0:
            button.alpha = 0.7
            button.isEnabled = false
            button.setTitle(ButtonText.buttonIsNotEnabled.returnString(), for: .normal)
        default:
            button.alpha = 1
            button.isEnabled = true
            var hourCount = 0
            for hours in bookingTimeDatas {

                hourCount += hours.hour.count
            }
            button.setTitle(ButtonText.buttonIsEnabled(hourCount).returnString(), for: .normal)
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
        let time = BookingDate(year: selectDay.year, month: selectDay.month, day: selectDay.day)
        
        if firebaseBookingData.filter({$0.date == time}).filter({$0.hour.contains(hour)}).count != 0 {
            
            cell.fireBaseBookingSetup(hour: hour)
            return cell
        }
        cell.bookingButton.addTarget(self, action: #selector(addBooking(sender:)), for: .touchUpInside)
        
        if bookingTimeDatas.filter({$0.date == time}).filter({$0.hour.contains(hour)}).count != 0 {

            cell.userBookingSetup(hour: hour)
            return cell
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
        let hour = sender.tag
        
        if let sameDate = bookingTimeDatas.first(where: {$0.date == bookingDate}) {
            
            guard let index = bookingTimeDatas.index(of: sameDate) else {return}
            
            if sameDate.hour.contains(hour) {
                
                guard let indexHour = bookingTimeDatas[index].hour.index(of: hour) else {return}
                bookingTimeDatas[index].hour.remove(at: indexHour)
                
                if bookingTimeDatas[index].hour.count == 0 {
                    
                    bookingTimeDatas.remove(at: index)
                }
            } else {
                
                bookingTimeDatas[index].hour.append(hour)
            }
            
        } else {
            
            bookingTimeDatas.append(BookingTime(date: bookingDate, hour: [hour]))
        }
//        var count = 0
//        var counthour = 0
//        for booking in bookingTimeDatas {
//
//            if booking.date == bookingDate {
//
//                for hour in booking.hour {
//
//                    if hour == sender.tag {
//
//                        if bookingTimeDatas[count].hour.count == 1 {
//
//                            bookingTimeDatas.remove(at: count)
//                            return
//                        }
//                        bookingTimeDatas[count].hour.remove(at: counthour)
//
//                        return
//                    }
//                    counthour += 1
//                }
//                bookingTimeDatas[count].hour.append(sender.tag)
//                return
//            }
//            count += 1
//        }
//        bookingTimeDatas.append(BookingTime(date: bookingDate, hour: [sender.tag]))
    }
}
