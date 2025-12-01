#!/bin/bash

REPORT="/tmp/cost_report_$(date +%F).txt"

echo "Cloud Cost Optimization Report - $(date)" > "$REPORT"
echo "================" >> "$REPORT"
echo "" >> "$REPORT"

# -------------------------
# Run AWS & get flag file
# -------------------------
AWS_FLAG_FILE=$(bash scripts/optimize_aws.sh "$REPORT")
AWS_STATUS=$(cat "$AWS_FLAG_FILE")

# -------------------------
# Run Azure & get flag file
# -------------------------
AZ_FLAG_FILE=$(bash scripts/optimize_azure.sh "$REPORT")
AZ_STATUS=$(cat "$AZ_FLAG_FILE")

# -------------------------
# Show summary to console
# -------------------------
echo "AWS Idle Resources: $AWS_STATUS"
echo "Azure Idle Resources: $AZ_STATUS"

# -------------------------
# Send email notification
# -------------------------
bash scripts/notify_email.sh "$REPORT" "$AWS_STATUS" "$AZ_STATUS"

echo "FINAL REPORT: $REPORT"
