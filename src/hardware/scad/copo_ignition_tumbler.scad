// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_ignition_tumbler.scad (Authentic 1969 Key Shroud with Sniffer Cavity)
// Core Application: Biometric Eye-Authentication & Alcohol Interlock Infrastructure
// Center Origin (0,0,0) = Geometric Centerpoint of the Key Entry Slot Face
// ====================================================================================

$fn = 120; // High-fidelity CNC laser-profiling and die-cast tooling path resolution

// --- 1969 Historical Geometric Constants (mm) ---
inch_to_mm         = 25.4;
bezel_outer_dia    = 1.375 * inch_to_mm; // 34.925 mm authentic chrome ignition face
tumbler_depth      = 55.00;              // Mechanical barrel length under steering cowl
keyway_slot_w      = 12.00;              // Fits original 1969 double-cut metal keys
keyway_slot_h      = 3.20;

// Solid-State Sensor Chamber Dimensions
sniffer_chamber_w  = 22.00;              // Cavity for semiconductor ethanol sniffer

module historical_chrome_ignition_face() {
    echo("COMPILING 1969 FACTORY BLUEPRINT IGNITION TUMBLER AND BIO INTERLOCKS");
    color("Chrome") { // Polished mirror accent ring profile
        difference() {
            // Front decorative face rim flange
            cylinder(d=bezel_outer_dia, h=4.0, center=true);
            // Center keyed entry pass-through slot
            cube([keyway_slot_w, keyway_slot_h, 6.0], center=true);
        }
    }
}

module mechanical_tumbler_barrel() {
    // Rigid rear cylinder container hosting the spring-rebound starter relays
    color("DimGrey") {
        translate([0, 0, -tumbler_depth/2 - 2]) {
            difference() {
                cylinder(d=bezel_outer_dia - 6, h=tumbler_depth, center=true);
                // Internal key path slide cylinder channel
                cylinder(d=keyway_slot_w + 2, h=tumbler_depth + 2, center=true);
            }
        }
    }
}

module ethanol_sniffer_cavity() {
    // Hidden auxiliary gas collection pocket machined directly under the bezel collar.
    // Draws cabin air across the driver's breath path to intercept trace organic vapors.
    color("DarkSlateGrey") {
        translate([0, -bezel_outer_dia/2 - sniffer_chamber_w/2, -15]) {
            difference() {
                cube([sniffer_chamber_w + 8, sniffer_chamber_w + 8, 25], center=true);
                cube([sniffer_chamber_w, sniffer_chamber_w, 27], center=true); // Sensor element box
                
                // Active micro-vent filtration openings drawing cabin air vectors
                translate([0, -sniffer_chamber_w/2, 0])
                    rotate([90, 0, 0]) cylinder(d=4.0, h=10, center=true);
            }
        }
    }
}

// --- Composite Mechanical Ignition Construction ---
union() {
    historical_chrome_ignition_face();
    mechanical_tumbler_barrel();
    ethanol_sniffer_cavity();
}
