CLASS zcl_fi_currency_api DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_fi_currency_api.
ENDCLASS.

CLASS zcl_fi_currency_api IMPLEMENTATION.
  METHOD zif_fi_currency_api~convert.
    " Central wrapper keeps release/customer-specific currency access outside Gateway.
    CALL FUNCTION 'CONVERT_TO_LOCAL_CURRENCY'
      EXPORTING date             = iv_date
                foreign_amount   = iv_amount
                foreign_currency = iv_from_currency
                local_currency   = iv_to_currency
      IMPORTING exchange_rate    = rs_result-exchange_rate
                local_amount     = rs_result-converted_amount
      EXCEPTIONS no_rate_found   = 1
                 overflow        = 2
                 no_factors_found = 3
                 no_spread_found = 4
                 derived_2_times = 5
                 OTHERS          = 6.
    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW zcx_fi_function_import(
        |No usable exchange rate exists for { iv_from_currency }/{ iv_to_currency } on { iv_date }.| ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
