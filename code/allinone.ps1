# Import-Module -Name "ConvertTxtTocsv.psm1" 
Import-Module -Name "C:\Users\A\OneDrive\code\powershell\powershell\code\Select-CSVColumn.psm1"

# Convert-TxtToCsv -SourceFilePath "C:\path\to\source.txt" -OutputFilePath "C:\path\to\output.csv" -Delimiter ":"

Select-CSVColumn -CsvFilePath "C:\Users\A\OneDrive\code\powershell\powershell\code\output.csv" -OutputFilePath "C:\Users\A\OneDrive\code\powershell\powershell\code\output.txt" -SelectedColumnIndices 2, 3


