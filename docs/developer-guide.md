# Developer guide

`EXECUTE_ACTION` identifies `IV_ACTION_NAME`, reads `IT_PARAMETER`, delegates to a service, maps the result, and calls `COPY_DATA_TO_REF`. No FI SQL belongs in DPC_EXT. Parameter names must match SEGW exactly; inspect `IT_PARAMETER` because date formatting varies by Gateway SP level.

Breakpoints: `ZCL_ZFI_FUNCTION_IMPORT_DPC_EXT=>/IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION`, `ZCL_FI_CURRENCY_API=>ZIF_FI_CURRENCY_API~CONVERT`, `ZCL_FI_VENDOR_REPOSITORY=>GET_OPEN_ITEMS`. Use `/IWFND/ERROR_LOG` and `/IWBEP/ERROR_LOG`.

Never modify generated MPC/DPC. Regenerate carefully after model changes and retain only extension-class code. Unit-test validation, same-currency conversion, no-rate mapping, authorization denial, and repository mapping.
