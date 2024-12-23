//
//  Temperature_widgetLiveActivity.swift
//  Temperature_widget
//
//  Created by seongjun cho on 11/16/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct Temperature_widgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct Temperature_widgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: Temperature_widgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension Temperature_widgetAttributes {
    fileprivate static var preview: Temperature_widgetAttributes {
        Temperature_widgetAttributes(name: "World")
    }
}

extension Temperature_widgetAttributes.ContentState {
    fileprivate static var smiley: Temperature_widgetAttributes.ContentState {
        Temperature_widgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: Temperature_widgetAttributes.ContentState {
         Temperature_widgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: Temperature_widgetAttributes.preview) {
   Temperature_widgetLiveActivity()
} contentStates: {
    Temperature_widgetAttributes.ContentState.smiley
    Temperature_widgetAttributes.ContentState.starEyes
}
