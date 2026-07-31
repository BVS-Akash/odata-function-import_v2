# Testing guide

Use `/IWFND/GW_CLIENT` or Postman with a valid SAP session. Start with `$metadata`, then run the supplied requests.

| Scenario | Expected |
|---|---|
| Valid conversion | 200, result entity |
| Missing rate/mandatory parameter | OData business error |
| Valid vendor with items | 200, `results` collection |
| Invalid company/vendor or no items | business error |
| Unauthorized company code | 403/policy response |

Use test data only. Assert keys, signs, dates, currency, totals, and FI-approved semantics. Inspect both Gateway logs after negative tests.
