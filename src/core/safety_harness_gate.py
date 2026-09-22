#!/usr/bin/env python3
# ==============================================================================
# REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
# Module: safety_harness_gate.py (Dynamic Safety Harness Verification Engine)
# ==============================================================================

class DynamicSafetyRestraintGate:
    def __init__(self):
        # Operational mode profile constraints
        self.MODE_STREET = 0x01
        self.MODE_TRACK  = 0x02

    def evaluate_driver_restraints(self, active_car_mode: int, street_belt_latched: bool, track_harness_cammed: bool) -> dict:
        """
        Cross-checks physical belt latch metrics using exact fixed-point transitions
        to block high-power gate-driver current flow if restraint targets are missed.
        """
        allow_propulsion = False
        dashboard_msg = "SAFETY_RESTRAINT_FAULT: OCCUPANT UNSECURED"
        univac_safety_code = 0x700 # Fault lock state
        
        # Core safety state processing matrix
        if active_car_mode == self.MODE_STREET:
            if street_belt_latched or track_harness_cammed:
                allow_propulsion = True
                dashboard_msg = "STREET_RESTRICTIONS_NOMINAL: SEATBELT VERIFIED"
                univac_safety_code = 0x000 # All clear path
        elif active_car_mode == self.MODE_TRACK:
            if track_harness_cammed:
                allow_propulsion = True
                dashboard_msg = "TRACK_RESTRICTIONS_NOMINAL: 5-POINT HARNESS LOCKED"
                univac_safety_code = 0x000 # All clear path
            else:
                dashboard_msg = "CRITICAL TRACK FAULT: 5-POINT HARNESS MANDATORY IN COPO HIGH-OUTPUT MODE"
                univac_safety_code = 0x3AA # Specific track constraint flag ID
                
        # Stack configuration records into our un-truncated 108-bit register mask representation
        # Bits 72-107: Power Enabler | Bits 36-71: Harness Bitmask | Bits 0-35: Alert Index
        power_bit = 1 if allow_propulsion else 0
        harness_bitmask = (int(street_belt_latched) << 1) | int(track_harness_cammed)
        stacked_register_word = (power_bit << 72) | (harness_bitmask << 36) | univac_safety_code
        
        return {
            "POWERTRAIN_PROPULSION_ALLOWED": allow_propulsion,
            "COCKPIT_BEZEL_DISPLAY_ALERT": dashboard_msg,
            "UNIVAC_IX_36BIT_WORD": f"0x{(stacked_register_word >> 72) & 0x7FFFFFFFF:09X}"
        }

if __name__ == "__main__":
    gate = DynamicSafetyRestraintGate()
    print("=======================================================================")
    print("UNIVAC-IX RESTRAINT ASSURANCE SYSTEM INITIALIZED (SFI-RESTRICTION)")
    print("=======================================================================")
    
    # Simulation: Driver selects high-output COPO Track Mode but only loops the standard street belt
    current_drive_profile = 0x02  # Track Mode Active
    is_3point_latched     = True  # Street belt clicked
    is_5point_cammed      = False # Racing harness loose
    
    clearance_report = gate.evaluate_driver_restraints(current_drive_profile, is_3point_latched, is_5point_cammed)
    print(f"[CONFIGURATION SENSE] Selected Mode: TRACK | Street Belt: LATCHED | 5-Point Cam: OPEN")
    print(f"[CO-PILOT CONSOLE STATUS]: {clearance_report['COCKPIT_BEZEL_DISPLAY_ALERT']}")
    print(f"[INVERTER VALVE]: Propulsion System Enabled: {clearance_report['POWERTRAIN_PROPULSION_ALLOWED']}")
    print(f"[MAINFRAME PACKET CHANNEL]: Serializing Word: {clearance_report['UNIVAC_IX_36BIT_WORD']}")
    print("=======================================================================")
