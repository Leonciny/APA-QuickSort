import random
from threading import Thread
import matplotlib.pyplot as plt
import numpy as np
import math

def LVQuickSortInPlace_Rec(S: list[int], bottom: int, top: int, stop: int) -> int:
    sLen = (top - bottom)
    if sLen <= 1: 
        return 0
    indexOfS = random.randint(bottom, top - 1)
    S[top - 1], S[indexOfS] = S[indexOfS], S[top - 1]
    indexOfS = top - 1

    i = bottom
    count = 0
    while i != indexOfS:
        count += 1
        if S[i] >= S[indexOfS]: 
            S[i], S[indexOfS] = S[indexOfS], S[i]
            S[i], S[indexOfS - 1] = S[indexOfS - 1], S[i]
            indexOfS -= 1
        else: i += 1
    magC = LVQuickSortInPlace_Rec(S, indexOfS + 1, top, stop)
    minC = LVQuickSortInPlace_Rec(S, bottom, indexOfS, stop)
    if (minC + magC + count) >= stop:
        raise Exception("Too many comparisons")
    return minC + magC + count
        

def LVQuickSortInPlace(S: list[int], stop: int) -> (list[int], int):
    l = list(S)
    return l, LVQuickSortInPlace_Rec(l, 0, len(S), stop)


def MCQuickSort(S: list[int], k: int) -> (list[int], int):

    mu = len(S) * math.log(len(S), 1.72348)

    for r in range(k):
        try: return LVQuickSortInPlace(S, mu)
        except Exception as e: continue
    else: raise Exception("Couldn't sort array")

    


INT_BOUNDS = 10**4
K = 2
NUMBER_OF_INTEGERS = 10**4

TOTAL_NUMBER_OF_RUNS = int((10**4) / 8)

NUMBER_OF_THREADS = 5
NUMBER_OF_RUNS = int(TOTAL_NUMBER_OF_RUNS / NUMBER_OF_THREADS)

def threadProcedure(S: list[int], k: int, results: list[None], index: int) -> None:
    counts = [None] * NUMBER_OF_RUNS
    for run in range(NUMBER_OF_RUNS):
        try: 
            _, counts[run] = MCQuickSort(S, k)
            print(f"T{index}: {run}")
        except Exception as e:
            print(e)
            counts[run] = 0
            print(f"T{index}: {run} EX")
    
    results[index] = counts
        



S = [random.randint(-INT_BOUNDS, INT_BOUNDS) for _ in range(NUMBER_OF_INTEGERS)]

results = [None] * NUMBER_OF_THREADS
threadPool = [Thread(target=threadProcedure, args=(S, K, results, i)) for i in range(NUMBER_OF_THREADS - 1)]

for t in threadPool: t.start()
threadProcedure(S, K, results, NUMBER_OF_THREADS - 1)
for t in threadPool: t.join()


somma = sum( sum(l) for l in results )
media = somma / TOTAL_NUMBER_OF_RUNS


x = np.asarray(results).flatten()

fig, ax = plt.subplots()

ax.hist(x, bins=128, linewidth=0.5, edgecolor="white")

plt.show()