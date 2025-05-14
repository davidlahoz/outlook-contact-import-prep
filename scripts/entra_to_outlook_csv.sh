#!/bin/bash
clear
echo ""
echo "📄 This script converts EntraID CSV exports to an Outlook-compatible CSV format."
echo "🔹 Ensure your input file is named: EntraExport.csv"
echo "🔹 Output file will be: EntraCSVOutlookContacts.csv"
echo "🔹 Required columns in the input (you can use a full user export from Entra):"
echo "   ➤ givenName, surname, mail, jobTitle, telephoneNumber, mobilePhone, companyName"
echo ""
echo "❗ Important:"
echo "   ➤ Do NOT use special characters like ä, ö, ü, é, ñ, ø, etc."
echo "   ➤ Only standard Latin characters (A-Z, a-z) are supported in the output."
echo ""
read -p "Press Enter to continue..." pause
clear

INPUT="EntraExport.csv"
OUTPUT="EntraCSVOutlookContacts.csv"

echo ""
echo "⏳ Processing contacts..."
echo ""

awk -F',' '
BEGIN {
  OFS=","
  print "\xEF\xBB\xBF\"First Name\",\"Last Name\",\"Company\",\"Job Title\",\"E-mail Address\",\"Business Phone\",\"Mobile Phone\",\"Category\""
}
NR==1 {
  for (i=1; i<=NF; i++) {
    col[$i] = i
  }
  next
}
{
  fname = $col["givenName"]; gsub(/"/, "", fname)
  display = $col["displayName"]; gsub(/"/, "", display)
  split(display, name_parts, " ")
  lname = name_parts[length(name_parts)]

  company = $col["companyName"]; gsub(/"/, "", company)
  title = $col["jobTitle"]; gsub(/"/, "", title)
  email = $col["mail"]; gsub(/"/, "", email)
  phone1 = $col["telephoneNumber"]; gsub(/["'\''"]/, "", phone1)
  phone2 = $col["mobilePhone"]; gsub(/["'\''"]/, "", phone2)

  if (fname == "" || lname == "" || company == "" || title == "" || email == "") {
    print "❌ Error: Missing required field near entry:"
    print "   Name: " display
    print "   Email: " email
    print "   Title: " title
    print "   Company: " company
    print "   Given Name: " fname
    print "   --> Please check the input file and try again."
    exit 1
  }

  print "\"" fname "\",\"" lname "\",\"" company "\",\"" title "\",\"" email "\",\"" phone1 "\",\"" phone2 "\",\"OutlookContactImportPrep\""
}' "$INPUT" > "$OUTPUT"

echo ""
echo "✅ Converted: $OUTPUT"
