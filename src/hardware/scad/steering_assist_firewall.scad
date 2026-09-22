// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: steering_assist_firewall.scad (Inline EPAS Firewall Servo Mounting)
// Target Hardware: 1969 Manual Quick-Ratio Box with Solid-State 12V Assist Motor
// Center Origin (0,0,0) = Steering Shaft Intersection Centerline at Firewall Face
// ====================================================================================

$fn = 120; // High-precision CNC machining path finish parameter

// --- Engineering Constants (mm) ---
inch_to_mm         = 25.4;
shaft_outer_dia    = 0.75 * inch_to_mm; // 19.05 mm standard splined steering column shaft
servo_housing_dia  = 115.00;           // High-torque brushless electric assist motor casing
housing_length     = 160.00;           // Longitudinal footprint length along steering axis
bracket_thickness  = 12.00;            // 12mm structural billet aluminum support plates

module steering_column_shaft() {
    // Solid splined output shaft connecting steering wheel to the 1969 steering box
    color("Silver") {
        translate([0, 0, -housing_length/2 - 30])
            cylinder(d=shaft_outer_dia, h=housing_length + 60);
    }
}

module epas_motor_enclosure() {
    // Concentric brushless electric motor assembly surrounding the mechanical shaft
    color("DimGrey") {
        difference() {
            // Main motor stator housing body barrel
            cylinder(d=servo_housing_dia, h=housing_length, center=true);
            // Internal diameter clearance hole for isolation spacers
            cylinder(d=shaft_outer_dia + 20, h=housing_length + 2, center=true);
            
            // ACDelco Environmental Sealing Channels
            // 3mm deep perimeter routing track for liquid RTV silicone gasket application
            translate([0, 0, housing_length/2 - 3])
                difference() {
                    cylinder(d=servo_housing_dia - 6, h=4, center=true);
                    cylinder(d=servo_housing_dia - 12, h=5, center=true);
                }
        }
    }
}

module firewall_mating_flange() {
    // Heavy-duty structural collar plate to anchor the motor torque directly to the firewall
    color("LightGrey") {
        difference() {
            // Triangular structural support plate block
            translate([-75, -75, -housing_length/2])
                cube([150, 150, bracket_thickness]);
            // Center clear bore for column shaft passage
            translate([0, 0, -housing_length/2 - 1])
                cylinder(d=servo_housing_dia - 10, h=bracket_thickness + 2);
            
            // 4-Corner structural mounting bolt pass-through layout (M10 Hardware)
            for (x = [-55, 55]) {
                for (y = [-55, 55]) {
                    translate([x, y, -housing_length/2 - 1])
                        cylinder(d=10.5, h=bracket_thickness + 2);
                }
            }
        }
    }
}

// --- Composite Structural System Instantiation ---
union() {
    steering_column_shaft();
    epas_motor_enclosure();
    firewall_mating_flange();
}
