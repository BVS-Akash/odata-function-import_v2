# Best practices and lessons learned

Function Imports are stable domain-operation contracts, not a shortcut for arbitrary SQL. Currency conversion belongs to FI policy: factors, decimals, quotation, triangulation, and missing-rate behavior must be tested with FI data. Open-item access needs authorization, privacy, volume, special G/L, and key-date semantics approved before production use.
