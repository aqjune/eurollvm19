## Sound optimizations we've added

You can see how they are implemented from 
[here](https://github.com/aqjune/llvm-eurollvm19/tree/optimized).

1.

```
// if p and q has same underlying object
icmp eq/ne (inttoptr(ptrtoint p), q) -> icmp p, q
psub eq/ne (inttoptr(ptrtoint p), q) -> psub p, q
```

This optimization is correct in our model
because icmp/psub just compares/subtracts
their relative offsets from the underlying object if p and q are
pointing to the same object.


2.

```
q = inttoptr(ptrtoint(gep (inttoptr i), j))
icmp eq/ne p, q
->
q' = gep (inttoptr i), j
icmp eq/ne p, q'
```

```
q = inttoptr(ptrtoint(gep (inttoptr i), j))
psub p, q
->
q' = gep (inttoptr i), j
psub p, q'
```

This is correct.
We'll say that a pointer p is a _physical pointer_ if it is based on
a pointer derived from an integer.
Both q and q' are physical pointers, so the results of icmp and psub
don't change after optimization.


3.

```
icmp eq/ne (inttoptr i, inttoptr j) -> icmp eq/ne i, j
```

This is correct because pointer comparison on physical pointers simply
compare their integer addresses.



## Sound optimizations that are already in LLVM

4.

```
r = gep(p, -ptrtoint(q))
->
r = inttoptr((ptrtoint)p-(ptrtoint)q)
```

This is correct because r after optimized has full provenance.
In our model, it is allowed to replace pointer p with
q if (int)p == (int)q and q has full provenance.


5.

```
q = select (p==null), p, null
->
q = null
```

In our semantics, null is inttoptr(0), hence having full provenance.
If p == null, this optimization is replacing p with null,
and this is fine because it is replacing p with
full provenance.
If p != null, q in both programs is null, so it's okay.
Therefore, this optimizaiton is correct.


## Sound optimizations not added, but can be proved sound

6.

```
k = ptrtoint(gep (inttoptr i), j)
->
k = i + j
```

This is correct because ptrtoint returns a pure integer
(without any pointer-related informations attached).

7.

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


