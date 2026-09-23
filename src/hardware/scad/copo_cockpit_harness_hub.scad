// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_cockpit_harness_hub.scad (Cockpit Low-Voltage Wiring Junction Panel)
// Core Objective: Pairs the 12V Avionics Loom Routing Nodes with Active Blower Ports
// Center Origin (0,0,0) = Geometric Centerpoint of the Avionics Terminal Plate Face
// ====================================================================================

$fn = 120; // High-precision CNC milling and waterjet routing resolution

// --- Structural Configuration Constants (mm) ---
inch_to_mm         = 25.4;
junction_box_w     = 220.00;           // Fits behind the OtterBox glovebox cavity
junction_box_l     = 160.00;           // Total panel face plate horizontal dimension
plate_thickness    = 5.00;             // Billet 6061-T6 aluminum protection plate
blower_mount_dia   = 76.00;            // Sized to clear the low-noise 80mm blower throat

module master_harness_faceplate() {
    echo("COMPILING COCKPIT ELECTRICAL HARNESS INTEGRATION SYSTEM JUNCTION FLANGE");
    color("DimGrey") {
        difference() {
            // Main vertical avionics bulkhead mount plate
            cube([junction_box_w, junction_box_l, plate_thickness], center=true);
            
            // 1. PRIMARY LOW-VOLTAGE CONDUCT CONDUIT PORTAL
            translate([-55, 0, 0])
                cylinder(d=50.0, h=plate_thickness + 4, center=true); // Clears the 40mm nylon wire loom
                
            // 2. CONCENTRIC THERMAL FAN INTAKE CLEARANCE PORTALS
            for (y_offset = [-40, 40]) {
                translate([60, y_offset, 0])
                    cylinder(d=blower_mount_dia, h=plate_thickness + 4, center=true);
            }
            
            // ACDelco Environmental Gasket Channeling Groove
            // 2.5mm deep perimeter routing track for liquid natural tree rubber sealing
            difference() {
                cube([junction_box_w - 6, junction_box_l - 6, plate_thickness + 2], center=true);
                cube([junction_box_w - 12, junction_box_l - 12, plate_thickness + 4], center=true);
            }
        }
    }
}

module connector_rail_brackets() {
    // Heavy-duty structural standoff mounting ears designed to lock the KiCad backplanes
    color("Silver") {
        for (side = [-1, 1]) {
            translate([side * (junction_box_w/2 - 15), 0, plate_thickness/2 + 6])
                difference() {
                    cube([12, 100, 12], center=true);
                    // Threaded drilling passages for standard M5 avionics structural mounts
                    for (y = [-35, 35]) {
                        translate([0, y, 0])
                            rotate([0, 90, 0])
                                cylinder(d=5.2, h=16, center=true);
                    }
                }
        }
    }
}

// --- Composite Mechanical Harness Flange Instantiation ---
union() {
    master_harness_faceplate();
    connector_rail_brackets();
}
