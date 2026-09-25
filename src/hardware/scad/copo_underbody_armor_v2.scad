// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_underbody_armor.scad (COPO Underbelly Protection & Vapor Drainage)
// Core Application: Northrop Grumman Spec Drainage Scuppers / 1/4" Billet Shield
// Center Origin (0,0,0) = Firewall Centerpoint along Driveline Longitudinal Axis
// ====================================================================================

$fn = 120; // High-fidelity waterjet cutting path resolution for aircraft alloys

// --- COPO Camaro Geometric Shield Constants (mm) ---
inch_to_mm         = 25.4;
frame_inner_width  = 38.0 * inch_to_mm;  // 965.20 mm clear span clearance between rail walls
shield_total_len   = 72.0 * inch_to_mm;  // 1828.80 mm forward-to-rear longitudinal depth
skid_plate_thick   = 6.35;               // 1/4" Aircraft-Grade 6061-T6 Aluminum Plate
scupper_bore_dia   = 12.70;              // 0.50-inch drainage pass-through tunnel [INDEX]

module copo_aluminum_skid_plate() {
    echo("COMPILING COPO 1/4 INCH HOUSING PROTECTION DECK WITH AEROSPACE SCUPPERS");
    color("Silver") { // Fine-milled aluminum faceplate representation
        difference() {
            // Main solid low-profile underbelly protection plate panel
            cube([frame_inner_width, shield_total_len, skid_plate_thick], center=true);
            
            // NORTHROP GRUMMAN INTEGRATED GRAVITATIONAL CORES
            // Cuts a 5-degree sloped funnel into the absolute floor center points of the armor
            for (y_offset = [-shield_total_len/4, shield_total_len/4]) {
                translate([0, y_offset, 0])
                    rotate([0, 5, 0]) // 5-degree gravitational drainage slant parameter [INDEX]
                        cylinder(d1=scupper_bore_dia + 8, d2=scupper_bore_dia, h=skid_plate_thick + 2, center=true);
            }
            
            // Flush Counter-Sunk Fastener Drill Array (M8 Grade 12.9 hardware into frame lips)
            for (x = [-frame_inner_width/2 + 20, frame_inner_width/2 - 20]) {
                for (y = [-shield_total_len/2 + 50 : 250 : shield_total_len/2 - 50]) {
                    translate([x, y, 0])
                        cylinder(d=8.5, h=skid_plate_thick + 4, center=true);
                }
            }
        }
    }
}

module northrop_grumman_check_valve_nozzles() {
    // Models the low-profile spring-loaded ball check nozzles projecting beneath the pan floor
    color("DarkSlateGrey") {
        for (y_offset = [-shield_total_len/4, shield_total_len/4]) {
            translate([0, y_offset, -skid_plate_thick/2 - 10]) {
                difference() {
                    // Outer drainage neck sleeve extend barrel
                    cylinder(d=scupper_bore_dia + 6, h=20, center=true);
                    // Internal core vapor extraction path [INDEX]
                    cylinder(d=scupper_bore_dia, h=22, center=true);
                }
                // Internal fluid seat flange that locks shut against pressurized road splashback [INDEX]
                translate([0, 0, -3])
                    difference() {
                        cylinder(d=scupper_bore_dia - 1, h=3.0, center=true);
                        cylinder(d=scupper_bore_dia - 4, h=5.0, center=true);
                    }
            }
        }
    }
}

// --- Composite Underbody Armor Assembly Instantiation ---
union() {
    copo_aluminum_skid_plate();
    northrop_grumman_check_valve_nozzles();
}
