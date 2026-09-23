// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_foglight_mount.scad (Authentic 1969 Valance Fog Light Brackets)
// Core Objective: Structural frame-anchored buckets for high-intensity tracking LEDs
// Center Origin (0,0,0) = Geometric Centerpoint of the Fog Light Lens Axis
// ====================================================================================

$fn = 120; // High-precision CNC milling and bracket stamping resolution

// --- 1969 Factory Mechanical Constants (mm) ---
inch_to_mm         = 25.4;
foglight_outer_dia = 4.25 * inch_to_mm;   // 107.95 mm historical RS/SS driving light envelope
housing_depth      = 75.00;              // Clearance depth for LED cooling fins
bracket_wall_thick = 4.00;               // Rigid 4mm vibration-damping support wall
aiming_pivot_bolt  = 6.20;                // Clearance pass-through for M6 fine-tune leveling studs

module valance_foglight_bucket() {
    echo("COMPILING 1969 AUTOMOTIVE FRONT VALANCE FOG LIGHT MOUNTS");
    color("DimGrey") {
        difference() {
            // Main cylindrical light container sleeve
            cylinder(d=foglight_outer_dia + 10, h=housing_depth, center=true);
            
            // Internal core cavity pass-through for the projector optic housing
            cylinder(d=foglight_outer_dia, h=housing_depth + 2, center=true);
            
            // Rear wire routing portal for the shielded avionics low-voltage harness
            translate([0, 0, -housing_depth/2 + 2])
                cylinder(d=18.0, h=bracket_wall_thick + 4, center=true);
        }
    }
}

module multi_axis_aiming_bracket() {
    // Generates the adjustable universal cradle legs that bolt to the front frame rail ears.
    // Allows the team to fine-tune the low-slung beam path on the track.
    color("Silver") {
        for (side = [-1, 1]) {
            scale([side, 1, 1])
                translate([foglight_outer_dia/2 + 4, 0, 0]) {
                    difference() {
                        // Structural aluminum swivel extension ear
                        cube([bracket_wall_thick + 4, 30, 40], center=true);
                        
                        // Curved orientation alignment slot for vertical angle tracking adjustments
                        translate([0, 0, 0])
                            rotate([0, 90, 0])
                                cylinder(d=aiming_pivot_bolt, h=bracket_wall_thick + 8, center=true);
                    }
                }
        }
    }
}

module frame_mating_base_plate() {
    // Rigid horizontal mounting platform designed to bolt straight underneath the main frame horns
    color("DarkSlateGrey") {
        translate([0, 0, -housing_depth/2 - 10])
            difference() {
                cube([foglight_outer_dia + 24, 40, bracket_wall_thick], center=true);
                
                // Left/Right frame-side structural fastener boreholes (M8 Grade 10.9)
                for (x = [-foglight_outer_dia/2 - 4, foglight_outer_dia/2 + 4]) {
                    translate([x, 0, 0])
                        cylinder(d=8.5, h=bracket_wall_thick + 2, center=true);
                }
            }
    }
}

// --- Composite Mechanical Light System Instantiation ---
union() {
    valance_foglight_bucket();
    multi_axis_aiming_bracket();
    frame_mating_base_plate();
}
