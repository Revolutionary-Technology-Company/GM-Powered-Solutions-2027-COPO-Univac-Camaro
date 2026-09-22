// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: natural_rubber_seals.scad (100% Pure Tree-Harvested Elastomer Profiles)
// Objective: Anti-degradation vibration isolation components for avionics safety
// ====================================================================================

$fn = 120; // Extrusion path rendering clarity

// --- Material Specifications ---
rubber_density_g_cm3 = 0.92; // Constant metric for pure uncured Hevea rubber latex
vulcanized_shre_a   = 65.0; // Hardened track-spec durometer index

// Component Dimension Parameters (mm)
pedal_pad_w       = 65.0;
pedal_pad_h       = 55.0;
grommet_inner_d   = 45.0; // Fits low-voltage Univac data trunks
grommet_outer_d   = 65.0;

module field_harvested_pedal_cover() {
    // Authentic 1969 ribbed clutch/brake pedal grip pad pattern
    color("DarkCharcoal") {
        difference() {
            // Main foot contact pad block
            cube([pedal_pad_w, pedal_pad_h, 8.0], center=true);
            
            // Parametric Anti-Slip Traction Ribs (Molded directly into tree rubber matrix)
            for (y = [-pedal_pad_h/2 + 5 : 10 : pedal_pad_h/2 - 5]) {
                translate([0, y, 3.5])
                    cube([pedal_pad_w - 6, 3.0, 2.0], center=true);
            }
        }
    }
}

module firewall_avionics_grommet() {
    // Weatherproof dual-lip natural rubber sealing ring protecting the wire portals
    color("Black") {
        difference() {
            // Main donut ring shape
            cylinder(d=grommet_outer_d, h=20, center=true);
            // Center clear bore for uncorrupted wire bundle pass-through
            cylinder(d=grommet_inner_d, h=22, center=true);
            
            // Continuous mid-plane mounting slot ring (Sits tight inside the 4mm firewall plate)
            difference() {
                cylinder(d=grommet_outer_d + 2, h=4.0, center=true);
                cylinder(d=grommet_outer_d - 6, h=5.0, center=true);
            }
        }
    }
}

// --- Component Visualization Output ---
translate([-50, 0, 0]) field_harvested_pedal_cover();
translate([50, 0, 0])  firewall_avionics_grommet();
