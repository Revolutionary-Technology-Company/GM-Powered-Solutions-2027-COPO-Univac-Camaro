// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_trunk_and_toolkit.scad (1969 Authentic Trunk & Period Toolkit)
// Core Objective: Structural trunk floor pan, spare wheel cradle, and tool lock-downs
// Center Origin (0,0,0) = Geometric Center of the Spare Tire Mounting Well
// ====================================================================================

$fn = 100; // Tooling and stamping rendering precision

// --- 1969 Factory Trunk Spatial Constraints (mm) ---
inch_to_mm          = 25.4;
trunk_width_span    = 48.0 * inch_to_mm; // 1219.2 mm interior trunk rail width
trunk_length_span   = 36.0 * inch_to_mm; // 914.4 mm front-to-rear floor depth
sheet_metal_thick   = 1.20;               // Authentic stamped steel floor pan
spare_wheel_dia     = 678.00;             // Sized for the 26.7" Pirelli racing tire
spare_wheel_width   = 304.80;             // 12.0" widebody wheel depth

// Toolkit Dimensions (mm)
jack_mast_length    = 850.00;             // Original 1969 bumper jack shaft
jack_mast_dia       = 28.00;
lug_wrench_length   = 420.00;
canvas_roll_width   = 320.00;

module stamped_trunk_floor_pan() {
    echo("COMPILING 1969 REAR TRUNK PAN WITH RECESSED SPARE CARRIER");
    color("DarkSlateGrey") {
        difference() {
            // Main horizontal trunk floor sheet
            translate([-trunk_width_span/2, -trunk_length_span/2, 0])
                cube([trunk_width_span, trunk_length_span, sheet_metal_thick]);
            
            // Central drop-in well for the 5th full-size turbine wheel
            cylinder(d=spare_wheel_dia + 20, h=sheet_metal_thick + 2, center=true);
        }
        
        // Recessed spare tire basket cradle
        translate([0, 0, -spare_wheel_width/2]) {
            difference() {
                cylinder(d=spare_wheel_dia + 20, h=spare_wheel_width/2, center=false);
                cylinder(d=spare_wheel_dia + 16, h=spare_wheel_width/2 + 2, center=false);
            }
        }
    }
}

module authentic_1969_toolkit() {
    // 1. ORIGINAL 1969 RATCHET JACK & MAST (With Skid Plate Foot Shoe)
    color("Silver") {
        translate([-trunk_width_span/2 + 80, -trunk_length_span/2 + 100, 25]) {
            rotate([0, 90, 0])
                cylinder(d=jack_mast_dia, h=jack_mast_length); // The notched steel mast
            // Ratchet head mechanism block
            translate([150, -20, -10])
                cube([80, 50, 45]);
            // Heavy-duty base foot adapted for the aluminum skid plate
            translate([0, -40, -15])
                cube([25, 90, 90]);
        }
    }

    // 2. COMBINATION LUG WRENCH / HUB CAP PRY (14mm Track Stud Hex Head)
    color("DimGrey") {
        translate([-trunk_width_span/2 + 120, -trunk_length_span/2 + 160, 20]) {
            rotate([0, 90, 15]) {
                cylinder(d=18.0, h=lug_wrench_length);
                // 14mm deep-well socket head
                translate([0, 0, lug_wrench_length - 30])
                    cylinder(d=26.0, h=30);
                // Chiseled pry end for wheel center cap removal
                translate([-5, -10, 0])
                    cube([10, 20, 25]);
            }
        }
    }

    // 3. CANVAS TOOL ROLL WITH 1000V ISOLATED OPEN-END WRENCHES
    color("DarkOliveGreen") {
        translate([-trunk_width_span/2 + 100, -trunk_length_span/2 + 220, 15]) {
            // Folded heavy canvas fabric wrap
            cube([canvas_roll_width, 140, 45]);
            // Leather tie straps securing the roll
            for (x_offset = [60, canvas_roll_width - 60]) {
                translate([x_offset, -2, -2])
                    color("SaddleBrown") cube([15, 144, 49]);
            }
        }
    }
}

module trunk_lid_torsion_springs() {
    // Authentic dual crisscross torsion spring rods beneath the rear package tray
    color("Black") {
        translate([0, trunk_length_span/2 - 40, 120]) {
            rotate([0, 90, 5])  cylinder(d=8.0, h=trunk_width_span - 60, center=true);
            rotate([0, 90, -5]) cylinder(d=8.0, h=trunk_width_span - 60, center=true);
        }
    }
}

// --- Composite Rear Trunk Assembly Instantiation ---
union() {
    stamped_trunk_floor_pan();
    authentic_1969_toolkit();
    trunk_lid_torsion_springs();
}
