# EuroLLVM'19 Safely Optimizing Casts between Pointers and Integers

Link to the session: [here](https://llvm.org/devmtg/2019-04/talks.html#SRC_1)


## Implementations

LLVM: https://github.com/aqjune/llvm-eurollvm19

Clang: https://github.com/aqjune/clang-eurollvm19

Branches:

|                                    | LLVM branch | Clang branch |
|------------------------------------|-------------|--------------|
| 1. Baseline                        | base        | base         |
| 2. No i2p(p2i p)->p                | nocastfold  | base         |
| 3. No unsound cast opts            | nocastfold3 | base         |
| 4. Add psub                        | psub        | psub         |
| 5. Disable canonicalization to int | nocanonint  | psub         |
| 6. Add sound optimizations         | optimized   | psub         |


## Sound optimizations added

You can see the implementation of these transformations from
[optimized](https://github.com/aqjune/llvm-eurollvm19/tree/optimized) branch.

```
// if p and q has same underlying object
icmp eq/ne (inttoptr(ptrtoint p), q) -> icmp p, q
psub eq/ne (inttoptr(ptrtoint p), q) -> psub p, q
```

This optimization is correct because if p and q are pointing to the same object,
icmp and psub is just comparing/subtracting their relative offsets from the object.


```
q = inttoptr(ptrtoint(gep (inttoptr i), j))
icmp eq/ne p, q
->
q' = gep (inttoptr i), j
icmp eq/ne p, q'

q = inttoptr(ptrtoint(gep (inttoptr i), j))
psub p, q
->
q' = gep (inttoptr i), j
psub p, q'
```

This is correct.
We'll say that a pointer p is a _physical pointer_ if it is based on
a pointer derived from an integer.
q and q' are both physical pointers, so the results of icmp and psub don't change.


```
icmp eq/ne (inttoptr i, inttoptr j) -> icmp eq/ne i, j
```

This is correct because pointer comparison on physical pointers simply
compare their integer addresses.


These two following optimizations are not implemented, but can be proved sound in our model.

```
k = ptrtoint(gep (inttoptr i), j)
->
k = i + j
```

This is correct because ptrtoint returns a pure integer
(without any pointer-related informations attached).


```
p2 = inttoptr(ptrtoint p)
// if it is proved that p is dereferenceable at this point
load p2
->
load p
```

This is correct in our model.
The rationale is that a physical pointer (p2) dereferences same bytes
as the original pointer (p) if p is dereferenceable at the moment.
