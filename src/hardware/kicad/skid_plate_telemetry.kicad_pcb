// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_underbody_armor.scad (Billet Aluminum Underbelly Protection Matrix)
// Core Objective: Structural skid plate shield & concentric rally splash wheel covers
// Center Origin (0,0,0) = Geometric Centerpoint of the Front Underbelly Crossmember Face
// ====================================================================================

$fn = 120; // High-fidelity waterjet cutting path profiling resolution

// --- Engineering Constants (mm) ---
inch_to_mm          = 25.4;
frame_width_span    = 24.0  * inch_to_mm; // 609.6 mm track frame rail width
engine_bay_length   = 29.5  * inch_to_mm; // 749.3 mm longitudinal engine bay envelope
skid_plate_thickness = 6.35;               // Heavy-duty 1/4" aircraft-grade 6061-T6 aluminum plate
fender_liner_radius = 360.00;              // Concentric splash clearance for Pirelli wide slicks

// Production Variant Selector
// 1 = Clean Track/Street Spec (Standard Liners), 2 = Tactical Police / Rally Spec (Heavy Mud Flaps Deployed)
ARMOR_VARIANT_PROFILE = 2;

module structural_aluminum_skid_plate() {
    echo("COMPILING HEAVY UNDERBODY SKID PLATE AND REINFORCED FLAP TABS");
    color("Silver") { // High-polished milled aluminum panel sheet representation
        difference() {
            // Main solid underbelly armor protective skid plate
            translate([-frame_width_span/2, 0, -110])
                cube([frame_width_span, engine_bay_length, skid_plate_thickness]);
            
            // Recessed drainage passage matching the Peltier HVAC check-valve scupper nozzle
            translate([0, engine_bay_length/2, -112])
                cylinder(d=32.0, h=skid_plate_thickness + 4);
                
            // Flush counter-sunk fastener drilling grid patterns (M10 grade 12.9 hardware)
            for (y_step = [100 : 200 : engine_bay_length - 100]) {
                for (x_offset = [-frame_width_span/2 + 25, frame_width_span/2 - 25]) {
                    translate([x_offset, y_step, -112])
                        cylinder(d=10.5, h=skid_plate_thickness + 4);
                }
            }
        }
    }
}

module inner_wheel_well_covers() {
    // Concentric inner splash shielding panels protecting the engine bay wall boundaries
    color("DarkSlateGrey") {
        for (side = [-1, 1]) {
            scale([side, 1, 1])
                translate([frame_width_span/2 + 10, engine_bay_length/3, -50])
                    difference() {
                        // Outer structural splash shield arch barrel slice
                        cylinder(r=fender_liner_radius, h=311, center=true); // Clears the 311mm wide front Pirellis
                        cylinder(r=fender_liner_radius - 4, h=315, center=true);
                    }
        }
    }
}

module rally_style_mud_flaps() {
    // Heavy flexible mud flaps tracking out behind the tire arches on variant index 2
    if (ARMOR_VARIANT_PROFILE == 2) {
        color("Black") { // 100% Tree-Harvested vulcanized anti-degradation rubber compounds
            for (side = [-1, 1]) {
                translate([side * (frame_width_span/2 + 120), -50, -160])
                    rotate([0, 0, side * 5])
                        // Heavy protection guard dropping low behind the trailing edge tire tread
                        cube([325, 6, 220], center=true); // Matches the width of the wide rear Pirelli racing slicks
            }
        }
    }
}

// --- Composite Underbody Protection System Instantiation ---
union() {
    structural_aluminum_skid_plate();
    inner_wheel_well_covers();
    rally_style_mud_flaps();
}
