## Dynamic Memory Allocation

### Objective:
Learn how to use system calls like `malloc`, `free`, and related memory management functions in assembly.

### Exercise:
1. Allocate Memory Dynamically:
    - Use the `malloc` function to allocate memory for an array.
    - Initialize the array with values.
    - Print the array to verify correct initialization.
2. Free the Allocated Memory:
    - Use the `free` function to free the allocated memory.
    - Ensure that the memory is properly released.
3. Experiment:
    - Test with different sizes of arrays to observe how allocation behaves with small vs. large memory blocks.

## Implementation Outline:
1. Include C Standard Library Functions:
   - Use the `extern` directive to include `malloc`, `free`, and `printf` functions.
2. Memory Allocation:
   - Call `malloc` to allocate memory for an array.
   - Check if the allocation was successful.
3. Initialization:
   - Initialize the allocated memory with values (e.g., set array elements to their indices).
4. Printing Values:
   - Use `printf` to print the values stored in the array.
5. Memory Deallocation:
   - Call `free` to free the allocated memory.
