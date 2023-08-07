function Select-CSVColumn {
    param (
        [Parameter(Mandatory = $true)]
        [string]$CsvFilePath,
        
        [Parameter(Mandatory = $true)]
        [string]$OutputFilePath,
        
        [Parameter(Mandatory = $true)]
        [int[]]$SelectedColumnIndices
    )
    
    $csvContent = Import-Csv $CsvFilePath
    $selectedData = @{}
    
    # 初始化选中的列的数据为一个空数组
    foreach ($index in $SelectedColumnIndices) {
        $selectedData[$index] = @()
    }

    foreach ($row in $csvContent) {
        foreach ($index in $SelectedColumnIndices) {
            $selectedValue = $row[$index]
            $selectedData[$index] += $selectedValue
        }
    }
    $selectedData | Out-File -FilePath $OutputFilePath
}

# 创建临时 CSV 文件路径
$tempCsvFilePath = [System.IO.Path]::GetTempFileName() + ".csv"

# 将数据导出到临时 CSV 文件
$selectedData | ForEach-Object {
    [PsCustomObject]@{$_ = $_ }
} | Export-Csv -Path $tempCsvFilePath -NoTypeInformation

# 读取临时 CSV 文件内容
$csvData = Get-Content -Path $tempCsvFilePath

# 将临时 CSV 文件内容写入输出文本文件
$csvData | Out-File -FilePath $OutputFilePath

# 删除临时 CSV 文件
Remove-Item -Path $tempCsvFilePath


Export-ModuleMember -Function Select-CSVColumn
