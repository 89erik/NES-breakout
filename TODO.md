## To do

### Bugs
* Fix speed increase token bug: ball does not stop on roof.
* Fix screen bugs
    * Upper left corner BG tile
    * When scrolling to next level, the level can be seen loading
      on both namespaces

### New functionality
* Token dispenser only dispenses one token type.

### Optimizations and improvements
* check_hit_brick: 
    * it first checks if there is a hit, then it calculates the bounce 
      direction. Look into possibility of an optimization.
* ball_placement and move_token contains identical code. Move into common lib routine.
* Improve bouncing on bricks

### Long term / vague todos
* Consistent memory usage: Minimize use of the tmp variables (it's getting messy), use local variables (in progress).
* Convention enforcement.
* Fix inconsistent and misleading names, some problems are pointed out in documentation.
