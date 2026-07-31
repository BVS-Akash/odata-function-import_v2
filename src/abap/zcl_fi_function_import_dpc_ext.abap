" SEGW generated extension class for project ZFI_FUNCTION_IMPORT_DEMO.
" If your Gateway release chooses different generated type names, adjust only the MPC type references.
CLASS zcl_zfi_function_import_demo_dpc_ext DEFINITION INHERITING FROM zcl_zfi_function_import_demo_dpc CREATE PUBLIC.
  PUBLIC SECTION. METHODS /iwbep/if_mgw_appl_srv_runtime~execute_action REDEFINITION.
  PRIVATE SECTION.
    METHODS get_parameter IMPORTING it_parameter TYPE /iwbep/t_mgw_tech_pairs iv_name TYPE string RETURNING VALUE(rv_value) TYPE string.
    METHODS raise_business_error IMPORTING iv_message TYPE string RAISING /iwbep/cx_mgw_busi_exception.
ENDCLASS.
CLASS zcl_zfi_function_import_demo_dpc_ext IMPLEMENTATION.
  METHOD /iwbep/if_mgw_appl_srv_runtime~execute_action.
    CASE iv_action_name.
      WHEN 'ConvertCurrency'.
        TRY.
            DATA(ls_result) = NEW zcl_fi_currency_service( )->convert( iv_amount = CONV wrbtr( get_parameter( it_parameter = it_parameter iv_name = 'Amount' ) ) iv_from_currency = CONV waers( get_parameter( it_parameter = it_parameter iv_name = 'FromCurrency' ) ) iv_to_currency = CONV waers( get_parameter( it_parameter = it_parameter iv_name = 'ToCurrency' ) ) iv_date = CONV dats( get_parameter( it_parameter = it_parameter iv_name = 'ExchangeRateDate' ) ) ).
            DATA(ls_entity) = CORRESPONDING zcl_zfi_function_import_demo_mpc=>ts_currencyconversionresult( ls_result ).
            copy_data_to_ref( EXPORTING is_data = ls_entity CHANGING cr_data = er_data ).
          CATCH zcx_fi_function_import INTO DATA(lx_business). raise_business_error( lx_business->mv_message ).
          CATCH cx_root INTO DATA(lx_system). " LOG-POINT ID zfi_odata SUBKEY 'CURRENCY' FIELDS lx_system->get_text( ).
            RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
        ENDTRY.
      WHEN 'GetVendorOpenItems'.
        TRY.
            DATA(lt_items) = NEW zcl_fi_vendor_service( )->get_open_items( iv_company_code = CONV bukrs( get_parameter( it_parameter = it_parameter iv_name = 'CompanyCode' ) ) iv_vendor = CONV lifnr( |{ get_parameter( it_parameter = it_parameter iv_name = 'Vendor' ) ALPHA = IN }| ) iv_key_date = CONV dats( get_parameter( it_parameter = it_parameter iv_name = 'KeyDate' ) ) ).
            DATA(lt_entities) = VALUE zcl_zfi_function_import_demo_mpc=>tt_vendoropenitem( FOR ls_item IN lt_items ( CORRESPONDING #( ls_item ) ) ).
            copy_data_to_ref( EXPORTING is_data = lt_entities CHANGING cr_data = er_data ).
          CATCH zcx_fi_function_import INTO lx_business. raise_business_error( lx_business->mv_message ).
          CATCH cx_root INTO lx_system. " LOG-POINT ID zfi_odata SUBKEY 'VENDOR_ITEMS' FIELDS lx_system->get_text( ).
            RAISE EXCEPTION TYPE /iwbep/cx_mgw_tech_exception.
        ENDTRY.
      WHEN OTHERS. super->/iwbep/if_mgw_appl_srv_runtime~execute_action( EXPORTING iv_action_name = iv_action_name it_parameter = it_parameter IMPORTING er_data = er_data ).
    ENDCASE.
  ENDMETHOD.
  METHOD get_parameter. TRY. rv_value = it_parameter[ name = iv_name ]-value. CATCH cx_sy_itab_line_not_found. ENDTRY. ENDMETHOD.
  METHOD raise_business_error.
    DATA(lo_container) = me->mo_context->get_message_container( ). lo_container->add_message_text_only( iv_msg_type = 'E' iv_msg_text = iv_message ).
    RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception EXPORTING message_container = lo_container.
  ENDMETHOD.
ENDCLASS.
