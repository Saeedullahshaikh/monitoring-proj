#!/bin/bash

REPORT="$1"
AWS_STATUS="$2"
AZ_STATUS="$3"

SMTP_SERVER="smtp.gmail.com"
SMTP_PORT=587
SMTP_USER="your-email@gmail.com"
SMTP_PASS="your-app-password"
TARGET_EMAIL="recipient@example.com"

# Build subject based on which cloud had data
if [[ "$AWS_STATUS" == "YES" && "$AZ_STATUS" == "YES" ]]; then
    SUBJECT="AWS + Azure Cost Optimization Report"
elif [[ "$AWS_STATUS" == "YES" ]]; then
    SUBJECT="AWS Cost Optimization Report"
elif [[ "$AZ_STATUS" == "YES" ]]; then
    SUBJECT="Azure Cost Optimization Report"
else
    SUBJECT="Cloud Report (No Idle Resources)"
fi

python3 <<EOF
import smtplib
from email.mime.text import MIMEText

with open("$REPORT") as f:
    body = f.read()

msg = MIMEText(body)
msg['Subject'] = "$SUBJECT"
msg['From'] = "$SMTP_USER"
msg['To'] = "$TARGET_EMAIL"

server = smtplib.SMTP("$SMTP_SERVER", $SMTP_PORT)
server.starttls()
server.login("$SMTP_USER", "$SMTP_PASS")
server.sendmail("$SMTP_USER", "$TARGET_EMAIL", msg.as_string())
server.quit()
EOF

echo "Email sent with subject: $SUBJECT"
