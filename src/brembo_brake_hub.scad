// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Module: brembo_brake_hub.scad (6-Piston Caliper Mount Assembly & Wheel Spindle Interface)
// Target Hardware: Brembo GT-S Monoblock Calipers / 380mm Carbon-Ceramic Rotors
// Center Origin (0,0,0) = Axis of Rotation for Titanium Axle Spindle
// ====================================================================================

$fn = 120; // High-precision CNC drilling optimization

// --- Parametric Geometric Constants (mm) ---
inch_to_mm         = 25.4;
spindle_outer_dia  = 42.00;           // Fits the high-torque solid CV axle bar
rotor_hat_dia      = 185.00;          // Core bell mounting center for carbon rotor
caliper_bolt_space = 194.50;          // Radial center-to-center distance for Brembo mounts
caliper_bolt_dia   = 12.20;           // Clearance pass-through for M12 grade 12.9 structural bolts
radial_offset_r    = 178.00;          // Fixed distance from centerline axis to caliper ears

module center_axle_spindle() {
    // Heavy-duty wheel hub spindle sleeve extending out from widebody control arm
    color("DimGrey") {
        difference() {
            cylinder(d=spindle_outer_dia + 25, h=65, center=true);
            cylinder(d=spindle_outer_dia, h=67, center=true); // Spline path bore
        }
    }
}

module brembo_caliper_bracket() {
    // CNC billet bracket arm to transfer deceleration torque directly to chassis stands
    color("Silver") {
        difference() {
            // Main solid torque structural bracket block
            translate([radial_offset_r - 20, 0, 0])
                cube([40, caliper_bolt_space + 40, 20], center=true);
            
            // Upper Caliper Structural Fastener Mounting Ear
            translate([radial_offset_r, caliper_bolt_space / 2, 0])
                cylinder(d=caliper_bolt_dia, h=25, center=true);
            
            // Lower Caliper Structural Fastener Mounting Ear
            translate([radial_offset_r, -caliper_bolt_space / 2, 0])
                cylinder(d=caliper_bolt_dia, h=25, center=true);
            
            // Weight optimization recess pockets (Reduces unsprung mass without dropping rigidity)
            translate([radial_offset_r - 20, 0, 0])
                cube([25, caliper_bolt_space - 40, 22], center=true);
        }
    }
}

module carbon_rotor_hat_register() {
    // 5-Lug universal bolt circle interface (GM Standard 5x120.65mm pattern)
    lug_circle_dia = 120.65;
    lug_bolt_dia   = 14.5; // Clears heavy-duty M14 track studs
    
    color("DarkGrey") {
        difference() {
            // Main rotating hub face plate flange
            translate([0, 0, 10])
                cylinder(d=rotor_hat_dia, h=10, center=true);
            // Center spindle clear bore pass-through
            translate([0, 0, 10])
                cylinder(d=spindle_outer_dia + 5, h=12, center=true);
            
            // Parametric 5-Lug Radial Bolt Pattern Generation
            for (i = [0 : 4]) {
                angle = i * (360 / 5);
                translate([cos(angle) * (lug_circle_dia / 2), sin(angle) * (lug_circle_dia / 2), 10])
                    cylinder(d=lug_bolt_dia, h=15, center=true);
            }
        }
    }
}

// --- Composite Structural System Instantiation ---
union() {
    center_axle_spindle();
    brembo_caliper_bracket();
    carbon_rotor_hat_register();
}
