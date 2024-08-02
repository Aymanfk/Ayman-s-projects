//
//  sampleRoutes.swift
//  ThruHiker
//
//  Created by Kai Linsley on 4/20/24.
//

import SwiftUI

struct Route: Identifiable {
    let id = UUID()
    let name: String
    var distance: Double
    let time: String
    let mapURL: String
    let mileMarkerFile: String
    var summary: String

    var started: Bool {
        get {
            UserDefaults.standard.bool(forKey: "\(name)Started")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "\(name)Started")
        }
    }

    var completed: Bool {
        get {
            UserDefaults.standard.bool(forKey: "\(name)Completed")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "\(name)Completed")
        }
    }
}



// Example data
let routes = [
    Route(name: "Pacific Crest Trail", distance: 2662, time: "8+ months", mapURL: "mapbox://styles/gavinlebo/cluz1mqk2005n01q17kxdbgcl", mileMarkerFile: "PCT_mile_markers", summary: "The Pacific Crest Trail (PCT) spans 2,650 miles from Mexico to Canada through California, Oregon, and Washington. It traverses diverse landscapes, including deserts, the Sierra Nevada, and the Cascade Range, offering stunning views of mountains, forests, and lakes. Established in 1968 and completed in 1993, the PCT is a designated National Scenic Trail, attracting hikers and equestrians seeking adventure and natural beauty. Its history is rooted in the efforts of the Pacific Crest Trail Conference, which promoted its creation and maintenance."),
    Route(name: "Appalachian Trail", distance: 1993, time: "5-7 months", mapURL: "mapbox://styles/gavinlebo/clwaa9gm300av01po7bw66gfx", mileMarkerFile: "AT_mile_markers", summary: "The Appalachian Trail (AT) stretches about 2,200 miles from Georgia to Maine, passing through 14 states along the Appalachian Mountains. It features diverse scenery, including dense forests, rolling hills, and rugged peaks, with iconic spots like the Great Smoky Mountains and Shenandoah National Park. Conceived in 1921 by Benton MacKaye and completed in 1937, the AT is maintained by volunteers and managed by the National Park Service, the Appalachian Trail Conservancy, and the U.S. Forest Service. It is a beloved route for long-distance hikers and nature enthusiasts."),
    Route(name: "John Muir Trail", distance: 220, time: "1 month", mapURL: "mapbox://styles/gavinlebo/clwacmf9i00b701po46ehhnse", mileMarkerFile: "JMT_mile_markers", summary: "The John Muir Trail (JMT) is a 220-mile trail in California, running from Yosemite Valley to Mount Whitney. It traverses the Sierra Nevada, passing through breathtaking landscapes such as Yosemite, Kings Canyon, and Sequoia National Parks. Known for its high elevation and stunning scenery, the trail features granite peaks, alpine meadows, and pristine lakes. Named after naturalist John Muir, it was completed in 1938. The JMT is a popular route for hikers seeking a challenging and scenic adventure in the heart of the Sierra Nevada."),
    Route(name: "Everest Base Camp", distance: 64.2, time: "1 week", mapURL: "mapbox://styles/gavinlebo/clwcfjfrx00dx01rd8q484sly", mileMarkerFile: "Everest_mile_markers", summary: "Mount everest base camp trek."),
    Route(name: "Continental Divide Trail", distance: 3005.2, time: "1 Year", mapURL: "mapbox://styles/gavinlebo/clwcgipwj00d001q19us6hg53", mileMarkerFile: "Continental_mile_markers", summary: "Continental Divide Trail."),
    Route(name: "Tour du Mont Blanc", distance: 102, time: "2 weeks", mapURL: "mapbox://styles/gavinlebo/clwchaijr00d101q12gggg6mv", mileMarkerFile: "JMB_mile_markers", summary: "Continental Divide Trail.")
]
