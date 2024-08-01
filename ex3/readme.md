### 1. Handling Fragmentation: Implement Allocation Strategies
   Fragmentation occurs when memory is divided into small, non-contiguous blocks, making it difficult to allocate larger blocks even though the total free memory might be sufficient. To handle this, we can implement allocation strategies like best-fit or first-fit.

   - **First-Fit Allocation:** Allocate the first block that is large enough to fulfill the request.
   - **Best-Fit Allocation:** Allocate the smallest block that is large enough to fulfill the request, minimizing wasted space.
### 2. Coalescing Free Blocks
   When a block of memory is freed, adjacent free blocks can be merged (coalesced) into a single larger block. This reduces fragmentation and makes it easier to allocate larger blocks in the future.

### 3. Memory Compaction
Memory Compaction is a technique used to reduce fragmentation by physically moving allocated blocks to one end of memory, leaving a large contiguous block of free memory. This is more complex because it involves adjusting pointers and managing block sizes carefully.

### Implementation Outline
Let's outline how you can extend your basic memory allocator to include these features.

**Step 1: Implement First-Fit Allocation**
We'll start by modifying the `malloc` function to implement a first-fit strategy.

**Step 2: Implement Coalescing in Free**
Enhance the `free` function to check adjacent blocks and merge them if they are free.

**Step 3: Implement Memory Compaction**
Finally, add a compaction routine that moves allocated blocks to reduce fragmentation.

### Example Code Structure
Here’s a structured approach for implementing these features:

1. First-Fit Allocation:
   - Maintain a linked list of free blocks.
   - Traverse the list to find the first block that fits the request.
2. Coalescing Free Blocks:
   - When freeing memory, check if the adjacent blocks are free.
   - Merge adjacent free blocks into a larger block.
3. Memory Compaction:
   - Implement a compaction routine that traverses allocated blocks, moving them to one end of memory and updating pointers.

### Example Code (Skeleton)
Here’s a basic skeleton of how you might start implementing these concepts:

```nasm
section .data
    ; Data for memory management
    memory_start resb 1024 * 10  ; Start of the memory pool
    free_list resq 1             ; Head of the free list

    ; Logging messages
    alloc_msg db "Allocating memory...", 10, 0
    free_msg db "Freeing memory...", 10, 0
    compact_msg db "Compacting memory...", 10, 0
    done_msg db "Done.", 10, 0
    error_msg db "Error: Allocation failed.", 10, 0

section .text
    global main
    extern printf, malloc, free, getchar

main:
    ; Initialize memory management
    ; Implement first-fit allocation
    ; Implement coalescing in free
    ; Implement memory compaction
    ; Add logging for each step
    ; ...

    ; Allocate memory using first-fit
    ; Free memory and coalesce blocks
    ; Compact memory and print results

    ; Example allocations and frees
    ; Log results to verify
    ; ...

    ; Wait for user input before exiting
    call getchar

    leave
    ret

; Implement the allocation, free, and compaction routines

```

### Implementation Plan
1. Start by implementing a linked list to manage free blocks.
2. Enhance the `malloc` and `free` functions to manage the list.
3. Implement the compaction routine, carefully adjusting pointers and moving data.
4. Test each step thoroughly, using logs to trace memory allocations and deallocations.