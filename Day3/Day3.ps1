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

    [HashSet[char]]$elf1 = $data[$i].ToCharArray()
    [HashSet[char]]$elf2 = $data[$i+1].ToCharArray()
    [HashSet[char]]$elf3 = $data[$i+2].ToCharArray()

    $elf2.IntersectWith($elf1)
    $elf3.IntersectWith($elf2)

    $char = $elf3.GetEnumerator() | ForEach-Object { $_ }
    
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
