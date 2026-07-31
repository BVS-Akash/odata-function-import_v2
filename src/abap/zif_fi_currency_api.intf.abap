INTERFACE zif_fi_currency_api PUBLIC.
  TYPES: BEGIN OF ty_result,
           exchange_rate    TYPE ukurs,
           converted_amount TYPE wrbtr,
         END OF ty_result.

  METHODS convert
    IMPORTING iv_amount       TYPE wrbtr
              iv_from_currency TYPE waers
              iv_to_currency   TYPE waers
              iv_date          TYPE dats
    RETURNING VALUE(rs_result) TYPE ty_result
    RAISING   zcx_fi_function_import.
ENDINTERFACE.
