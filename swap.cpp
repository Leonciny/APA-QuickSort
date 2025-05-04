#include <EASTL/internal/functional_base.h>
#include <EASTL/random.h>
#include <EASTL/array.h>
#include <EASTL/functional.h>

#include <array>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <exception>
#include <fstream>
#include <iostream>
#include <random>
#include <sys/types.h>
#include <thread>

#define SWAP(a, b)  \
temp = a;           \
a = b;              \
b = temp

struct MonteCarloResults {
    uint64_t succeded;
    uint64_t failed;
};

constexpr int SIZE_OF_ARRAY = 10000;
constexpr int NUMBER_OF_THREADS = 5;
constexpr int TOTAL_NUMBER_OF_RUNS = 100000;
constexpr int NUMBER_OF_RUNS_PER_THREAD = TOTAL_NUMBER_OF_RUNS / NUMBER_OF_THREADS;

static_assert(NUMBER_OF_THREADS > 0, "Il numero di thread deve essere almeno 1");


typedef eastl::array<uint32_t, SIZE_OF_ARRAY>::iterator  iterator;
typedef eastl::uniform_int_distribution<uint32_t>  int_distribution;



static std::random_device rd;  // a seed source for the random number engine
static std::mt19937 gen(rd()); 
static int_distribution intDistribution(0, 25000);

static std::array<uint64_t, TOTAL_NUMBER_OF_RUNS> data;

static eastl::array<int_distribution, NUMBER_OF_THREADS> indexesDistributionArray;

uint64_t LVQuickSortInPlaceRec(eastl::array<uint32_t, SIZE_OF_ARRAY>& arr, iterator from, iterator to, uint32_t threadId) {
    uint64_t counter = 1;
    uint32_t temp; 
    uint32_t len = to - from;
    if ( len < 2 ) return counter;
    indexesDistributionArray[threadId].param(eastl::uniform_int_distribution<uint32_t>::param_type(0, len - 1));
    uint32_t pivotIndexOffset = indexesDistributionArray[threadId](gen);

    SWAP(from[pivotIndexOffset], to[-1]);

    iterator pivot = to - 1;
    iterator i = from;

    while (i != pivot) {
        ++counter;
        if (*i >= *pivot) {
            SWAP(*i, *pivot);
            SWAP(*i, *(pivot - 1));
            --pivot;
        }
        else ++i;
    }
    
    auto magCount = LVQuickSortInPlaceRec(arr, pivot + 1, to, threadId);
    auto minCount = LVQuickSortInPlaceRec(arr, from, pivot, threadId);

    return minCount + counter + magCount;
}


uint64_t LVQuickSortInPlace(eastl::array<uint32_t, SIZE_OF_ARRAY>& arr, uint32_t threadId) {
    return LVQuickSortInPlaceRec(arr, arr.begin(), arr.end(), threadId);
}

void MCQuickSortInPlace(eastl::array<uint32_t, SIZE_OF_ARRAY>& arr, uint32_t k, uint32_t threadId, MonteCarloResults& results) {
    for ( uint32_t i = 0; i < k; ++i ) {
        try {
            auto copy = eastl::array<uint32_t, SIZE_OF_ARRAY>(arr);
            auto v = LVQuickSortInPlace(copy, threadId);
            ++results.succeded;
            return;
        } catch (...) {}
    }
    ++results.failed;
}


auto LVThreadProcedure(uint32_t threadId, const eastl::array<uint32_t, SIZE_OF_ARRAY>& arr) {

    return [threadId, arr]() {
        const int iOffset = threadId * NUMBER_OF_RUNS_PER_THREAD;
        for( uint32_t i = 0; i < NUMBER_OF_RUNS_PER_THREAD; ++i ) {
            auto copy = eastl::array<uint32_t, SIZE_OF_ARRAY>(arr);
            auto count = LVQuickSortInPlace(copy, threadId);
            data[iOffset + i] = count;
        }
    };
}



auto MCThreadProcedure(uint32_t threadId, const eastl::array<uint32_t, SIZE_OF_ARRAY>& arr, const uint32_t k, const uint64_t run_ceil) {

    return [threadId, arr, k, run_ceil]() {
        
    };
}


int main( void ) {

    auto arr = eastl::array<uint32_t, SIZE_OF_ARRAY>();
    time_t start, end;
    std::time(&start);

    eastl::generate(
        arr.begin(), 
        arr.end(), 
        [](){ return intDistribution(gen); }    
    );

    eastl::array<std::thread, NUMBER_OF_THREADS - 1> threads = {};
    for ( auto threadId = 0; threadId < NUMBER_OF_THREADS - 1; ++threadId ) {
        threads[threadId] = std::thread(LVThreadProcedure(threadId, arr));
    }

    LVThreadProcedure(NUMBER_OF_THREADS-1, arr)();

    for ( auto threadId = 0; threadId < NUMBER_OF_THREADS - 1; ++threadId ) {
        threads[threadId].join();
    }
    std::time(&end);

    std::cout << "time: " << (end - start) << "\n";


    std::ofstream file;
    file.open("../extracted_data.txt");
    
    for ( auto e : data ) {
        file << e << "\n";
    }

    file.close();

    return 0;
}