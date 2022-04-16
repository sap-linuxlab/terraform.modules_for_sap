# Testing

## Smoke Tests matrix: Terraform Validate

GitHub Actions will perform Terraform Validate for each commit to the Git repository.

**Note:** The GitHub Action will loop according to the SAP Solution Scenario and the Infrastructure Platform, if a Terraform Template does not exist for this combination then it will display as a `fail`.
