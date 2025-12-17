const fs = require('node:fs');

function get_area(corner, corner2){
    return (Math.abs(corner[0] - corner2[0]) + 1) * (Math.abs(corner[1] - corner2[1]) + 1)
}

function is_same_corner(corner, corner2){
    return corner[0] == corner2[0] && corner[1] == corner2[1]
}

const input = fs.readFileSync("input.txt", { encoding: 'utf8' })
const corners = input.split("\n").map((x) => x.split(",").map((y) => parseInt(y)))
let largest = 0
for(let c of corners){
    for(let c2 of corners){
        if(is_same_corner(c, c2)) continue
        let area = get_area(c, c2)
        if(area > largest){
            largest = area
        }
    }
}
console.log(largest)