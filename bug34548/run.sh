echo "Answer: either (100,0) or (0,15)"
clang=clang
$clang -O3 c.c b.c -o foo
$clang -O3 -S -emit-llvm -o c.O3.ll c.c
./foo
