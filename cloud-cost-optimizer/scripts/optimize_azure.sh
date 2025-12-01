#!/bin/bash

REPORT="$1"
DRY_RUN=true
AZ_FLAG_FILE="/tmp/az_flag_$$.txt"

echo " Azure Optimization Report " >> "$REPORT"

AZURE_IDLE=false

AZ_VMS=$(az vm list --query "[?powerState=='VM running'].id" -o tsv)

if [ -z "$AZ_VMS" ]; then
    echo "No running Azure VMs found." >> "$REPORT"
    echo "NO" > "$AZ_FLAG_FILE"
else
    for vm in $AZ_VMS; do

        CPU=$(az monitor metrics list \
            --resource "$vm" \
            --metric "Percentage CPU" \
            --interval PT1H \
            --query "value[].timeseries[].data[-1].average" -o tsv)

        if [[ "$CPU" < 5 ]]; then
            echo "Idle Azure VM Found: $vm | CPU: ${CPU}%" >> "$REPORT"

            AZURE_IDLE=true
            echo "YES" > "$AZ_FLAG_FILE"

            if [ "$DRY_RUN" = false ]; then
                az vm deallocate --ids "$vm" >> "$REPORT"
                echo "Deallocated: $vm" >> "$REPORT"
            else
                echo "DRY RUN — Azure VMs not stopped." >> "$REPORT"
            fi
        fi
    done
fi

echo "" >> "$REPORT"

echo "$AZ_FLAG_FILE"
