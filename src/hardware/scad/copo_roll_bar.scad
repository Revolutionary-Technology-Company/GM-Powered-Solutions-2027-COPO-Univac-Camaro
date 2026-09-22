// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_roll_bar.scad (NHRA-Compliant 8-Point Cockpit Protection Matrix)
// Core Objective: Stiffens 1969 Camaro chassis shell & secures avionics safety envelopes
// Center Origin (0,0,0) = Axis of Rotation for Drivetrain Centerline at Firewall
// ====================================================================================

$fn = 100; // High-fidelity tube bend extrusion finish parameter

// --- Material Mode Sync (Inherited from Master Frame) ---
// 1 = 4130 Chromoly Steel (Drag Spec), 2 = Titanium Grade 5 (Aviation Matrix)
MATERIAL_MODE = 2;

// Parametric Tube Sizing Math (mm)
inch_to_mm        = 25.4;
tube_od           = (MATERIAL_MODE == 2) ? 2.00 * inch_to_mm : 1.75 * inch_to_mm;
tube_wall         = (MATERIAL_MODE == 2) ? 3.50 : 3.00; // NHRA structural safety walls
tube_id           = tube_od - (2 * tube_wall);

// 1969 Camaro Cockpit Spatial Envelopes (mm)
cabin_width       = 56.0 * inch_to_mm; // 1422.4 mm internal roof taper clearance
main_hoop_height  = 44.0 * inch_to_mm; // 1117.6 mm vertically from frame rails
rear_drop_length  = 52.0 * inch_to_mm; // Angle down to rear wheel tub integration

module structural_tube_element(length) {
    // Generates a perfectly uniform, hollow structural safety tube element
    difference() {
        cylinder(d=tube_od, h=length, center=false);
        translate([0, 0, -1])
            cylinder(d=tube_id, h=length + 2, center=false);
    }
}

module main_roll_hoop() {
    // The primary B-pillar hoop surrounding the driver's head and the Univac bay area
    color("Crimson") {
        // Left Vertical Pillar Leg
        translate([-cabin_width/2, -200, 0])
            structural_tube_element(main_hoop_height);
        // Right Vertical Pillar Leg
        translate([cabin_width/2, -200, 0])
            structural_tube_element(main_hoop_height);
        // Top Roof Cross-Member Bar
        translate([-cabin_width/2, -200, main_hoop_height])
            rotate([0, 90, 0])
                structural_tube_element(cabin_width);
    }
}

module rear_down_struts() {
    // Two structural bars triangulation bracing down from the top B-pillar hoop to the rear axles
    color("DarkRed") {
        for (side = [-1, 1]) {
            translate([side * (cabin_width/2 - 20), -200, main_hoop_height])
                // Math vector angling down straight to the rear widebody Pirelli tyre tub frames
                rotate([35, 0, side * 5])
                    structural_tube_element(rear_drop_length);
        }
    }
}

module door_bars_and_harness_brace() {
    // Critical driver protection tracks that prevent cabin intrusion during track events
    color("FireBrick") {
        // Horizontal Shoulder Harness Bar (Where you clip racing seat belts right behind the dash)
        translate([-cabin_width/2, -200, main_hoop_height * 0.6])
            rotate([0, 90, 0])
                structural_tube_element(cabin_width);
                
        // Left/Right Forward Door Portal Bars
        for (side = [-1, 1]) {
            translate([side * cabin_width/2, -200, 20])
                rotate([-45, 0, 0])
                    structural_tube_element(main_hoop_height * 1.2);
        }
    }
}

module heavy_duty_floor_plates() {
    // Thick 6mm gusset reinforcement landing pads where the cage welds to the main rails
    color("Silver") {
        for (x_offset = [-cabin_width/2, cabin_width/2]) {
            // Under B-Pillar vertical landing feet
            translate([x_offset - 25, -225, -5])
                cube([50, 50, 6]);
        }
    }
}

// --- Composite Cage Matrix Instantiation ---
union() {
    main_roll_hoop();
    rear_down_struts();
    door_bars_and_harness_brace();
    heavy_duty_floor_plates();
}
