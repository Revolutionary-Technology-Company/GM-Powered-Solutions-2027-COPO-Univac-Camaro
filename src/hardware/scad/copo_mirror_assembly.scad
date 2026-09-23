// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_mirror_assembly.scad (Authentic 1969 Mirror Protection Shells)
// Core Objective: Structural casing for 1969 exterior chrome and interior rearview mirrors
// Center Origin (0,0,0) = Geometric Centerpoint of the Rearview Mirror Mounting Foot
// ====================================================================================

$fn = 100; // High-fidelity die-cast and CNC finish path resolution

// --- 1969 Factory Mirror Dimensions (mm) ---
inch_to_mm         = 25.4;
exterior_mirror_w  = 5.5 * inch_to_mm;    // 139.7 mm classic rectangular side mirror
exterior_mirror_h  = 3.25 * inch_to_mm;   // 82.55 mm height profile
interior_mirror_w  = 8.0 * inch_to_mm;    // 203.2 mm day/night rearview mirror
shell_thickness    = 2.50;                // Thick chrome-plated zinc casing wall

// Roll Cage Tube Diameter Reference (From copo_cage_variants.scad)
cage_tube_dia      = 41.28;               // Standard 1-5/8" safety tube size

module authentic_exterior_mirror() {
    echo("COMPILING 1969 CLASSIC PROFILE EXTERIOR SIDE MIRRORS");
    color("Chrome") { // High-polish mirror finish presentation
        difference() {
            // Main rectangular outer chrome shell casing
            cube([exterior_mirror_w, 20, exterior_mirror_h], center=true);
            
            // Internal pocket recess to house the wide-angle convex optical lens
            translate([0, shell_thickness, 0])
                cube([exterior_mirror_w - 6, 20, exterior_mirror_h - 6], center=true);
        }
        
        // Multi-axis manual swivel adjustment ball joint stem mount
        translate([0, -15, -exterior_mirror_h/2])
            cylinder(d=12.0, h=25, center=true);
    }
}

module interior_cage_rearview_mirror() {
    echo("COMPILING CHROMATIC AUTO-DIMMING REARVIEW COCKPIT MIRROR");
    // Designed to clamp directly onto the front upper windshield loop of the roll cage
    translate([0, 200, 150]) {
        color("DarkCharcoal") {
            difference() {
                // Outer rear protective frame bezel housing
                cube([interior_mirror_w, 18, 50], center=true);
                // Viewport glass pane recess window
                translate([0, -2, 0])
                    cube([interior_mirror_w - 8, 18, 42], center=true);
            }
        }
        
        // INTEGRATED ROLL CAGE MOUNT CLAMP
        color("Silver") {
            translate([0, 15, 35])
                difference() {
                    // Solid aluminum clamp block
                    cube([30, 60, 30], center=true);
                    // Internal borehole matching the 1-5/8" cage halo bar
                    rotate([0, 90, 0])
                        cylinder(d=cage_tube_dia, h=32, center=true);
                }
        }
    }
}

// --- Composite Structural System Instantiation ---
union() {
    authentic_exterior_mirror();
    interior_cage_rearview_mirror();
}
