//
//  ChoseTrackViewInfo.swift
//  Career-Pilot-iOS
//
//  Created by Mohamed Magdy on 16/07/2026.
//

import Foundation

struct SelectedTrackViewInfo{
    var filteredTracks: [Track] = tracks
    var selectedTrack: Track?
}

let tracks = [
    Track(title: "Software Engineering"),
    Track(title: "Data Science"),
    Track(title: "Product Management"),
    Track(title: "UX Design"),
    Track(title: "Marketing"),
    Track(title: "Finance & Banking"),
    Track(title: "Consulting"),
    Track(title: "Business Analysis"),
    Track(title: "DevOps & SRE"),
    Track(title: "Machine Learning"),
    Track(title: "Cybersecurity"),
    Track(title: "Sales"),
    Track(title: "HR & Talent"),
    Track(title: "Customer Success")
]
