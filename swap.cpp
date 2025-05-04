#include <EASTL/internal/functional_base.h>
#include <EASTL/random.h>
#include <EASTL/array.h>
#include <EASTL/functional.h>

#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <ctime>
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
    uint64_t succeded = 0;
    uint64_t failed = 0;
};


constexpr int32_t DISTRIBUTION_START = 0;
constexpr int32_t DISTRIBUTION_END = 25000;

constexpr int32_t SIZE_OF_ARRAY = 10000;
constexpr int32_t NUMBER_OF_THREADS = 5;
constexpr int32_t TOTAL_NUMBER_OF_RUNS = 100000;
constexpr int32_t NUMBER_OF_RUNS_PER_THREAD = TOTAL_NUMBER_OF_RUNS / NUMBER_OF_THREADS;

constexpr int32_t MC_K = 3;
constexpr double MC_MU_LOG_BASE = 1.72348;



// #define LV_QUICK_SORT
#define MC_QUICK_SORT

#if defined(LV_QUICK_SORT) && defined(MC_QUICK_SORT)
    #error "[ERRORE] Selezionare solo una delle seguenti opzioni: [LV_QUICK_SORT | MC_QUICK_SORT]"
#endif


static_assert(NUMBER_OF_THREADS > 0, "Il numero di thread deve essere almeno 1");


typedef eastl::array<uint32_t, SIZE_OF_ARRAY>::iterator  iterator;
typedef eastl::uniform_int_distribution<uint32_t>  int_distribution;



static std::random_device rd;  // a seed source for the random number engine
static std::mt19937 gen(rd()); 
static int_distribution intDistribution(DISTRIBUTION_START, DISTRIBUTION_END);

static eastl::array<uint64_t, TOTAL_NUMBER_OF_RUNS> data;
static eastl::array<MonteCarloResults, NUMBER_OF_THREADS> MCdata;

static eastl::array<int_distribution, NUMBER_OF_THREADS> indexesDistributionArray;

constexpr float log(float value, float base) { return std::log(value) / std::log(base); }
constexpr double log(double value, double base) { return std::log(value) / std::log(base); }

uint64_t LVQuickSortInPlaceRec(eastl::array<uint32_t, SIZE_OF_ARRAY>& arr, iterator from, iterator to, uint32_t threadId) {
    uint64_t counter = 1;
    uint32_t temp; 
    uint32_t len = to - from;
    if ( len < 2 ) return counter;
    
    indexesDistributionArray[threadId].param(eastl::uniform_int_distribution<uint32_t>::param_type(0, len - 1));
    uint32_t pivotIndexOffset = indexesDistributionArray[threadId](gen);

    SWAP(from[pivotIndexOffset], to[-1]);

    iterator pivot = to - 1;

    for (iterator i = from; i != pivot; ++counter ) {
        if (*i >= *pivot) {
            SWAP(*i, *pivot);
            SWAP(*i, *(pivot - 1));
            --pivot;
        }
        else ++i;
    }
    
    uint64_t magCount = LVQuickSortInPlaceRec(arr, pivot + 1, to, threadId);
    uint64_t minCount = LVQuickSortInPlaceRec(arr, from, pivot, threadId);

    return minCount + counter + magCount;
}


uint64_t LVQuickSortInPlaceRec(eastl::array<uint32_t, SIZE_OF_ARRAY>& arr, iterator from, iterator to, uint32_t run_ceil, uint32_t threadId) {
    uint64_t counter = 1;
    uint32_t temp; 
    uint32_t len = to - from;
    if ( len < 2 ) return counter;
    
    indexesDistributionArray[threadId].param(eastl::uniform_int_distribution<uint32_t>::param_type(0, len - 1));
    uint32_t pivotIndexOffset = indexesDistributionArray[threadId](gen);

    SWAP(from[pivotIndexOffset], to[-1]);

    iterator pivot = to - 1;

    for (iterator i = from; i != pivot; ++counter ) {
        if (*i >= *pivot) {
            SWAP(*i, *pivot);
            SWAP(*i, *(pivot - 1));
            --pivot;
        }
        else ++i;
    }
    
    uint64_t magCount = LVQuickSortInPlaceRec(arr, pivot + 1, to, threadId);
    uint64_t minCount = LVQuickSortInPlaceRec(arr, from, pivot, threadId);

    if ( minCount + counter + magCount >= run_ceil ) throw 1;

    return minCount + counter + magCount;
}




uint64_t LVQuickSortInPlace(eastl::array<uint32_t, SIZE_OF_ARRAY>& arr, uint32_t threadId) {
    return LVQuickSortInPlaceRec(arr, arr.begin(), arr.end(), threadId);
}
uint64_t LVQuickSortInPlace(eastl::array<uint32_t, SIZE_OF_ARRAY>& arr, uint32_t run_ceil, uint32_t threadId) {
    return LVQuickSortInPlaceRec(arr, arr.begin(), arr.end(), run_ceil, threadId);
}


void MCQuickSortInPlace(const eastl::array<uint32_t, SIZE_OF_ARRAY>& arr, const uint32_t k, const uint64_t run_ceil, MonteCarloResults& results, const uint32_t threadId) {
    eastl::array<uint32_t, SIZE_OF_ARRAY> copy;
    for ( uint32_t i = 0; i < k; ++i ) {
        try {
            copy = eastl::array<uint32_t, SIZE_OF_ARRAY>(arr);
            LVQuickSortInPlace(copy, run_ceil, threadId);
            ++results.succeded;
            return;
        } catch (...) {}
    }
    ++results.failed;
}


auto LVThreadProcedure(const uint32_t threadId, const eastl::array<uint32_t, SIZE_OF_ARRAY>& arr) {

    return [threadId, arr]() {
        const int iOffset = threadId * NUMBER_OF_RUNS_PER_THREAD;
        eastl::array<uint32_t, SIZE_OF_ARRAY> copy;
        uint64_t count;

        for( uint32_t i = 0; i < NUMBER_OF_RUNS_PER_THREAD; ++i ) {
            copy = eastl::array<uint32_t, SIZE_OF_ARRAY>(arr);
            count = LVQuickSortInPlace(copy, threadId);
            data[iOffset + i] = count;
        }
    };
}



auto MCThreadProcedure(const uint32_t threadId, const eastl::array<uint32_t, SIZE_OF_ARRAY>& arr, const uint32_t k) {

    return [threadId, arr, k]() {
        const uint64_t mu = SIZE_OF_ARRAY * log(SIZE_OF_ARRAY, MC_MU_LOG_BASE); 
        for ( uint32_t i = 0; i < NUMBER_OF_RUNS_PER_THREAD; ++i ) 
            MCQuickSortInPlace(arr, k, 2*mu, MCdata[threadId], threadId);
    };
}


int main( void ) {

    auto arr = eastl::array<uint32_t, SIZE_OF_ARRAY>();

    eastl::generate(
        arr.begin(), 
        arr.end(), 
        [](){ return intDistribution(gen); }    
    );

    #ifdef LV_QUICK_SORT
    
    eastl::array<std::thread, NUMBER_OF_THREADS - 1> threads = {};
    for ( auto threadId = 0; threadId < NUMBER_OF_THREADS - 1; ++threadId )
        threads[threadId] = std::thread(LVThreadProcedure(threadId, arr));
    

    LVThreadProcedure(NUMBER_OF_THREADS-1, arr)();
    
    #else 
    #ifdef MC_QUICK_SORT

    eastl::array<std::thread, NUMBER_OF_THREADS - 1> threads = {};
    for ( auto threadId = 0; threadId < NUMBER_OF_THREADS - 1; ++threadId )
        threads[threadId] = std::thread(MCThreadProcedure(threadId, arr, MC_K));
    

    MCThreadProcedure(NUMBER_OF_THREADS-1, arr, MC_K)();

    #endif
    #endif

    for ( auto threadId = 0; threadId < NUMBER_OF_THREADS - 1; ++threadId ) {
        threads[threadId].join();
    }

    #ifdef LV_QUICK_SORT
    std::ofstream file;
    file.open("../extracted_data.txt");
    
    for ( auto e : data ) {
        file << e << "\n";
    }

    file.close();
    #endif
    #ifdef MC_QUICK_SORT

    int64_t succeded = 0;
    int64_t failed = 0;
    for( auto d : MCdata ) {
        succeded += d.succeded;
        failed += d.failed;
    }
    std::cout << "Succeeded: " << succeded << "\n";
    std::cout << "Failed: " << failed << "\n";
    std::cout << "Success Ratio: " << (100 * (double) succeded / (double) TOTAL_NUMBER_OF_RUNS) << "%\n"; 
    std::cout << "Below epsilon: " << (failed <= 1 ? "TRUE" : "FALSE") << "\n"; 

    #endif

    return 0;
}