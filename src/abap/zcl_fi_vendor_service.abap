CLASS zcl_fi_vendor_service DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES tty_open_items TYPE zcl_fi_vendor_repository=>tty_open_items.
    METHODS constructor IMPORTING io_repository TYPE REF TO zcl_fi_vendor_repository OPTIONAL.
    METHODS get_open_items IMPORTING iv_company_code TYPE bukrs iv_vendor TYPE lifnr iv_key_date TYPE dats
                           RETURNING VALUE(rt_items) TYPE tty_open_items RAISING zcx_fi_function_import.
  PRIVATE SECTION. DATA mo_repository TYPE REF TO zcl_fi_vendor_repository.
ENDCLASS.
CLASS zcl_fi_vendor_service IMPLEMENTATION.
  METHOD constructor. mo_repository = COND #( WHEN io_repository IS BOUND THEN io_repository ELSE NEW zcl_fi_vendor_repository( ) ). ENDMETHOD.
  METHOD get_open_items.
    IF iv_company_code IS INITIAL OR iv_vendor IS INITIAL OR iv_key_date IS INITIAL.
      RAISE EXCEPTION NEW zcx_fi_function_import( `CompanyCode, Vendor, and KeyDate are mandatory.` ).
    ENDIF.
    SELECT SINGLE FROM t001 FIELDS @abap_true WHERE bukrs = @iv_company_code INTO @DATA(lv_company_exists).
    IF lv_company_exists IS INITIAL. RAISE EXCEPTION NEW zcx_fi_function_import( |Company code { iv_company_code } does not exist.| ). ENDIF.
    SELECT SINGLE FROM lfa1 FIELDS @abap_true WHERE lifnr = @iv_vendor INTO @DATA(lv_vendor_exists).
    IF lv_vendor_exists IS INITIAL. RAISE EXCEPTION NEW zcx_fi_function_import( |Vendor { iv_vendor } does not exist.| ). ENDIF.
    " Add AUTHORITY-CHECK for the organisation's approved FI authorization object here.
    rt_items = mo_repository->get_open_items( iv_company_code = iv_company_code iv_vendor = iv_vendor iv_key_date = iv_key_date ).
    IF rt_items IS INITIAL. RAISE EXCEPTION NEW zcx_fi_function_import( `No vendor open items were found for the supplied key date.` ). ENDIF.
  ENDMETHOD.
ENDCLASS.
