//
//  AlarmSheet.swift
//  Escape
//
//  Created by Jerry Kress on 03/11/2020.
//

import SwiftUI

struct AlarmSheet: View {
    // Volatile storage for alarm in scene
    @State private var alarm = Date()
    @State private var status = false
    // Persistent storage for alarm
    @AppStorage("alarmHour") private var alarmHour: Int = 12;
    @AppStorage("alarmMin") private var alarmMin: Int = 0;
    
    @Environment (\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Toggle(isOn: self.$status) {
                                Text("Turn on alarm")
                            }.padding()
                DatePicker(selection: self.$alarm, displayedComponents: .hourAndMinute) {
                                Text("Select a date")
                            }
                            .datePickerStyle(WheelDatePickerStyle())
                            .onAppear(perform: {
                                // On appear, read the saved data from persist store
                                var comp = DateComponents()
                                comp.hour = alarmHour
                                comp.minute = alarmMin
                                self.alarm = Calendar.current.date(from: comp) ?? Date()
                            })
                
                Button(action: {
                    // Get alarm hour and minute from temp var
                    let hour = Calendar.current.component(.hour, from: self.alarm)
                    let minute = Calendar.current.component(.minute, from: self.alarm)
                    // Save the above to persistent var
                    self.alarmHour = hour
                    self.alarmMin = minute
                    print("Save the alarm!")
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save Settings")
                }
            }
            .navigationTitle("Wake Up Alarm")
        }
    }
}

struct AlarmSheet_Previews: PreviewProvider {
    static var previews: some View {
        AlarmSheet()
    }
}
