#!/usr/bin/env python3
# ==============================================================================
# REVOLUTIONARY TECHNOLOGY COMPANY & UNIVERSITY OF WASHINGTON DEPARTMENT OF PHYSICS
# Module: mainframe_carver.py (Univac-IX 36-Bit Legacy Tape Extraction Engine)
# Core Framework: Numba-Accelerated Parallel 6-Bit FIELDATA Decoder Matrix
# ==============================================================================

import numpy as np
from numba import njit, prange

# Standard 6-Bit UNIVAC FIELDATA Character Mapping Array
# Index maps directly to the 6-bit binary integer state values
FIELDATA_TABLE = " _0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ)━━━━━(+=*$/',.·:"

@njit(parallel=True, fastmath=True)
def parallel_fieldata_carve(raw_bytes, word_count):
    """
    Numba-accelerated parallel loop executing 36-bit word reconstruction.
    Slices raw 8-bit data streams into legacy 6-bit character coordinates.
    """
    # Allocate a flat matrix space to store translated character index values
    output_indices = np.zeros(word_count * 6, dtype=np.uint8)
    
    for i in prange(word_count):
        # Calculate byte offsets (Every 36-bit word takes exactly 4.5 bytes on tape)
        byte_idx = (i * 9) // 2
        
        # Pull a clean 36-bit chunk out of the byte alignment window
        if (i % 2) == 0:
            word = (uint64(raw_bytes[byte_idx]) << 28) | \
                   (uint64(raw_bytes[byte_idx+1]) << 20) | \
                   (uint64(raw_bytes[byte_idx+2]) << 12) | \
                   (uint64(raw_bytes[byte_idx+3]) << 4)  | \
                   ((uint64(raw_bytes[byte_idx+4]) >> 4) & 0x0F)
        else:
            word = ((uint64(raw_bytes[byte_idx]) & 0x0F) << 32) | \
                   (uint64(raw_bytes[byte_idx+1]) << 24) | \
                   (uint64(raw_bytes[byte_idx+2]) << 16) | \
                   (uint64(raw_bytes[byte_idx+3]) << 8)  | \
                   uint64(raw_bytes[byte_idx+4])
        
        # Unpack the 36-bit word into six discrete 6-bit FIELDATA characters
        output_indices[i*6 + 0] = (word >> 30) & 0x3F
        output_indices[i*6 + 1] = (word >> 24) & 0x3F
        output_indices[i*6 + 2] = (word >> 18) & 0x3F
        output_indices[i*6 + 3] = (word >> 12) & 0x3F
        output_indices[i*6 + 4] = (word >> 6)  & 0x3F
        output_indices[i*6 + 5] = word & 0x3F

    return output_indices

def translate_tape_image(file_path):
    """
    Loads raw Uniservo 9-track tape files and translates them to text layers.
    """
    with open(file_path, "rb") as f:
        raw_data = np.frombuffer(f.read(), dtype=np.uint8)
    
    # Compute total complete 36-bit word blocks available
    total_words = (len(raw_data) * 2) // 9
    
    print(f"[MAINFRAME CORES] Carving {total_words} legacy 36-bit words from tape image...")
    indices = parallel_fieldata_carve(raw_data, total_words)
    
    # Construct string map from decoded indices
    decoded_chars = [FIELDATA_TABLE[idx] for idx in indices]
    return "".join(decoded_chars)

if __name__ == "__main__":
    print("=======================================================================")
    print("UNIVAC-IX FIELDATA PARALLEL EXTRACTION ENGINE OPERATIONAL")
    print("=======================================================================")
    # Executed loop returns structural coordinate vectors back to tool chains
