#$host#查看版本
#$PSVersionTable#查看版本
# $PSVersionTable.PSVersion#查看版本
# winget search Microsoft.PowerShell
# winget install --id Microsoft.Powershell --source winget#安装新版本

# 设置输入和输出文件路径
$sourceFilePath = ".\code\example.txt"
$outputFilePath = ".\code\output.csv"

# 读取txt文件内容
$content = Get-Content -Path $sourceFilePath

# 创建一个新的空白CSV文件
$csv = New-Object -TypeName "System.Collections.Generic.List``1[System.Object]"

# 对每一行进行处理
foreach($line in $content) {
    # 切割每一行数据
    $lineData = $line.Split(":")  #以逗号分隔每个字段，根据实际情况调整分隔符

    # 创建一个新的对象，将切割后的字段存储到这个对象中
    $obj = New-Object -TypeName PSObject

    # 添加每个字段到对象中
    for($i = 0; $i -lt $lineData.Length; $i++) {
        $propertyName = "Column" + $i
        $obj | Add-Member -MemberType NoteProperty -Name $propertyName -Value $lineData[$i]
    }

    # 将对象添加到CSV
    $csv.Add($obj) | Out-Null
}

# 将CSV导出到文件
$csv | Export-Csv -Path $outputFilePath -NoTypeInformation
