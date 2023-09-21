//
//  CallKitNotificationNotUpdatingApp.swift
//  CallKitNotificationNotUpdating
//
//  Created by Adi on 9/15/23.
//

import SwiftUI
import PushKit
import CallKit


@main
struct CallKitPlaygroundApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State var text: String = "Waiting 3 seconds"
    
    var body: some Scene {
        WindowGroup {
            ContentView(text: $text)
                .onAppear(){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                        let uuid = UUID()
                        appDelegate.triggerCallKitNewIncoming(text: $text, id: uuid, phoneNumber: "Calling", value: "Calling")

                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                            appDelegate.triggerCallKitUpdate(text: $text, id: uuid, phoneNumber: "123123123", value: "Johnny Doe")
                        })
                    })
                }
        }
        
    }
}


class AppDelegate: NSObject, UIApplicationDelegate, CXProviderDelegate {
    
    
    var provider: CXProvider!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        let providerConfiguration = CXProviderConfiguration.init()
        
//            providerConfiguration.localizedName = Bundle.main.infoDictionary!["CFBundleName"] as! String
        providerConfiguration.ringtoneSound = nil
        providerConfiguration.supportsVideo = false
        providerConfiguration.supportedHandleTypes = [.generic, .phoneNumber] //, .emailAddress]
        
        providerConfiguration.maximumCallsPerCallGroup = 10
        providerConfiguration.maximumCallGroups = 10
        
        providerConfiguration.includesCallsInRecents = true
        
        provider = CXProvider(configuration: providerConfiguration)
        provider.setDelegate(self, queue: nil)

        return true
    }
    
    func triggerCallKitNewIncoming(text: Binding<String>, id: UUID, phoneNumber: String, value: String) {
        print("triggering new call")
        text.wrappedValue = "Triggering new call from \(value)"

        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .phoneNumber, value: phoneNumber)
        update.hasVideo = false
        update.localizedCallerName = value

        provider.reportNewIncomingCall(with: id, update: update) { maybeError in
            print("reported new incoming call with error \(String(describing: maybeError))")
        }
    }
    
    func triggerCallKitUpdate(text: Binding<String>, id: UUID, phoneNumber: String, value: String) {
        print("triggering update")
        text.wrappedValue = "Triggering update from \(value)"

        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .phoneNumber, value: phoneNumber)
        update.hasVideo = false
        update.localizedCallerName = value

        provider.reportCall(with: id, updated: update)
    }
    
    func providerDidReset(_ provider: CXProvider) {
        print("provider did reset")
    }
    
}
