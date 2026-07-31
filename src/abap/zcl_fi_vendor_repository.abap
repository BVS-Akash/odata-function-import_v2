CLASS zcl_fi_vendor_repository DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_open_item,
             company_code TYPE bukrs, vendor TYPE lifnr, accounting_document TYPE belnr_d, fiscal_year TYPE gjahr, line_item TYPE buzei,
             document_type TYPE blart, document_date TYPE bldat, posting_date TYPE budat, due_date TYPE faedt, amount TYPE wrbtr,
             currency TYPE waers, debit_credit_indicator TYPE shkzg, assignment TYPE zuonr, reference TYPE xblnr,
             business_area TYPE gsber, profit_center TYPE prctr,
           END OF ty_open_item,
           tty_open_items TYPE STANDARD TABLE OF ty_open_item WITH EMPTY KEY.
    METHODS get_open_items IMPORTING iv_company_code TYPE bukrs iv_vendor TYPE lifnr iv_key_date TYPE dats
                           RETURNING VALUE(rt_items) TYPE tty_open_items.
ENDCLASS.

CLASS zcl_fi_vendor_repository IMPLEMENTATION.
  METHOD get_open_items.
    " BSIK is the ECC open-item index. Validate release/index policy with FI before productive use.
    " For special G/L, cleared-at-date semantics, and high volume, replace this seam with an approved FI API.
    SELECT FROM bsik AS i
      INNER JOIN bkpf AS h ON h~bukrs = i~bukrs AND h~belnr = i~belnr AND h~gjahr = i~gjahr
      FIELDS i~bukrs AS company_code, i~lifnr AS vendor, i~belnr AS accounting_document, i~gjahr AS fiscal_year, i~buzei AS line_item,
             h~blart AS document_type, h~bldat AS document_date, h~budat AS posting_date, i~faedt AS due_date, i~wrbtr AS amount,
             i~waers AS currency, i~shkzg AS debit_credit_indicator, i~zuonr AS assignment, i~xblnr AS reference,
             i~gsber AS business_area, i~prctr AS profit_center
      WHERE i~bukrs = @iv_company_code AND i~lifnr = @iv_vendor AND h~budat <= @iv_key_date
      INTO TABLE @rt_items.
  ENDMETHOD.
ENDCLASS.
