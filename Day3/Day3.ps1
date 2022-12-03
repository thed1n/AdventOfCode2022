using namespace System.Collections.Generic
$data = Get-Content .\Day3\Input3.txt

$points = 0

foreach ($d in $data) {
    $half = $d.Length / 2
    [hashset[char]]$first = $d.substring(0, $half)
    [hashset[char]]$second = $d.substring($half)
    $first.IntersectWith($second)
    $char = $first.GetEnumerator() | ForEach-Object { $_ }

    if ([int]$char -ge 97 -and [int]$char -le 122) {
        #is lowercase
        $points += [int]$char - 96
    }
    else {
        #just trust that is uppercase
        $points += [int]$char - 38
    }
}


$points2 = 0
for ($i = 0; $i -le $data.count-3 ; $i+=3) {

    [HashSet[char]]$elve1 = $data[$i].ToCharArray()
    [HashSet[char]]$elve2 = $data[$i+1].ToCharArray()
    [HashSet[char]]$elve3 = $data[$i+2].ToCharArray()

    $elve2.IntersectWith($elve1)
    $elve3.IntersectWith($elve2)

    $char = $elve3.GetEnumerator() | ForEach-Object { $_ }
    
    if ([int]$char -ge 97 -and [int]$char -le 122) {
        #is lowercase
        $points2 += [int]$char - 96
    }
    else {
        #just trust that is uppercase
        $points2 += [int]$char - 38
    }
    
}
[pscustomobject]@{
    Part1 = $points
    Part2 = $points2
}
