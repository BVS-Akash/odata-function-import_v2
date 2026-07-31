# Deployment guide

1. Create DDIC structures/classes in transportable package `ZFI_ODATA_DEMO`; activate exception/interface, adapters, services, SEGW model, generated runtime, then DPC_EXT.
2. Generate/activate SEGW runtime artifacts; validate `$metadata`.
3. Add `ZFI_FUNCTION_IMPORT_DEMO_SRV` in `/IWFND/MAINT_SERVICE`, select backend alias, assign transport, and add service (local alias for embedded deployment).
4. Assign Gateway service and backend FI authorizations. Clear metadata caches after transport (`/IWFND/CACHE_CLEANUP` and backend equivalent).
5. Smoke test using `/IWFND/GW_CLIENT` and move DEV → QA → PRD through normal transports.

Do not activate the BSIK adapter in production before FI signs off the implementation.
