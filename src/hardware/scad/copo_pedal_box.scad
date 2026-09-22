// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_pedal_box.scad (Parametric 1969 Authentic Pedal Assembly)
// Core Principle: Replicates 1969 mechanical arc sweeps while integrating high-accuracy hall arrays
// Center Origin (0,0,0) = Centerpoint of the Master Splined Pivot Shaft Axis
// ====================================================================================

$fn = 120; // High-precision CNC laser-cutting profile resolution

// --- Master Variant Configuration Selector ---
// 1 = 6-Speed Manual Configuration, 2 = High-Performance Automatic Configuration
PEDAL_VARIANT_SELECT = 1; 

// --- 1969 Historical Geometric Constants (mm) ---
inch_to_mm         = 25.4;
pivot_shaft_dia    = 0.75 * inch_to_mm; // 19.05 mm solid splined steel axis shaft
pedal_arm_thickness= 8.00;              // Authentic thick-stamped carbon steel plate
throttle_drop_len  = 10.5 * inch_to_mm; // 266.7 mm authentic arm lever length
brake_drop_len     = 11.2 * inch_to_mm; // 284.48 mm authentic heavy-ratio pedal stroke

// --- Variant Pad Profiles ---
brake_pad_width = (PEDAL_VARIANT_SELECT == 2) ? 130.0 : 65.0; // Automatic gets the wide brake pad style
variant_tag     = (PEDAL_VARIANT_SELECT == 2) ? "1969_COPO_AUTOMATIC_PADS" : "1969_SS_6_SPEED_MANUAL_PADS";

module main_splined_pivot_bar() {
    echo(str("ASSEMBLING FACTORY PEDAL BAY RUNNERS: ", variant_tag));
    // Hardened master steel shaft where all pedal levers pivot
    color("DimGrey") {
        difference() {
            cylinder(d=pivot_shaft_dia + 10, h=300, center=true);
            cylinder(d=pivot_shaft_dia, h=302, center=true); // Internal clearance spline path
        }
    }
}

module authentic_pedal_levers() {
    // 1. THROTTLE PEDAL ASSEMBLY (Maintains authentic 1969 lean angle and pad sweep)
    color("Black") {
        translate([110, -throttle_drop_len, 0])
            rotate([15, 0, 0]) {
                // Stamped lever bar
                cube([pedal_arm_thickness, throttle_drop_len, 20], center=true);
                // Authentic thin rectangular throttle foot-pad faceplate
                translate([0, -throttle_drop_len/2, 10])
                    cube([50, 110, 8], center=true);
            }
    }
    
    // 2. MAIN BRAKE LEVER ASSEMBLY 
    color("SteelBlue") {
        translate([0, -brake_drop_len, 0])
            rotate([12, 0, 0]) {
                cube([pedal_arm_thickness + 2, brake_drop_len, 25], center=true);
                // Adapts automatically between narrow manual pad or wide automatic pad
                translate([0, -brake_drop_len/2, 12])
                    cube([brake_pad_width, 75, 10], center=true);
            }
    }

    // 3. CLUTCH LEVER MODULE (Rendered only if the 6-Speed Manual profile is chosen)
    if (PEDAL_VARIANT_SELECT == 1) {
        color("SlateGrey") {
            translate([-90, -brake_drop_len, 0])
                rotate([12, 0, 0]) {
                    cube([pedal_arm_thickness, brake_drop_len, 22], center=true);
                    // Narrow matching clutch face pad profile
                    translate([0, -brake_drop_len/2, 12])
                        cube([65, 75, 10], center=true);
                }
        }
    }
}

module sealed_sensor_housing() {
    // Mounted at the outer edge of the pivot bar to protect high-accuracy tracking arrays
    translate([150, 0, 0]) {
        color("DarkSlateGrey") {
            difference() {
                cylinder(d=65, h=45, center=true); // Weatherproof billet guard box
                cylinder(d=35, h=47, center=true); // Internal cavity for dual-channel hall chips
            }
        }
    }
}

// --- Compile System Framework Matrix ---
union() {
    main_splined_pivot_bar();
    authentic_pedal_levers();
    sealed_sensor_housing();
}
