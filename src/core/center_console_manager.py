#!/usr/bin/env python3
# ==============================================================================
# REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
# Module: center_console_manager.py (1969 Control Lever Interface Driver)
# Reference Architecture: Teletank Master 32-Bit Control Register Format
# ==============================================================================

class CopoCenterConsoleManager:
    def __init__(self):
        # 32-Bit Parallel Register Mappings derived from Teletank specification base
        self.REG_BIT_HVAC_COOL = 0x00080000  # Fires SiC cooling loop gates
        self.REG_BIT_HVAC_HEAT = 0x00040000  # Fires warming current polarity loop
        self.FIXED_POINT_VOLUME = 1000

    def parse_slider_positions(self, hvac_lever_ohms: int, radio_pot_ohms: int) -> dict:
        """
        Translates physical 1969 rheostat impedance resistance values into clean
        hexadecimal register commands without floating-point tracking bugs.
        """
        # Map mechanical 1969 climate slider position to digital state flags
        # Lower resistance indicates sliding the lever all the way over to maximum cool
        if hvac_lever_ohms < 250:
            active_hvac_bitmask = self.REG_BIT_HVAC_COOL
            mode_string = "COMMAND_MAX_PELTIER_REFRIGERATION"
            univac_mode_code = 0x1E0
        elif hvac_lever_ohms > 750:
            active_hvac_bitmask = self.REG_BIT_HVAC_HEAT
            mode_string = "COMMAND_MAX_PELTIER_THERMAL_WARMING"
            univac_mode_code = 0x2F1
        else:
            active_hvac_bitmask = 0x00
            mode_string = "CLIMATE_SYSTEM_IDLE"
            univac_mode_code = 0x000
            
        # Convert mechanical radio potentiometer turn angle to scaled gain value
        scaled_audio_volume = (radio_pot_ohms * self.FIXED_POINT_VOLUME) // 1024
        
        # Pack records inside our un-truncated 108-bit tracking system register configuration
        # Bits 72-107: Audio Gain | Bits 36-71: HVAC Bitmask | Bits 0-35: Alert Index
        stacked_word = (scaled_audio_volume << 72) | (active_hvac_bitmask << 36) | univac_mode_code
        
        return {
            "CONSOLE_CLIMATE_ACTION": mode_string,
            "BOSE_AMP_GAIN_INDEX": scaled_audio_volume,
            "ACTIVE_REGISTER_HEX": hex(active_hvac_bitmask),
            "UNIVAC_IX_36BIT_WORD": f"0x{(stacked_word >> 72) & 0x7FFFFFFFF:09X}"
        }

if __name__ == "__main__":
    console_manager = CopoCenterConsoleManager()
    print("=======================================================================")
    print("UNIVAC-IX ACCESSORY AUX BUS MANAGER RUNNING (1969 CONSOLE-IX)")
    print("=======================================================================")
    
    # Simulation: Driver pulls the 1969 lever all the way left to full cold air settings
    mock_lever_resistance = 115   # Triggers max refrigeration code rule
    mock_volume_dial_pot  = 640   # Volume knob turned past half
    
    status_report = console_manager.parse_slider_positions(mock_lever_resistance, mock_volume_dial_pot)
    print(f"[RHEOSTAT INGEST] Lever Impedance: {mock_lever_resistance} Ohms | Audio Knob: {mock_volume_dial_pot} Ohms")
    print(f"[CONSOLE LOG]: {status_report['CONSOLE_CLIMATE_ACTION']}")
    print(f"[AUDIO OUTPUT]: Bose Amp Scaled Volume Target Set To: {status_report['BOSE_AMP_GAIN_INDEX']}")
    print(f"[REGISTER ASSIGN]: Writing Bus Line Register: {status_report['ACTIVE_REGISTER_HEX']}")
    print(f"[MAINFRAME PACKET CHANNEL]: Serializing Packet Word: {status_report['UNIVAC_IX_36BIT_WORD']}")
    print("=======================================================================")
