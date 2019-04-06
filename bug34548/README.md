# Miscompilation example

Run `run.sh` to see its result. The program should print
either (100,0) or (0,15).

```
$ ./run.sh
Answer: either (100,0) or (0,15)
a=0 x=0
```

If it does not miscompile, please reorder the definition of variables `x` and `y` in `c.c` as follows:

```
int a=0, y[1], x = 0;
//int a=0, x = 0, y[1];
```
