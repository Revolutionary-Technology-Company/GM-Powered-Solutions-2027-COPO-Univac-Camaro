// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_hvac_dashboard.scad (Authentic 1969 Climate Faceplate Base)
// Core Objective: Fits OtterBox dash console while translating mechanical slider paths
// Center Origin (0,0,0) = Geometric Centerpoint of the 1969 Chrome Faceplate Rim
// ====================================================================================

$fn = 100; // CNC laser-cutting and plastic injection finish parameter

// --- 1969 Factory Faceplate Dimensions (mm) ---
inch_to_mm         = 25.4;
faceplate_width    = 120.00; // Fits the exact pocket inside otterbox_master_interior.scad
faceplate_height   = 35.00;
bezel_lip_depth    = 4.00;
slider_slot_length = 65.00;
slider_slot_height = 3.50;

module historical_chrome_bezel() {
    echo("COMPILING 1969 ENVIRONMENTAL CONTROL SURFACE COMPONENT");
    color("Silver") { // Polished chrome exterior frame accent
        difference() {
            // Main rectangular faceplate bezel block
            cube([faceplate_width, faceplate_height, bezel_lip_depth], center=true);
            // Hollow center core step-down for internal text insert plate
            cube([faceplate_width - 6, faceplate_height - 6, bezel_lip_depth + 2], center=true);
        }
    }
}

module lever_slot_tracks() {
    // Generates the three horizontal slot tracks used by the 1969 mechanical handles
    color("Black") {
        translate([0, 0, -bezel_lip_depth/2]) {
            difference() {
                // Internal black backing plate insert
                cube([faceplate_width - 8, faceplate_height - 8, 2], center=true);
                
                // Track 1: Upper Slider Track (FAN Speed selection axis)
                translate([0, 8, 0])
                    cube([slider_slot_length, slider_slot_height, 5], center=true);
                
                // Track 2: Middle Slider Track (OFF / HEAT / DE-ICE mechanical selection route)
                translate([0, 0, 0])
                    cube([slider_slot_length, slider_slot_height, 5], center=true);
                
                // Track 3: Lower Slider Track (PARAMETRIC COPO TEMPERATURE SELECTION WAVE)
                translate([0, -8, 0])
                    cube([slider_slot_length, slider_slot_height, 5], center=true);
            }
        }
    }
}

module structural_rear_housing() {
    // Sealed housing protruding from the rear of the faceplate.
    // Protects the high-accuracy linear sliders from dirt, moisture, and dust.
    color("DimGrey") {
        translate([0, 0, -25])
            difference() {
                cube([faceplate_width - 12, faceplate_height - 12, 40], center=true);
                cube([faceplate_width - 20, faceplate_height - 20, 42], center=true); // Sensor bay cavity
            }
    }
}

// --- Composite Climate Interface Instantiation ---
union() {
    historical_chrome_bezel();
    lever_slot_tracks();
    structural_rear_housing();
}
