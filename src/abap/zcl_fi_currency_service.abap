CLASS zcl_fi_currency_service DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_result,
             amount              TYPE wrbtr,
             from_currency       TYPE waers,
             to_currency         TYPE waers,
             exchange_rate       TYPE ukurs,
             converted_amount    TYPE wrbtr,
             exchange_rate_date  TYPE dats,
           END OF ty_result.
    METHODS constructor IMPORTING io_currency_api TYPE REF TO zif_fi_currency_api OPTIONAL.
    METHODS convert IMPORTING iv_amount TYPE wrbtr iv_from_currency TYPE waers iv_to_currency TYPE waers iv_date TYPE dats
                    RETURNING VALUE(rs_result) TYPE ty_result RAISING zcx_fi_function_import.
  PRIVATE SECTION.
    DATA mo_currency_api TYPE REF TO zif_fi_currency_api.
ENDCLASS.

CLASS zcl_fi_currency_service IMPLEMENTATION.
  METHOD constructor.
    mo_currency_api = COND #( WHEN io_currency_api IS BOUND THEN io_currency_api ELSE NEW zcl_fi_currency_api( ) ).
  ENDMETHOD.
  METHOD convert.
    IF iv_amount IS INITIAL OR iv_from_currency IS INITIAL OR iv_to_currency IS INITIAL OR iv_date IS INITIAL.
      RAISE EXCEPTION NEW zcx_fi_function_import( `Amount, currencies, and exchange-rate date are mandatory.` ).
    ENDIF.
    IF iv_from_currency = iv_to_currency.
      rs_result = VALUE #( amount = iv_amount from_currency = iv_from_currency to_currency = iv_to_currency exchange_rate = 1 converted_amount = iv_amount exchange_rate_date = iv_date ).
      RETURN.
    ENDIF.
    DATA(ls_conversion) = mo_currency_api->convert( iv_amount = iv_amount iv_from_currency = iv_from_currency iv_to_currency = iv_to_currency iv_date = iv_date ).
    rs_result = VALUE #( amount = iv_amount from_currency = iv_from_currency to_currency = iv_to_currency exchange_rate = ls_conversion-exchange_rate converted_amount = ls_conversion-converted_amount exchange_rate_date = iv_date ).
  ENDMETHOD.
ENDCLASS.
