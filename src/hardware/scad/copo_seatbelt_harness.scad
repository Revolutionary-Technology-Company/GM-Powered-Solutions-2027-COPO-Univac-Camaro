// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_seatbelt_harness.scad (Dual-Spec Restraint Mounting Topology)
// Core Objective: Establishes high-tensile anchor geometry for NHRA 5-Point Harness
// Center Origin (0,0,0) = Mid-point of the Driver Seat Floor Frame Base Anchor
// ====================================================================================

$fn = 120; // High-fidelity CNC laser-cut tab profiling resolution

// --- Restraint Mechanical Constants (mm) ---
inch_to_mm         = 25.4;
belt_webbing_width = 3.0 * inch_to_mm;  // Heavy-duty 76.2mm SFI-approved spec nylon
anchor_bolt_dia    = 13.00;             // Through-hole clearance for 1/2" grade 8 safety bolts
mount_tab_thick    = 6.35;              // 1/4-inch structural steel/titanium anchoring ears

// Structural Roll Cage Tying Constants (Inherited from copo_cage_variants.scad)
harness_bar_height = 670.56;            // Elevation height of shoulder bar behind the driver
cabin_width        = 56.0 * inch_to_mm;

module floor_lap_anchor_tabs() {
    // Left and Right low-slung bracket ears anchoring both the 1969 lap belt and 5-point lap harness
    color("DimGrey") {
        for (side = [-1, 1]) {
            translate([side * 240, 0, -20]) {
                difference() {
                    // Stamped high-tensile mounting plate ear
                    cube([mount_tab_thick, 50, 45], center=true);
                    // Reamed eyelet borehole for safety-wire lock-pin fasteners
                    rotate([0, 90, 0])
                        cylinder(d=anchor_bolt_dia, h=mount_tab_thick + 2, center=true);
                }
            }
        }
    }
}

module cage_shoulder_harness_wraps() {
    // Shoulder strap locator collars mounted on the roll cage crossmember.
    // Holds the dual over-the-shoulder straps at the optimal 10-degree down-angle.
    color("DarkRed") {
        for (offset = [-75, 75]) { // Center-aligned to perfectly track the driver's shoulders
            translate([offset, -200, harness_bar_height]) {
                rotate([0, 90, 0]) {
                    difference() {
                        // Outer containment collar ring
                        cylinder(d=55.0, h=40.0, center=true);
                        // Internal bore diameter perfectly tracking the 1-5/8" cage tubing
                        cylinder(d=41.28, h=42.0, center=true);
                    }
                }
                // Extended guide loop tracking the 3-inch webbing feed line
                translate([0, -25, 0])
                    cube([40, 10, 10], center=true);
            }
        }
    }
}

module sub_strap_floor_portal() {
    // Core anti-submarine strap center anchor cutout.
    // Positions the fifth safety buckle pass-through vertically under the groin centerline.
    color("Silver") {
        translate([0, 150, -20]) {
            difference() {
                cube([85, 50, mount_tab_thick], center=true);
                // Clean radius slot tracking the thick structural webbing anchor links
                cube([78, 12, mount_tab_thick + 2], center=true);
            }
        }
    }
}

// --- Composite Restraint System Instantiation ---
union() {
    floor_lap_anchor_tabs();
    cage_shoulder_harness_wraps();
    sub_strap_floor_portal();
}
