set term png size 1200, 400
set parametric
set yrange [0.019:.023]

set output "bandit_score.png"
plot "bandit.dat" using 1:2 smooth csplines with lines ls 4 title "A", \
  "bandit.dat" using 1:4 smooth csplines with lines ls 3 title "B"

set output "ab_score.png"
plot "ab.dat" using 1:2 smooth csplines with lines ls 4 title "A", \
  "ab.dat" using 1:4 smooth csplines with lines ls 3 title "B"

set yrange [0:7000000]
set output "pulls.png"
plot "bandit.dat" using 1:5 smooth csplines with lines ls 4 lw 3 title "Bandit Winner", \
  "bandit.dat" using 1:3 smooth csplines with lines ls 4 lw 1 title "Bandit Loser", \
  "ab.dat" using 1:5 smooth csplines with lines ls 3 lw 3 title "A/B Winner", \
  "ab.dat" using 1:3 smooth csplines with lines ls 3 lw 1 title "A/B Loser"

