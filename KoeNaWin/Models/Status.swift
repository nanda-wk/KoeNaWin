//
//  Status.swift
//  KoeNaWin
//
//  Created by Nanda WK on 2025-04-02.
//

enum Status: String, Identifiable {
    var id: String { rawValue }
    case fail
    case complete

    var desc: String {
        switch self {
        case .fail:
            "Fail"
        case .complete:
            "Complete"
        }
    }
}
