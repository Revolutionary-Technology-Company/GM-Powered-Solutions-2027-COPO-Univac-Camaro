// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_turbine_wheels.scad (CNC Billet Turbine Induction Wheel Set)
// Core Objective: Replicates 1969 5-Spoke theme with modern aerodynamic brake venting
// Center Origin (0,0,0) = Geometric Centerpoint of the 5-Lug Hub Flange Pad
// ====================================================================================

$fn = 150; // Ultra-high resolution CNC milling toolpath resolution

// --- Manufacturing Parameter Configuration Selectors ---
// 1 = Standard Track Polished Spec, 2 = Hardened Police Pursuit Run-Flat Spec
WHEEL_SPEC_PROFILE = 2; 

// --- Physical Dimensional Constants (mm) ---
inch_to_mm         = 25.4;
wheel_rim_diameter = 19.00 * inch_to_mm; // 482.6 mm outer barrel rim diameter
wheel_rim_width    = 12.00 * inch_to_mm; // 304.8 mm section depth for Pirelli track slicks
lug_circle_diameter= 120.65;             // Authentic GM 5x4.75 inch structural pattern
num_bladed_spokes  = 7;                  // 7-Blade optimized ventilation array
blade_angle_twist  = 12.5;               // Directional aero intake rake degree angle

module master_outer_barrel() {
    echo(str("MILLING FIVE-PIECE BILLET WHEEL BATCH: ", (WHEEL_SPEC_PROFILE == 2) ? "POLICE_RUNFLAT_PURSUIT_SPEC" : "POLISHED_TRACK_SLICK_SPEC"));
    color("Mirror") { // High polish reflective rendering layer
        difference() {
            // Main solid cylindrical wheel rim block
            cylinder(d=wheel_rim_diameter, h=wheel_rim_width, center=true);
            // Hollow drop-center cavity pocket for the pneumatic tire air volume
            cylinder(d=wheel_rim_diameter - 15, h=wheel_rim_width + 2, center=true);
        }
        
        // INTEGRATED POLICE RUN-FLAT DEFLECTION RING (Rule Compliance)
        if (WHEEL_SPEC_PROFILE == 2) {
            color("DarkSlateGrey")
                difference() {
                    // Solid internal core split-ring to catch the tire carcass during flat deflation
                    cylinder(d=wheel_rim_diameter - 40, h=wheel_rim_width - 50, center=true);
                    cylinder(d=wheel_rim_diameter - 80, h=wheel_rim_width - 48, center=true);
                }
        }
    }
}

module directional_induction_blades() {
    // Generates the twisted aerodynamic blades that pull air inside to flush the Brembos
    color("Mirror") {
        for (i = [0 : num_bladed_spokes - 1]) {
            rotate([0, 0, i * (360 / num_bladed_spokes)]) {
                // Shift blade matrix to outer radius edge boundary walls
                translate([wheel_rim_diameter/4, 0, 0])
                    // Twists the spoke to act as an induction turbine face fan
                    rotate([blade_angle_twist, 0, 0])
                        cube([wheel_rim_diameter/2 - 10, 45.0, 12.0], center=true);
            }
        }
    }
}

module authentic_gm_5lug_hub() {
    // 5-Lug mechanical mounting flange pattern
    color("Chrome") {
        difference() {
            cylinder(d=165.0, h=25.0, center=true);
            cylinder(d=70.3, h=27.0, center=true); // Center bore register hub pilot hole
            
            // Generate the five lug mounting pass-through holes (M14 Track Grade Fasteners)
            for (l = [0 : 4]) {
                angle = l * (360 / 5);
                translate([cos(angle) * (lug_circle_diameter / 2), sin(angle) * (lug_circle_diameter / 2), 0])
                    cylinder(d=14.5, h=30.0, center=true);
            }
        }
    }
}

// --- Composite Wheel Stamping System Instantiation ---
union() {
    master_outer_barrel();
    directional_induction_blades();
    authentic_gm_5lug_hub();
}
