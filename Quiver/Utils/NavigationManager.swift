//
//  NavigationManager.swift
//  Quiver
//
//  Created by Michael on 04/02/2026.
//

import Foundation
import Observation
import SwiftUI

@Observable
class NavigationManager {
    var selectedTab: NavigationTab = .dashboard

    var dashboardPath = NavigationPath()
    var walletPath = NavigationPath()
    var transactionsPath = NavigationPath()
    var settingsPath = NavigationPath()
    
    var shouldShowTabBar: Bool {
        switch selectedTab {
        case .dashboard: return dashboardPath.isEmpty
        case .wallet: return walletPath.isEmpty
        case .transactions: return transactionsPath.isEmpty
        case .settings: return settingsPath.isEmpty
        }
    }

    func popToRoot() {
        switch selectedTab {
        case .dashboard: dashboardPath.removeLast(dashboardPath.count)
        case .wallet: walletPath.removeLast(walletPath.count)
        case .transactions: transactionsPath.removeLast(transactionsPath.count)
        case .settings: settingsPath.removeLast(settingsPath.count)
        }
    }
}
