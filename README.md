# Safely Optimizing Casts between Pointers and Integers

Link to the introduction of talk: [here](https://llvm.org/devmtg/2019-04/talks.html#SRC_1)

Slides: [here](slides.pdf), poster: [here](poster.pdf)

Sound optimizations: [here](SoundOptList.md)

Paper(OOPSLA'19): [here](https://sf.snu.ac.kr/publications/llvmtwin.pdf)

## Miscompilation example

Working example: [here](bug34548/)

LLVM bugtracker link: https://bugs.llvm.org/show_bug.cgi?id=34548

GCC bug link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82282

## Implementation

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

