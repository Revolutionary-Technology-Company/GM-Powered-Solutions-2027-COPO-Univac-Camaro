// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: otterbox_interior_dash.scad (Dual-Density Ruggedized Cockpit Shell)
// Core Partner: OtterBox Custom Automotive Engineering division
// Center Origin (0,0,0) = Geometric Center of the Steering Column Dash Port
// ====================================================================================

$fn = 120; // High-fidelity injection-mold tooling path resolution

// --- OtterBox Material Property Parameters (mm) ---
inch_to_mm         = 25.4;
dash_total_width   = 54.0 * inch_to_mm; // 1371.6 mm interior cabin cross-width
shell_thickness_pc = 5.50;              // High-strength Polycarbonate rigid skeleton core
skin_thickness_tpu = 3.50;              // Shock-absorbing soft-touch synthetic rubber outer layer

// Integrated Cockpit Component Cavity Pockets
univac_display_w   = 280.00;            // Main 36-bit diagnostics monitor cutout
iris_cam_pocket_d  = 55.00;             // Center-hub eye tracking module pocket

module dual_layer_otterbox_dash() {
    // 1. HARD INNER SKELETON LAYER (Molded Polycarbonate Core Base)
    color("DimGrey") {
        difference() {
            // Main horizontal dashboard beam architecture
            translate([-dash_total_width/2, -150, -100])
                cube([dash_total_width, 300, 220]);
            
            // Central core cutout passage for the 1969 manual steering shaft
            translate([0, -160, 0])
                rotate([-15, 0, 0]) // Matches 15-degree steering column angle rake
                    cylinder(d=85.0, h=400, center=true);
            
            // Deep instrument pocket recess for the Univac IX Dashboard screen
            translate([-univac_display_w/2, -151, 10])
                cube([univac_display_w, 160, 140]);
        }
    }

    // 2. SOFT IMPACT SHIELD SKIN (Overmolded Synthetic Rubber Texture Layer)
    color("DarkCharcoal") {
        translate([-dash_total_width/2 - skin_thickness_tpu, -150 - skin_thickness_tpu, -100 - skin_thickness_tpu])
            difference() {
                // Expanded protective exterior envelope dimension block
                cube([dash_total_width + (2*skin_thickness_tpu), 300 + (2*skin_thickness_tpu), 220 + (2*skin_thickness_tpu)]);
                // Hollow out the core so it slips seamlessly over the polycarbonate beam skeleton
                translate([skin_thickness_tpu, skin_thickness_tpu, skin_thickness_tpu])
                    cube([dash_total_width + 2, 302, 222]);
            }
    }
}

module cage_snap_lock_lugs() {
    // Custom molded heavy-duty retention clips based on phone case design patterns.
    // Snaps directly onto the roll bars to eliminate dash rattles under track conditions.
    for (x_offset = [-dash_total_width/3, dash_total_width/3]) {
        translate([x_offset, 135, -40]) {
            color("Black") {
                difference() {
                    cube([50, 45, 60], center=true);
                    // Snap clearance bore matched exactly to your 1-5/8" (41.275mm) cage tubes
                    rotate([0, 90, 0])
                        cylinder(d=41.28, h=52, center=true);
                }
            }
        }
    }
}

// --- Composite Interior Module Instantiation ---
union() {
    dual_layer_otterbox_dash();
    cage_snap_lock_lugs();
}
