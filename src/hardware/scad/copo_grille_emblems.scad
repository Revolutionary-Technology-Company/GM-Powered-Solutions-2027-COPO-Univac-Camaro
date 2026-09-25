// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_grille_emblems.scad (Authentic 1969 Grille & Stamped Emblems)
// Core Application: 1969 COPO Camaro Sleeper Aesthetics with Hidden Cooling Channels
// Center Origin (0,0,0) = Geometric Centerpoint of the Front Grille Bowtie Axis
// ====================================================================================

$fn = 100; // High-precision injection toolpath and stamping resolution

// --- 1969 Factory Face Dimensions (mm) ---
inch_to_mm         = 25.4;
grille_total_width = 54.0 * inch_to_mm; // Fits front clip skin boundaries natively [INDEX]
grille_total_height= 210.00;
egg_crate_mesh_w   = 28.00;             // Fine vintage grid spacing dimensions
bowtie_emblem_w    = 140.00;            // Sized to match 1969 factory dimensions

// Active Variant Configuration lookup [INDEX]
// 1 = Base/COPO Sleeper (Standard Bowtie), 2 = Rally Sport (Hideaway Doors Enabled)
COPO_FRONT_VARIANT = 2;

module authentic_eggcrate_grille() {
    echo(str("COMPILING 1969 COPO GRILLE COMPONENT: ", (COPO_FRONT_VARIANT == 2) ? "RS_HIDEAWAY_BEZELS_ACTIVE" : "STANDARD_SLEEPER_BOWTIE"));
    color("DarkCharcoal") {
        difference() {
            // Main horizontal grille core blank plate
            cube([grille_total_width - 80, grille_total_height, 15.0], center=true);
            
            // Parametric Egg-Crate Lattice Cutouts (Provides maximum airflow velocity)
            for (x = [-grille_total_width/2 + 100 : egg_crate_mesh_w : grille_total_width/2 - 100]) {
                for (y = [-grille_total_height/2 + 20 : 35 : grille_total_height/2 - 20]) {
                    translate([x, y, 0])
                        cube([egg_crate_mesh_w - 6, 25.0, 20.0], center=true);
                }
            }
        }
    }
}

module factory_bowtie_emblem() {
    // Recreates the original 1969 flanged chrome bowtie badge centered in the mesh
    if (COPO_FRONT_VARIANT == 1) {
        color("Chrome") {
            translate([0, 0, 10]) {
                // Cross-bar backing plate element
                cube([bowtie_emblem_w, 35, 6.0], center=true);
                // Angled center chevron wing overlays
                rotate([0, 0, 45]) cube([65, 65, 8.0], center=true);
                rotate([0, 0, -45]) cube([65, 65, 8.0], center=true);
            }
        }
    }
}

module rs_hideaway_door_bezels() {
    // Models the vacuum-look hideaway headlight covers that retract behind the header [INDEX]
    if (COPO_FRONT_VARIANT == 2) {
        color("Black") {
            for (side = [-1, 1]) {
                translate([side * (grille_total_width/2 - 90), 0, 5]) {
                    difference() {
                        // Door cover frame matching outer egg-crate look
                        cube([160.0, grille_total_height - 10, 12.0], center=true);
                        // Rotating pivot bolt borehole coordinates
                        translate([side * 75, 0, 0]) rotate() cylinder(d=8.2, h=grille_total_height);
                    }
                }
            }
        }
    }
}

// --- Unify Front Facia Aesthetics System Instantiation ---
union() {
    authentic_eggcrate_grille();
    factory_bowtie_emblem();
    rs_hideaway_door_bezels();
}
