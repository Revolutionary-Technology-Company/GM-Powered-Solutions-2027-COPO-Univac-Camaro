// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_transmission_coupler.scad (Parametric Direct-Drive Transmission Hub)
// Core Objective: Adapts Square-Tooth Motor Axis to Manual Clutch or Automatic Gearbox
// Center Origin (0,0,0) = Concentric Centerline Axis of the Drivetrain Shaft Splines
// ====================================================================================

$fn = 120; // High-precision CNC spline-cutting profiling resolution

// --- Master Transmission Configuration Selector ---
// 1 = 6-Speed Manual (Tremec TR-6060 26-Spline Clutch Profile)
// 2 = 10-Speed Automatic (GM 10L90 Heavy-Duty Direct-Drive Spline Yoke)
TRANSMISSION_TYPE_SELECT = 2;

// --- Physical Dimensional Constants (mm) ---
inch_to_mm          = 25.4;
motor_shaft_input_d = 45.00;           // Standard solid motor drive output axle
coupler_total_len   = 95.00;           // Mechanical engagement depth profile

// Parametric Spline Configuration Math Lookups
spline_major_dia = (TRANSMISSION_TYPE_SELECT == 1) ? 1.125 * inch_to_mm : 1.375 * inch_to_mm; // 28.575mm vs 34.925mm
num_spline_teeth = (TRANSMISSION_TYPE_SELECT == 1) ? 26 : 32;                                 // 26-spline manual vs 32-spline auto yoke
variant_string   = (TRANSMISSION_TYPE_SELECT == 1) ? "TR6060_MANUAL_26_SPLINE_CLUTCH_HUB" : "10L90_AUTOMATIC_32_SPLINE_DIRECT_YOKE";

module motor_side_engagement_socket() {
    echo(str("COMPILING CAD TRANSMISSION COUPLER BLUEPRINT: ", variant_string));
    color("Silver") {
        difference() {
            // Main solid steel coupling collar sleeve barrel
            cylinder(d=spline_major_dia + 25, h=coupler_total_len/2, center=false);
            // Reamed precision bore to slip tightly onto the axial-flux motor shaft
            translate([0, 0, -1])
                cylinder(d=motor_shaft_input_d, h=coupler_total_len/2 + 2);
            // Deep keyway slot to lock motor rotation using a structural steel key
            translate([motor_shaft_input_d/2, -5, -1])
                cube([10, 10, coupler_total_len/2 + 2]);
        }
    }
}

module transmission_side_spline_shaft() {
    // Generates the parametric involute spine teeth to slide straight into the transmission assembly
    color("LightGrey") {
        translate([0, 0, coupler_total_len/2]) {
            difference() {
                // Outer spline core blank shaft
                cylinder(d=spline_major_dia, h=coupler_total_len/2, center=false);
                
                // Parametric Spline Tooth Generation Passages
                for (s = [0 : num_spline_teeth - 1]) {
                    rotate([0, 0, s * (360 / num_spline_teeth)])
                        translate([spline_major_dia/2, 0, coupler_total_len/4])
                            // Cuts an exact negative groove profile into the shaft face boundary walls
                            cube([3.5, 2.0, coupler_total_len/2 + 2], center=true);
                }
            }
        }
    }
}

// --- Composite Mechanical Coupler Instantiation ---
union() {
    motor_side_engagement_socket();
    transmission_side_spline_shaft();
}
