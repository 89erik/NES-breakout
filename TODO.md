### To do
* check_hit_brick: 
    * it first checks if there is a hit, then it calculates the bounce 
      direction. Look into possibility of an optimization.
* Look into Multiply sub routine: there might be a problem when X=1.
* Fix speed increase token bug: ball does not stop on roof.
* Token dispenser only dispenses one token type.
* Fix screen bugs
    * Upper left corner BG tile
    * When scrolling to next level, the level can be seen loading
      on both namespaces
* when changing levels, bricks of previous levels remains visible
* ball_placement and move_token contains identical code. Move into common lib routine.
* Ball can bounce and kill bricks (in progress, delayed)
* Consistent memory usage: Minimize use of the tmp variables (it's getting messy), use local variables (in progress).
* Convention enforcement.
* Fix inconsistent and misleading names, some problems are pointed out in documentation.
