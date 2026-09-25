// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_street_lighting.scad (Authentic 1969 FMVSS 108 Light Modules)
// Core Application: Dual-Color Front Valance Indicators & 3-Slot Sequential Taillights
// Center Origin (0,0,0) = Geometric Centerpoint of the Front Valance Light Housing Face
// ====================================================================================

$fn = 100; // Injection toolpath surface finish resolution

// --- 1969 Factory Mechanical Dimensions (mm) ---
inch_to_mm         = 25.4;
front_valance_dia  = 3.50 * inch_to_mm;   // Exactly 88.9 mm original front turn signal diameter
rear_lens_width    = 240.00;              // 1969 authentic 3-slot rear housing width
rear_lens_height   = 75.00;
bezel_lip_depth    = 6.00;

module authentic_front_valance_housing() {
    echo("COMPILING 1969 PROFILE FRONT SWITCHBACK TURN SIGNAL BUCKETS");
    color("Amber", 0.5) { // Amber/Clear dual-function indicator visualization plates
        difference() {
            // Main circular front turn lens cover housing dome
            cylinder(d=front_valance_dia, h=25, center=true);
            cylinder(d=front_valance_dia - 6, h=27, center=true); // Internal cavity fill
        }
    }
    // Rear mounting collar sliding inside the front lower valence sheet metal
    color("DimGrey")
        translate([0, 0, -15])
            cylinder(d=front_valance_dia - 10, h=15, center=true);
}

module authentic_rear_3slot_taillight() {
    echo("COMPILING 1969 SPEC TRIPLE-SLOT REAR TAILLIGHT BACKING FRAMES");
    // Main tail perimeter casting housing
    color("Chrome") {
        difference() {
            cube([rear_lens_width, rear_lens_height, 35], center=true);
            // 3-Slot internal segment separator cavities for sequential LED cards
            for (x_offset = [-75, 0, 75]) {
                translate([x_offset, 0, 4])
                    cube([65, rear_lens_height - 10, 32], center=true);
            }
        }
    }
}

// --- Composite Light Module Compilation ---
union() {
    translate([-150, 0, 0]) authentic_front_valance_housing();
    translate([150, 0, 0])  authentic_rear_3slot_taillight();
}
