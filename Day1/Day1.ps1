$data = get-content .\Day1\Input1.txt

$santa = @{}
$i = 0

foreach ($d in $data) {
    if (!$d) {$i++}
    $santa[$i]+=[int]$d
}



[pscustomobject]@{
part1 = $santa.values|sort -Descending|select -first 1
part2 = $santa.values|sort -Descending|select -first 3 | Measure-Object -sum | % sum
}