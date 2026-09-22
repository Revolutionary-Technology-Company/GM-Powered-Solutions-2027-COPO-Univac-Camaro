// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_cage_variants.scad (Modular Multi-Variant Safety Enclosure Matrix)
// Core Principle: Identical floor footprint hosting 10-Point Drag or 4-Point Street cages
// Center Origin (0,0,0) = Axis of Rotation for Drivetrain Centerline at Firewall
// ====================================================================================

$fn = 120; // Structural CNC tube profile resolution

// --- Master Cage Variant Selector ---
// 1 = 10-Point NHRA 8.50 Drag Cert Cage (with Funny Car Helmet Shield)
// 2 = 4-Point Removable Street / Convertible Roll Bar (Pace Car Variant)
CAGE_SPEC_INDEX = 1;

// --- Parametric Geometry Parameters (mm) ---
inch_to_mm        = 25.4;
tube_od           = 1.625 * inch_to_mm; // Standard 1-5/8" high-rigidity tubing
tube_wall         = 0.083 * inch_to_mm; // 4130 Chrome Moly lightweight wall thickness
cabin_width       = 56.0  * inch_to_mm; 
main_hoop_height  = 44.0  * inch_to_mm; 
rear_drop_length  = 52.0  * inch_to_mm;

module hollow_safety_tube(length) {
    difference() {
        cylinder(d=tube_od, h=length, center=false);
        translate([0, 0, -1])
            cylinder(d=(tube_od - (2 * tube_wall)), h=length + 2, center=false);
    }
}

module unified_base_hoop() {
    echo(str("COMPILING FACTORY COCKPIT SAFETY CAGE PROFILE: ", (CAGE_SPEC_INDEX == 1) ? "10_POINT_NHRA_DRAG_CERT" : "4_POINT_REMOVABLE_STREET"));
    // B-Pillar main hoop that remains structurally consistent across all models
    color("Crimson") {
        translate([-cabin_width/2, -200, 0]) structural_tube_element_variant(main_hoop_height);
        translate([cabin_width/2, -200, 0])  structural_tube_element_variant(main_hoop_height);
        translate([-cabin_width/2, -200, main_hoop_height]) rotate() structural_tube_element_variant(cabin_width);
    }
    // Rear bracing bars tying the main hoop directly into the rear Pirelli widebody tubs
    color("DarkRed") {
        for (side = [-1, 1]) {
            translate([side * (cabin_width/2 - 20), -200, main_hoop_height])
                rotate([35, 0, side * 5]) structural_tube_element_variant(rear_drop_length);
        }
    }
}

module drag_10point_addition() {
    // Advanced front-clip bars rendered exclusively for the 10-Point configuration
    if (CAGE_SPEC_INDEX == 1) {
        color("FireBrick") {
            // Front A-Pillar Down-tubes hugging the inner windshield contour
            translate([-cabin_width/2, 400, 0]) structural_tube_element_variant(main_hoop_height);
            translate([cabin_width/2, 400, 0])  structural_tube_element_variant(main_hoop_height);
            
            // Roof Halo Bar bounding the driver compartment roofline
            translate([-cabin_width/2, -200, main_hoop_height])
                rotate([0, 90, 0]) structural_tube_element_variant(600);
            translate([cabin_width/2, -200, main_hoop_height])
                rotate([0, 90, 0]) structural_tube_element_variant(600);
                
            // Funny Car Style Protective Helmet Halo Loop Around Driver Seat
            translate([-cabin_width/4, -200, main_hoop_height - 200])
                cube([250, 40, 250]); // Multi-bar safety head shield capsule
        }
    }
}

module structural_tube_element_variant(length) {
    hollow_safety_tube(length);
}

// --- Assemble Selection Block Matrix ---
union() {
    unified_base_hoop();
    drag_10point_addition();
    
    // Heavy 6x6x0.125" Floor Landing Pads Mandated by NHRA to distribute frame strain
    for (x = [-cabin_width/2, cabin_width/2]) {
        translate([x - 75, -275, -5]) cube([150, 150, 4]);
    }
}
