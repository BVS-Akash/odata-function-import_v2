# SEGW model and generation recipe

## 1. Project

In transaction `SEGW`, create project `ZFI_FUNCTION_IMPORT_DEMO`, description “FI Function Import Demo”, package `ZFI_ODATA_DEMO` (or a transportable customer package). Choose **Create**. Generate runtime artifacts after the model is complete; SEGW generates MPC, MPC_EXT, DPC and DPC_EXT classes. Keep generated MPC/DPC untouched and place custom code only in `*_MPC_EXT`/`*_DPC_EXT`.

## 2. Entity types and sets

Create entity type `CurrencyConversionResult` and set `CurrencyConversionResults`. Add properties:

| Property | EDM type | Key | ABAP/DDIC recommendation |
|---|---|---:|---|
| Amount | Edm.Decimal (16,2) | no | `WRBTR` / `ZFI_S_CURRENCY_RESULT-AMOUNT` |
| FromCurrency | Edm.String (3) | yes | `WAERS` |
| ToCurrency | Edm.String (3) | yes | `WAERS` |
| ExchangeRate | Edm.Decimal (15,9) | no | `UKURS` compatible decimal |
| ConvertedAmount | Edm.Decimal (16,2) | no | `WRBTR` |
| ExchangeRateDate | Edm.DateTime | yes | `DATS` |

Create entity type `VendorOpenItem` and set `VendorOpenItems`:

| Property | EDM type | Key | DDIC recommendation |
|---|---|---:|---|
| CompanyCode | Edm.String (4) | yes | `BUKRS` |
| Vendor | Edm.String (10) | yes | `LIFNR` (ALPHA external format) |
| AccountingDocument | Edm.String (10) | yes | `BELNR_D` |
| FiscalYear | Edm.String (4) | yes | `GJAHR` |
| LineItem | Edm.String (3) | yes | `BUZEI` |
| DocumentType | Edm.String (2) | no | `BLART` |
| DocumentDate, PostingDate, DueDate | Edm.DateTime | no | `DATS` |
| Amount | Edm.Decimal (16,2) | no | `WRBTR` |
| Currency | Edm.String (3) | no | `WAERS` |
| DebitCreditIndicator | Edm.String (1) | no | `SHKZG` |
| Assignment | Edm.String (18) | no | `ZUONR` |
| Reference | Edm.String (16) | no | `XBLNR` |
| BusinessArea | Edm.String (4) | no | `GSBER` |
| ProfitCenter | Edm.String (10) | no | `PRCTR` |

Create/recommend matching structures `ZFI_S_CURRENCY_RESULT` and `ZFI_S_VENDOR_OPEN_ITEM` for internal service contracts; map SEGW properties to their components. Keys are technical metadata keys and do not imply callers should use entity CRUD.

## 3. Function Imports

Create each node under **Data Model → Function Imports**:

| Setting | ConvertCurrency | GetVendorOpenItems |
|---|---|---|
| HTTP method | GET | GET |
| Return type | `CurrencyConversionResult` | `VendorOpenItem` |
| Entity set | `CurrencyConversionResults` | `VendorOpenItems` |
| Cardinality | 0..1 | 0..n |
| Parameter 1 | Amount / Edm.Decimal | CompanyCode / Edm.String |
| Parameter 2 | FromCurrency / Edm.String | Vendor / Edm.String |
| Parameter 3 | ToCurrency / Edm.String | KeyDate / Edm.DateTime |
| Parameter 4 | ExchangeRateDate / Edm.DateTime | — |

Set maxlengths and precision/scale consistently. Generate runtime artifacts, activate, open `*_MPC_EXT`, and redefine `DEFINE` only if metadata cannot be modelled in SEGW. No custom MPC_EXT code is required for this model. Redefine `EXECUTE_ACTION` in `*_DPC_EXT`; SEGW routes Function Imports to it by `IV_ACTION_NAME`.

## Metadata lifecycle

The model is stored in SEGW, runtime generation creates provider classes, `$metadata` advertises `FunctionImport` entries, Gateway routes the request to `EXECUTE_ACTION`, and `COPY_DATA_TO_REF` serializes the mapped ABAP structure/table according to the entity metadata.
