# 获取 CSV 文件路径
$csvPath = "C:\Users\A\OneDrive\code\powershell\powershell\code\output.csv"

# 指定要提取的列的列号（从1开始计数），以逗号分隔
$columnNumbers = "2,4,6"

# 指定输出的文本文件路径
$outputPath = "C:\Users\A\OneDrive\code\powershell\powershell\code\file.txt"

# 将列号字符串分割为数组
$columns = $columnNumbers -split ","

# 读取 CSV 文件
$csvData = Import-Csv -Path $csvPath

# 提取指定列的数据并用双引号包围
$columnData = $csvData | ForEach-Object {
    $row = $_
    $columnData = $columns | ForEach-Object {
        $columnName = $row.PSObject.Properties.Name[$_-1]
        '"' + ($row.$columnName -replace '"', '""') + '"'
    }
    $columnData -join ","
}

# 将数据写入文本文件
$columnData | Out-File -FilePath $outputPath