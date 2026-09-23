// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_window_mechanism.scad (Lightweight High-Tensile Cable Window Matrix)
// Core Objective: Maintains 1969 manual crank layout with modern aircraft cable tracking
// Center Origin (0,0,0) = Geometric Centerpoint of the Manual Crank Spline Shaft
// ====================================================================================

$fn = 120; // High-precision CNC milling and pulley path resolution

// --- Core Mechanical Constants (mm) ---
inch_to_mm         = 25.4;
crank_spline_dia   = 0.50 * inch_to_mm;   // 12.7 mm authentic 1969 crank shaft handle spline
pulley_outer_dia   = 45.00;              // Ultra-light carbon-fiber cable guide pulleys
window_glass_travel= 420.00;             // Total vertical window sweep depth profile
door_bracket_thick = 4.50;               // Aluminum mounting ear bracket constraints

// Stamping Configuration Selector
// 1 = Base/SS Street Spec (Pure Manual Hand-Crank), 2 = Tactical Police / NHRA Drag Spec (Solenoid Assisted)
WINDOW_SYSTEM_VARIANT = 2;

module manual_crank_spindle_hub() {
    echo(str("COMPILING DETAILED 1969 WINDOW MECHANISM ENVELOPE: ", (WINDOW_SYSTEM_VARIANT == 2) ? "TACTICAL_SOLENOID_EMERGENCY_DROP" : "PURE_MANUAL_CABLE_CRANK"));
    color("Silver") {
        difference() {
            // Main crank axle spindle gear collar
            cylinder(d=crank_spline_dia + 14, h=35, center=true);
            // Splined internal borehole to lock onto the factory 1969 window crank handle
            cylinder(d=crank_spline_dia, h=37, center=true);
        }
    }
}

module aerospace_cable_pulleys() {
    // Generates the upper and lower pulley paths inside the door skin to route tensile cables
    color("LightBlue") {
        for (y_offset = [-window_glass_travel/2, window_glass_travel/2]) {
            translate([180, y_offset, -10]) {
                rotate([0, 0, 0]) {
                    difference() {
                        // Pulley wheel disc body
                        cylinder(d=pulley_outer_dia, h=8, center=true);
                        // Perimeter cable-groove tracking guide slot channel
                        difference() {
                            cylinder(d=pulley_outer_dia + 2, h=3, center=true);
                            cylinder(d=pulley_outer_dia - 3, h=4, center=true);
                        }
                        // Center reamed sleeve path for low-friction ceramic bearings
                        cylinder(d=8.0, h=10, center=true);
                    }
                }
            }
        }
    }
}

module tactical_emergency_solenoid() {
    // High-current safety release solenoid array deployed exclusively on Track/Police variants.
    // Instantly disengages the mechanical cable brake to drop glass windows out of the door frame.
    if (WINDOW_SYSTEM_VARIANT == 2) {
        color("FireBrick") {
            translate([-85, 0, -15]) {
                difference() {
                    // Main solenoid actuator body housing
                    cube([50, 40, 65], center=true);
                    // Center sliding plunger shaft pass-through channel
                    cylinder(d=12.0, h=68, center=true);
                }
                // Extended mechanical trigger linkage arm fork
                translate([0, 25, 0])
                    cube([8, 20, 12], center=true);
            }
        }
    }
}

// --- Composite Mechanical Window Assembly Instantiation ---
union() {
    manual_crank_spindle_hub();
    aerospace_cable_pulleys();
    tactical_emergency_solenoid();
}
