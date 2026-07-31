# API reference

Base path: `/sap/opu/odata/sap/ZFI_FUNCTION_IMPORT_DEMO_SRV`. Request `$metadata` first; it is the authoritative contract for the generated service.

## ConvertCurrency

Converts one amount using the rate maintained for the requested date. This is a read-only Function Import, so it uses `GET` and returns cardinality `0..1`.

```http
GET .../ConvertCurrency?Amount='100.00'&FromCurrency='USD'&ToCurrency='EUR'&ExchangeRateDate=datetime'2026-07-28T00:00:00'
Accept: application/json
```

| Parameter | OData type | Required | Description |
|---|---|---:|---|
| Amount | Edm.Decimal | yes | Amount in the source currency |
| FromCurrency | Edm.String(3) | yes | ISO/SAP currency key |
| ToCurrency | Edm.String(3) | yes | ISO/SAP currency key |
| ExchangeRateDate | Edm.DateTime | yes | Rate validity date |

Response fields are `Amount`, `FromCurrency`, `ToCurrency`, `ExchangeRate`, `ConvertedAmount`, and `ExchangeRateDate`. A missing rate or invalid input is an OData business error. The exact OData error code/status is Gateway-SP and error-mapping dependent; clients must consume the standard OData `error.message.value` field, not parse a free-text HTTP response.

## GetVendorOpenItems

Returns open vendor items for one vendor/company-code/key-date combination. It is read-only and returns cardinality `0..n`.

```http
GET .../GetVendorOpenItems?CompanyCode='1000'&Vendor='0000100000'&KeyDate=datetime'2026-07-28T00:00:00'
Accept: application/json
```

| Parameter | OData type | Required | Description |
|---|---|---:|---|
| CompanyCode | Edm.String(4) | yes | Company code subject to FI authorization |
| Vendor | Edm.String(10) | yes | Vendor number; callers may use external format |
| KeyDate | Edm.DateTime | yes | Retrieval/as-of key date |

Each `VendorOpenItem` has document identity (`CompanyCode`, `Vendor`, `AccountingDocument`, `FiscalYear`, `LineItem`), document dates/type, amount/currency/sign, and selected accounting references. See [../segw/model.md](../segw/model.md) for the full field model.

## Client notes

Use the literal syntax exposed by your service metadata. OData V2 normally uses `datetime'YYYY-MM-DDT00:00:00'`; URL-encode all values in real clients. A future high-volume implementation should introduce a documented maximum result size and paging contract before public exposure.
