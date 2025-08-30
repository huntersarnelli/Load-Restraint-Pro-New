//
//  chain.swift
//  Load Restraint Pro
//
//  Created by Hunter Sarnelli on 8/25/25.
//

import Foundation

struct Chain: Identifiable {
    let id = UUID()  // Changed to let (constant)
    var name: String = "Chain 1"
    var strength: Double = 10000  // Keep non-optional with default
    var totalLength: Double? = nil
    var longitudinal: Double? = nil
    var _vertical: Double? = nil
    var _lateral: Double? = nil
    var direction: String = "Forward"  // "Forward" or "Aft"
    
    // Computed vertical (use input or calculate if missing)
    var vertical: Double {
        if let v = _vertical, v > 0 { return v }
        if canComputeMissing {
            let tl = totalLength ?? 0
            let lon = longitudinal ?? 0
            let lat = _lateral ?? 0
            let computed = sqrt(tl * tl - lon * lon - lat * lat)
            return computed.isFinite && computed > 0 ? computed : 0
        }
        return 0
    }
    
    // Computed lateral (use input or calculate if missing)
    var lateral: Double {
        if let l = _lateral, l > 0 { return l }
        if canComputeMissing {
            let tl = totalLength ?? 0
            let lon = longitudinal ?? 0
            let ver = _vertical ?? 0
            let computed = sqrt(tl * tl - lon * lon - ver * ver)
            return computed.isFinite && computed > 0 ? computed : 0
        }
        return 0
    }
    
    // Helper: Can we compute a missing component?
    private var canComputeMissing: Bool {
        let tl = totalLength ?? 0
        let lon = longitudinal ?? 0
        let ver = _vertical ?? 0
        let lat = _lateral ?? 0
        return tl > 0 && lon >= 0 &&
               ((ver > 0 && lat == 0) || (ver == 0 && lat > 0)) &&
               (tl * tl > lon * lon + (ver > 0 ? ver * ver : lat * lat))
    }
    
    // Validation warning if both components provided but inconsistent
    var warning: String {
        let tl = totalLength ?? 0
        let lon = longitudinal ?? 0
        let ver = _vertical ?? 0
        let lat = _lateral ?? 0
        if ver > 0 && lat > 0 && tl > 0 {
            let expectedL = sqrt(lon * lon + ver * ver + lat * lat)
            if abs(expectedL - tl) > 0.01 {  // Small tolerance for measurement error
                return "Warning: Measurements inconsistent. Expected total length ≈ \(String(format: "%.2f", expectedL)) based on components."
            }
        }
        if tl > 0 && lon > tl {
            return "Warning: Longitudinal cannot exceed total length."
        }
        return ""
    }
    
    // Computed restraints
    var fwdRestraint: Double {
        let tl = totalLength ?? 0
        if tl > 0 && direction == "Forward" {
            return ((longitudinal ?? 0) / tl) * strength
        }
        return 0
    }
    var aftRestraint: Double {
        let tl = totalLength ?? 0
        if tl > 0 && direction == "Aft" {
            return ((longitudinal ?? 0) / tl) * strength
        }
        return 0
    }
    var vertRestraint: Double {
        let tl = totalLength ?? 0
        return tl > 0 ? (vertical / tl) * strength : 0
    }
    var latRestraint: Double {
        let tl = totalLength ?? 0
        return tl > 0 ? (lateral / tl) * strength : 0
    }
}
