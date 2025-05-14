

# Outlook Contact Import Prep

![License](https://img.shields.io/badge/license-GPLv3-blue.svg)
![Shell](https://img.shields.io/badge/shell-Bash-lightgrey.svg)
![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-brightgreen.svg)
![Encoding](https://img.shields.io/badge/output-UTF--8%20BOM-important.svg)

This project contains two shell scripts to convert contact data into Outlook-compatible CSV files. It supports both structured `.txt` contact lists and Entra ID `.csv` user exports.



## Features

- Converts structured TXT files (one contact per 5 lines) into Outlook CSV format
- Converts Microsoft Entra ID CSV exports into Outlook CSV format
- Adds UTF-8 BOM for Excel and Outlook compatibility
- Validates required fields (name, email, title, company) and halts on errors
- Outputs clean CSV files ready for import into Outlook or Excel

## Input Formats

### TXT Format (contacts.txt)
Note: Due the nature of TXT files and lack of reliability in that case, the script does not perform any format check. Input data should be manually reviewed first.
Each contact must be exactly 5 lines:
1. Full name
2. Company
3. Job title
4. Email
5. Phone number (or two numbers separated by `/`)

Only standard Latin characters (A-Z, a-z) are supported. Avoid using characters like `ä`, `ö`, `ü`, etc.

### Entra Export (EntraExport.csv)
Use a full user export from Microsoft Entra and ensure the following columns exist:
- `givenName`
- `surname`
- `mail`
- `jobTitle`
- `telephoneNumber`
- `mobilePhone`
- `companyName`
- `displayName`

## Output

Both scripts generate a CSV file with the following columns:
```
First Name,Last Name,Company,Job Title,E-mail Address,Business Phone,Mobile Phone,Category
```


⚙️ **Default Category Tag**


The `Category` column in the output CSV is always set to `OutlookContactImportPrep` by default.

This serves as a tag to help easily filter or group imported contacts within Outlook.

You can change the default value by editing the following lines:
- `entra_to_outlook_csv.sh`: line 58
- `txt_to_outlook_csv.sh`: line 64

## Usage

### Convert TXT to Outlook CSV

```bash
chmod +x txt_to_outlook_csv.sh
./txt_to_outlook_csv.sh
```

### Convert Entra CSV to Outlook CSV

```bash
chmod +x entra_to_outlook_csv.sh
./entra_to_outlook_csv.sh
```

## License

This project is licensed under the [GNU General Public License (GPL v3)](LICENSE).