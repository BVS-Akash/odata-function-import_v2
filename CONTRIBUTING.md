# Contributing

Issues and pull requests are welcome for documentation, SAP Gateway compatibility notes, test cases, and safe extension points.

Before submitting:

1. Keep generated SEGW classes out of the repository; place custom logic in `*_EXT` classes and dedicated services.
2. Use ABAP 7.40-compatible, Clean ABAP-style syntax and keep FI business logic out of `DPC_EXT`.
3. Do not add customer data, real service URLs, credentials, screenshots containing sensitive values, or production transport files.
4. Update the model/API documentation and sample responses whenever the OData contract changes.
5. Test `$metadata`, both success paths, and relevant error paths in a non-production Gateway system.

By contributing, you agree that your contributions are licensed under the repository’s MIT License.
