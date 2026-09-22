// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: glovebox_copilot_dash.scad (Motorized Dual-Screen Cockpit Layout)
// Core Objective: Fits standard 1969 dash cluster while extending a co-pilot display
// Center Origin (0,0,0) = Firewall Center point along Steering Axis
// ====================================================================================

$fn = 120; // High-precision CNC milling resolution for dash mounting tabs

// --- Parametric Geometric Boundaries (mm) ---
inch_to_mm         = 25.4;
standard_dash_w    = 54.0 * inch_to_mm; // 1371.6 mm interior cabin cross-width
driver_display_w   = 312.42;            // 12.3" widescreen driver dash monitor (fits standard bezel)
copilot_display_w  = 254.00;            // 10.0" co-pilot display box

// Motorized Drawer Track Slide Offset (0 = Hidden inside glovebox, 220 = Fully Deployed)
GLOVEBOX_DEPLOY_MM = 220.00; 

module driver_dash_cluster() {
    // Primary driver instrumentation shell (Displays Google Maps navigation layers)
    color("DimGrey") {
        translate([-standard_dash_w/3 - driver_display_w/2, 45, 20]) {
            difference() {
                // Main screen enclosure bezel frame
                cube([driver_display_w, 25, 140]);
                // Core viewport display window pane cutout
                translate([10, -1, 10])
                    cube([driver_display_w - 20, 28, 120]);
            }
        }
    }
}

module motorized_glovebox_copilot() {
    // Secondary navigation, engineering tracking, and data routing workstation
    translate([standard_dash_w/4, 45 - GLOVEBOX_DEPLOY_MM, -30]) {
        // Linear roller tracks sliding out from the dashboard framework housing
        color("Silver") {
            translate([-10, -45, 10]) cube([15, GLOVEBOX_DEPLOY_MM + 50, 15]);
            translate([copilot_display_w - 5, -45, 10]) cube([15, GLOVEBOX_DEPLOY_MM + 50, 15]);
        }
        
        // Co-Pilot Multi-Mux Display Shell Assembly
        color("DarkCharcoal") {
            difference() {
                // Main monitor structural housing cube
                cube([copilot_display_w, 35, 180]);
                // Display window screen cutout face
                translate([8, -1, 8])
                    cube([copilot_display_w - 16, 38, 164]);
            }
        }
        
        // OtterBox protective structural overmold back-plate bumper trim
        color("Black")
            translate([-4, 32, -4])
                cube([copilot_display_w + 8, 8, 188]);
    }
}

// --- Composite Display Matrix Instantiation ---
union() {
    driver_dash_cluster();
    motorized_glovebox_copilot();
}
