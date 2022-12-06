using namespace System.Collections.Generic
$data = get-content .\Day6\Input6.txt

for ($i=0;$i -lt $data.Length -3 ;$i++) {
    $uniquemarker=[hashset[char]]$data[$i..($i+3)]
    if ($uniquemarker.Count -eq 4){
        $result = ($i+3)+1 #to include 0 position
        break
    }
}

for ($i=0;$i -lt $data.Length -13 ;$i++) {
    $uniquemarker=[hashset[char]]$data[$i..($i+13)]
    if ($uniquemarker.Count -eq 14){
        $result2 = ($i+13)+1 #to include 0 position
        break
    }
}

[pscustomobject]{
    Part1 = $result
    Part2 = $result2
}