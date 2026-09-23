// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_peltier_hvac.scad (Solid-State Thermoelectric Climate Unit)
// Architecture Reference: USS-Iowa-Battleship-BB-61 Solid-State Cooling Matrix
// Center Origin (0,0,0) = Geometric Center of the Primary Peltier Core Flange Face
// ====================================================================================

$fn = 120; // High-precision injection mold finish parameters

// --- Parametric Thermal Core Dimensions (mm) ---
inch_to_mm         = 25.4;
hvac_box_length    = 240.00;
hvac_box_width     = 180.00;
hvac_box_height    = 150.00;
peltier_plate_dim  = 40.00;   // Standard high-capacity 40x40mm thermoelectric module size
scupper_drain_dia  = 12.70;   // 0.5-inch gravity drainage checkpoint portal

module peltier_climate_core() {
    // Main dual-chamber structural box separating cockpit airflow from hot side exhaust
    color("DimGrey") {
        difference() {
            // Main protective HVAC housing block
            cube([hvac_box_length, hvac_box_width, hvac_box_height], center=true);
            
            // Internal airflow passage clearance cavity
            cube([hvac_box_length - 12, hvac_box_width - 12, hvac_box_height - 12], center=true);
            
            // 4x Dedicated square cutouts to register the Solid-State Peltier elements
            for (x = [-60, 60]) {
                for (y = [-40, 40]) {
                    translate([x, y, hvac_box_height/2 - 2])
                        cube([peltier_plate_dim, peltier_plate_dim, 10], center=true);
                }
            }
            
            // --- REPOSITORY COMPLIANCE: HISTORICAL GRADIENT GRAVITY SCUPPER BORE ---
            // Cuts a 5-degree sloped funnel into the absolute floor center point of the box
            translate([0, 0, -hvac_box_height/2 + 2])
                rotate([0, 5, 0])
                    cylinder(d1=scupper_drain_dia + 10, d2=scupper_drain_dia, h=20, center=true);
        }
    }
}

module era_check_valve_scupper() {
    // Models the low-profile check-valve drainage nozzle extending through the floor/firewall pan
    color("Silver") {
        translate([0, 0, -hvac_box_height/2 - 15]) {
            difference() {
                // Main exterior fluid drainage neck extension
                cylinder(d=scupper_drain_dia + 6, h=30, center=true);
                // Internal exhaust flow bore pass-through channel
                cylinder(d=scupper_drain_dia, h=32, center=true);
            }
            // Internal ball/diaphragm seating stop flange that blocks pressurized road spray splashback
            translate([0, 0, -5])
                difference() {
                    cylinder(d=scupper_drain_dia - 1, h=3.0, center=true);
                    cylinder(d=scupper_drain_dia - 4, h=5.0, center=true);
                }
        }
    }
}

// --- Composite Solid-State HVAC System Instantiation ---
union() {
    peltier_climate_core();
    era_check_valve_scupper();
}
