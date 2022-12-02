$data = get-content .\Day2\Input2.txt

#A Rock  # X  Rock
#B Paper # Y Paper
#C Scissor # Z Scissor
#point
#1 r, 2 p, 3 s
#x    y    z
#round
# 0, 3, 6

$totalresult = 0
$totalresult2 = 0
foreach ($round in $data) {
    $point = 0
    $point2 = 0
#x loose
#y draw
#z win
    switch ($round) {
        'A X' {$point+=4;$point2+=3;break}
        'A Y' {$point+=8;$point2+=4;break}
        'A Z' {$point+=3;$point2+=8;break}
        'B X' {$point+=1;$point2+=1;break}
        'B Y' {$point+=5;$point2+=5;break}
        'B Z' {$point+=9;$point2+=9;break}
        'C X' {$point+=7;$point2+=2;break}
        'C Y' {$point+=2;$point2+=6;break}
        'C Z' {$point+=6;$point2+=7;break}
    }

    $totalresult+=$point
    $totalresult2+=$point2
}

[pscustomobject]@{
    Part1 = $totalresult
    Part2 = $totalresult2
}