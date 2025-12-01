#!/bin/bash

REPORT="$1"
DRY_RUN=true
AWS_FLAG_FILE="/tmp/aws_flag_$$.txt"

echo " AWS Optimization Report " >> "$REPORT"

AWS_IDLE=false

# Fetch idle instances (example logic)
IDLE_INSTANCES=$(aws cloudwatch get-metric-data \
    --metric-data-queries file://aws_cpu_query.json \
    --start-time "$(date -d '1 day ago' --utc +%FT%TZ)" \
    --end-time "$(date --utc +%FT%TZ)" \
    --query "MetricDataResults[].Id" --output text)

if [ -z "$IDLE_INSTANCES" ]; then
    echo "No idle AWS EC2 instances found." >> "$REPORT"
    echo "NO" > "$AWS_FLAG_FILE"
else
    echo "Idle AWS EC2 Instances:" >> "$REPORT"
    echo "$IDLE_INSTANCES" >> "$REPORT"

    AWS_IDLE=true
    echo "YES" > "$AWS_FLAG_FILE"

    if [ "$DRY_RUN" = false ]; then
        aws ec2 stop-instances --instance-ids $IDLE_INSTANCES >> "$REPORT"
        echo "Stopped: $IDLE_INSTANCES" >> "$REPORT"
    else
        echo "DRY RUN — No AWS instances stopped." >> "$REPORT"
    fi
fi

echo "" >> "$REPORT"

echo "$AWS_FLAG_FILE"
