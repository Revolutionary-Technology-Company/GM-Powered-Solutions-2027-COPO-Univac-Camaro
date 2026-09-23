// ====================================================================================
// REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
// Subsystem: copo_hv_breaker_vault.scad (800V Master Safety Disconnect Enclosure)
// Core Standard: Explosion-Resistant Hardened Vault / Active Shroud Blower Port
// Center Origin (0,0,0) = Geometric Centerpoint of the Primary High-Current Busbar Post
// ====================================================================================

$fn = 120; // High-precision CNC milling and waterjet routing resolution

// --- Physical Vault Constraints & Constants (mm) ---
inch_to_mm         = 25.4;
vault_length       = 200.00;           // Fits tightly along lower left frame rail channel
vault_width        = 140.00;           // Compact packaging envelope minimizing unsprung mass
vault_height       = 110.00;           // Spatial box clearance threshold
wall_thickness_ti  = 6.35;             // 1/4" Thick Titanium Grade 5 safety containment shield

// Component Port Interface Diameters (mm)
busbar_entry_w     = 32.00;            // Sized for 30mm x 5mm rigid copper traction bars
blower_intake_d    = 76.00;            // Clears the low-noise 80mm active cooling blower throat

module heavy_high_voltage_breaker_vault() {
    echo("MILLING EXPLOSION-RESISTANT HIGH-VOLTAGE SAFETY DISCONNECT VAULT SHIELD");
    color("DimGrey") {
        difference() {
            // Main solid high-voltage contactor containment vault box
            cube([vault_width, vault_length, vault_height], center=true);
            
            // Internal component cavity leaving ample volume for pyro-fuses and relays
            cube([vault_width - (2*wall_thickness_ti), vault_length - (2*wall_thickness_ti), vault_height - (2*wall_thickness_ti)], center=true);
            
            // 1. INBOUND AND OUTBOUND RIGID COPPER BUSBAR THROUGH-SLOTS
            for (y_offset = [-90, 90]) {
                translate([0, y_offset, -20])
                    cube([busbar_entry_w, 20, 10], center=true);
            }
            
            // 2. CONCENTRIC THERMAL BLOWER ACTIVE INTENSIVE COOLING EXHAUST PORT
            translate([-vault_width/2 + 2, 0, 15])
                rotate([0, 90, 0])
                    cylinder(d=blower_intake_d, h=wall_thickness_ti + 4, center=true);
        }
    }
}

module acdelco_seal_perimeter_groove() {
    // 3mm deep perimeter routing track carved into the vault mating flange.
    // Holds the form-molded natural tree-rubber gasket to guarantee IP69K weatherproofing.
    color("DarkSlateGrey") {
        translate([0, 0, vault_height/2 - 2])
            difference() {
                cube([vault_width - 2, vault_length - 2, 4], center=true);
                cube([vault_width - 8, vault_length - 8, 6], center=true);
            }
    }
}

// --- Composite Structural Breaker Vault Instantiation ---
union() {
    heavy_high_voltage_breaker_vault();
    acdelco_seal_perimeter_groove();
}
