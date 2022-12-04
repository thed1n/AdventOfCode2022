using namespace System.Collections.Generic
$data = get-content .\Day4\Input4.txt

$pairs = 0
$pairs2 = 0
foreach ($d in $data) {

    $split = $d -split ','
    for ($i=0;$i -lt $split.count;$i+=2) {
        $f,$t = $split[$i] -split '-'
        $f2,$t2 = $split[$i+1] -split '-'
        [hashset[int]]$first = $f..$t
        [hashset[int]]$first2 = $f2..$t2
        
        $c1,$c2 = $first.count,$first2.count
        $first2.IntersectWith($first)

        if ($first2.count -eq $c1 -or $first2.count -eq $c2) {
            $pairs++
        }
        if ($first2.count -gt 0) {
            $pairs2++
        }
    }

}
[pscustomobject]@{
    Part1 = $pairs
    Part2 = $pairs2
}