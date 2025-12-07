import java.io.File
import java.util.Arrays

fun is_forklift_certified(pos: Pair<Int, Int>, grid: List<CharArray>): Boolean{
    var neighbouring_rolls = 0
    for(i in -1..1){
        for(ii in -1..1){
            val neighbour: Pair<Int, Int> = Pair(pos.first + i, pos.second + ii)
            if(i == 0 && ii == 0) continue
            if(neighbour.first < 0 || neighbour.second < 0) continue;
            if(neighbour.first >= grid.size || neighbour.second >= grid[0].size) continue;
            if(grid[neighbour.first][neighbour.second] == '@') neighbouring_rolls += 1
        }
    }
    return neighbouring_rolls < 4
}

fun remove_rolls(rolls: Array<Pair<Int, Int>>, grid: List<CharArray>){
    for(r in rolls){
        grid[r.first][r.second] = '.'
    }
}

fun main(args: Array<String>){
    val input_file = File("input.txt").readText()
    val lines = input_file.split("\n")
    val input = lines.map { l: String -> l.toCharArray() }
    var accessibles: Array<Pair<Int, Int>> = emptyArray()
    for(x in 0..(input.size - 1)){ // part 1
        for(y in 0..(input[0].size - 1)){
            val pos = Pair(x, y)
            if(input[x][y] != '@') continue
            if(is_forklift_certified(pos, input)) accessibles += pos
        }
    }
    println(accessibles.size)
    var total_removed = 0
    while(true){ // part 2
        var accessibles: Array<Pair<Int, Int>> = emptyArray()
        for(x in 0..(input.size - 1)){
            for(y in 0..(input[0].size - 1)){
                val pos = Pair(x, y)
                if(input[x][y] != '@') continue
                if(is_forklift_certified(pos, input)) accessibles += pos
            }
        }
        if(accessibles.size == 0) break
        total_removed += accessibles.size
        remove_rolls(accessibles, input)
    }
    println(total_removed)
}