CLASS zcx_fi_function_import DEFINITION
  PUBLIC FINAL CREATE PUBLIC
  INHERITING FROM cx_static_check.
  PUBLIC SECTION.
    DATA mv_message TYPE string READ-ONLY.
    METHODS constructor IMPORTING iv_message TYPE string.
ENDCLASS.

CLASS zcx_fi_function_import IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    mv_message = iv_message.
  ENDMETHOD.
ENDCLASS.
