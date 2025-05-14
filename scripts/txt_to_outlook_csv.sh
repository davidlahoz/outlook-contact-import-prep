#!/bin/bash
clear
echo ""
echo "📄 This script converts a TXT-based contact list into an Outlook-compatible CSV file."
echo "⚠️ Due the nature of TXT files, the script does not perform any format check. Input data should be manually reviewed first"
echo "🔹 Input file: contacts.txt"
echo "🔹 Output file: TXTOutlookContacts.csv"
echo "🔹 Each contact must have exactly 5 lines in the following order:"
echo ""
echo "❗ Important:"
echo "   ➤ Do NOT use special characters like ä, ö, ü, é, ñ, ø,  etc."
echo "   ➤ Only standard Latin characters (A-Z, a-z) are supported in the output."
echo ""
echo "    Line 1: Full name"
echo "    Line 2: Company name"
echo "    Line 3: Job title"
echo "    Line 4: Email address"
echo "    Line 5: Phone number (or two phone numbers separated by /)"
echo "    <next contact with no empty-line or end of the file>"
echo ""
read -p "Press Enter to continue..." pause
clear

INPUT="contacts.txt"
OUTPUT="TXTOutlookContacts.csv"


# Initialize CSV with Outlook-compatible BOM and header
printf '\xEF\xBB\xBF' > "$OUTPUT"
echo '"First Name","Last Name","Company","Job Title","E-mail Address","Business Phone","Mobile Phone","Category"' >> "$OUTPUT"

dos2unix "$INPUT" 2>/dev/null

echo ""
echo "⏳ Processing contacts..."
echo ""

count=0
while IFS= read -r line || [[ -n "$line" ]]; do
  # Trim surrounding whitespace and quotes
  cleaned=$(echo "$line" | sed 's/^["[:space:]]*//;s/["[:space:]]*$//')
  contact[$count]="$cleaned"
  ((count++))

  if [[ $count -eq 5 ]]; then
    Name="${contact[0]}"
    Company="${contact[1]}"
    Position="${contact[2]}"
    Email="${contact[3]}"
    Phones="${contact[4]}"

    if [[ -z "$Email" ]]; then
      count=0
      unset contact
      continue
    fi

    # Extract first and last name from full name
    fname="$(echo "$Name" | awk '{print $1}')"
    lname="$(echo "$Name" | cut -d' ' -f2-)"
    IFS='/' read -ra phone_array <<< "$Phones"

    echo "Processing: $Name <$Email>"
    echo "\"$fname\",\"$lname\",\"$Company\",\"$Position\",\"$Email\",\"${phone_array[0]}\",\"${phone_array[1]}\",\"OutlookContactImportPrep\"" >> "$OUTPUT"

    count=0
    unset contact
    declare -a contact
  fi
done < "$INPUT"

echo ""
echo "✅ Generated: $OUTPUT"