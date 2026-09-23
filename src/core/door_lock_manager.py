#!/usr/bin/env python3
# ==============================================================================
# REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
# Module: door_lock_manager.py (High-Speed Safety Door Interlock Core)
# Reference Architecture: Teletank Master 32-Bit Control Register Format
# ==============================================================================

class CopoDoorLockController:
    def __init__(self):
        # 32-Bit Parallel Register Mappings derived from Teletank specification base
        self.REG_BIT_DOORS_LOCKED  = 0x00000200  # Bit 9 - Forces solid-state deadbolt engagement
        self.REG_BIT_CONTAINMENT   = 0x00000100  # System exception safety trap bit
        self.AUTO_LOCK_SPEED_MPH   = 15.0

    def evaluate_lock_state(self, current_speed_mph: float, door_ajar_flag: bool, system_fault: bool) -> dict:
        """
        Processes chassis velocity variables using exact fixed-point transitions
        to execute immediate lock/unlock cycles without system calculation drift.
        """
        engage_deadbolts = False
        lock_status_msg = "DOORS_UNLOCKED_ACCESS_NOMINAL"
        univac_response_code = 0x000
        
        # Core velocity and constraint safety calculations
        if system_fault:
            # System error or impact flagged: bypass lock loops and force release for driver escape
            engage_deadbolts = False
            lock_status_msg = "SAFETY_FORCE_UNLOCK_EMERGENCY_CONTAINMENT_BYPASS"
            univac_response_code = 0x7E0
            
        elif not door_ajar_flag and current_speed_mph > self.AUTO_LOCK_SPEED_MPH:
            # Car is moving past 15 mph: actuate high-speed safety deadbolts automatically
            engage_deadbolts = True
            lock_status_msg = "AUTOMATIC_MOTION_LOCKS_ACTIVE_DEADBOLTS_CHARGED"
            univac_response_code = 0x1A4  # Mapped lock status display indicator ID
            
        # Pack statistics inside the un-truncated 108-bit tracking system register configuration
        # Bits 72-107: Lock Command Gate | Bits 36-71: Speed Value | Bits 0-35: Alert Index
        lock_bit = 1 if engage_deadbolts else 0
        speed_fixed = int(current_speed_mph * 100)
        stacked_word = (lock_bit << 72) | (speed_fixed << 36) | univac_response_code
        
        return {
            "SOLENOID_RELAY_COMMAND_ACTIVE": engage_deadbolts,
            "CHASSIS_SECURITY_STATUS": lock_status_msg,
            "UNIVAC_IX_36BIT_WORD": f"0x{(stacked_word >> 72) & 0x7FFFFFFFF:09X}"
        }

if __name__ == "__main__":
    lock_core = CopoDoorLockController()
    print("=======================================================================")
    print("UNIVAC-IX STRUCTURAL LOCK CONTROLLER ACTIVE (LATCH-GATE-IX)")
    print("=======================================================================")
    
    # Simulation: Car accelerates past staging lanes onto track straightaway at 45 mph
    test_speed = 45.2
    test_door  = False  # Doors tightly shut
    test_fault = False
    
    command_block = lock_core.evaluate_lock_state(test_speed, test_door, test_fault)
    print(f"[SPEED INGEST] Velocity: {test_speed} MPH | Door Ajar: {test_door}")
    print(f"[SECURITY TRACKER STATE]: {command_block['CHASSIS_SECURITY_STATUS']}")
    print(f"[SOLENOID INTERLOCK]: Actuate Mechanical Lock Bolts: {command_block['SOLENOID_RELAY_COMMAND_ACTIVE']}")
    print(f"[MAINFRAME PACKET CHANNEL]: Serializing Word: {command_block['UNIVAC_IX_36BIT_WORD']}")
    print("=======================================================================")
