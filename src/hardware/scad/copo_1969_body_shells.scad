// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_1969_body_shells.scad (Master 1969 Camaro Body Panel Array)
// Core Objective: Stamping definition geometries optimized for wide track clearances
// Reference Origin (0,0,0) = Firewall Centerpoint along Driveline Longitudinal Axis
// ====================================================================================

$fn = 100; // Parametric curve panel resolution surface finish

// --- Master Body Variant Configuration Mapping ---
// 1 = Base Coupe Sheetmetal, 2 = Rally Sport (RS), 3 = Super Sport (SS), 
// 4 = Z28 Trans-Am Profile, 5 = COPO Drag Special Shell (Maximum Wheel Tubs)
BODY_SHELL_INDEX = 5;

// --- Physical Widebody Scaling Metrics (mm) ---
inch_to_mm         = 25.4;
body_wheelbase     = 114.3 * inch_to_mm; // 2903.22 mm wheelbase alignment
fender_flare_add   = [0.0, 10.0, 15.0, 25.0, 45.0]; // COPO variant drops maximum 45mm rear tub flare
shell_thickness_mm = 1.20;               // Factory accurate stamped sheet metal thickness scale

variant_labels = ["BASE_COUPE_SHELL", "RS_HIDEAWAY_BEZELS", "SS_PERFORMANCE_HOOD", "Z28_ROAD_RACE_SPOILERS", "COPO_EXTREME_WIDEBODY"];

module stamped_outer_fenders() {
    active_flare = fender_flare_add[BODY_SHELL_INDEX - 1];
    echo(str("STAMPING REVOLUTIONARY TECH VEHICLE BODY FACTORY CORE: ", variant_labels[BODY_SHELL_INDEX - 1]));
    
    // LEFT FRONT FLANGED FENDER PANEL
    color("LightSteelBlue") {
        translate([-780 - active_flare, body_wheelbase/3, 100])
            difference() {
                // Main outer quarter skin curvature plate envelope
                scale([1, 1.8, 1.1]) sphere(r=350);
                scale([1, 1.8, 1.1]) sphere(r=350 - shell_thickness_mm);
                // Lower tire entry opening cutout clearance cavity
                translate()
                    cube([400, 800, 400], center=true);
            }
    }
    
    // RIGHT FRONT FLANGED FENDER PANEL
    color("LightSteelBlue") {
        translate([780 + active_flare, body_wheelbase/3, 100])
            difference() {
                scale([1, 1.8, 1.1]) sphere(r=350);
                scale([1, 1.8, 1.1]) sphere(r=350 - shell_thickness_mm);
                translate()
                    cube([400, 800, 400], center=true);
            }
    }
}

module integrated_1969_hood_assembly() {
    // Replicates the distinct dual-rising cowl induction center line lines of the 1969 COPO hood
    color("SkyBlue") {
        translate([-620, body_wheelbase/4 - 100, 280]) {
            difference() {
                cube([1240, 950, shell_thickness_mm]);
                // Specialized performance velocity stack bulge cutout lines
                if (BODY_SHELL_INDEX == 5) {
                    translate([320, 200, -2]) cube([600, 550, 10]);
                }
            }
        }
    }
}

module rear_quarter_panels_and_tubs() {
    active_flare = fender_flare_add[BODY_SHELL_INDEX - 1];
    // Extended deep body tubs housing the maximum width Pirelli racing slicks cleanly
    for (side = [-1, 1]) {
        scale([side, 1, 1])
            translate([810 + active_flare, -body_wheelbase/2 + 200, 120]) {
                color("SteelBlue") {
                    difference() {
                        scale([1.1, 2.0, 1.2]) sphere(r=380);
                        scale([1.1, 2.0, 1.2]) sphere(r=380 - shell_thickness_mm);
                        // Clears the massive 330mm wide rear tyre wheel assemblies
                        translate([-50, 0, -200])
                            cube([400, 900, 500], center=true);
                    }
                }
            }
    }
}

// --- Compile Parametric Sheetmetal Skin Matrix ---
union() {
    stamped_outer_fenders();
    integrated_1969_hood_assembly();
    rear_quarter_panels_and_tubs();
}
