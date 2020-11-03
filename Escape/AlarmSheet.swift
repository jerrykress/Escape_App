//
//  AlarmSheet.swift
//  Escape
//
//  Created by Jerry Kress on 03/11/2020.
//

import SwiftUI

struct AlarmSheet: View {
    @State private var alarm = Date()
    @State private var status = false
    
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
                
                Button(action: {
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
