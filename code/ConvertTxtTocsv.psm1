function Convert-TxtToCsv {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-Path $_ -PathType 'Leaf'})]
        [string]$SourceFilePath,

        [Parameter(Mandatory=$true)]
        [string]$OutputFilePath,

        [char]$Delimiter = ","
    )

    # 读取txt文件内容
    $content = Get-Content -Path $SourceFilePath

    # 创建一个新的空白CSV文件
    $csv = New-Object -TypeName "System.Collections.Generic.List``1[System.Object]"

    # 对每一行进行处理
    foreach($line in $content) {
        # 切割每一行数据
        $lineData = $line.Split($Delimiter)

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
    $csv | Export-Csv -Path $OutputFilePath -NoTypeInformation
}
