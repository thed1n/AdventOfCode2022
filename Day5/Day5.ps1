using namespace System.Collections.Generic
$data = Get-Content .\Day5\Input5.txt

[list[stack[char]]]$stacks = @()
0..9 | ForEach-Object {
    $stacks.Add([stack[char]]::new())
}

[list[stack[char]]]$stacks9001 = @()
0..9 | ForEach-Object {
    $stacks9001.Add([stack[char]]::new())
}


for ($s = 7; $s -ge 0; $s--) { 

    for (($i = 33), ($sn = 9); $i -gt 0; ($i -= 4), $sn--) {

        $value = $($data[$s].Substring($i, 1)) -replace '\s+'

        if ($value) {
            $stacks[$sn].push([char]$value)
            $stacks9001[$sn].push([char]$value)
        }
        
    }
}

foreach ($d in $data[10..$($data.Length)]) {

    [int]$amount, [int]$from, [int]$to = $d -replace '[a-z]' -split '\s' | Where-Object { $_ }

    if ($amount -gt 1) {
        #stack to act as a parking slot
        $queue = [stack[char]]::new()
    }
    for ($i = 1; $i -le $amount; $i++) {

        $container = $stacks[$from].pop()
        $container2 = $stacks9001[$from].pop()

        if ($amount -gt 1) {
            $queue.push($container2)
        }
        else {
            $stacks9001[$to].push($container2)
        }
        
        $stacks[$to].push($container)
    }

    if ($amount -gt 1) {
        while ($queue.Count -gt 0) {
            $moveOrdered = $queue.pop()
            $stacks9001[$to].push($moveOrdered)
        }
    }
}

[pscustomobject]@{
    Part1 = (1..9 | ForEach-Object { $stacks[$_].peek() }) -join ''
    Part2 = (1..9 | ForEach-Object { $stacks9001[$_].peek() }) -join ''
}