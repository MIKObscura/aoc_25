#include <iostream>
#include <fstream>
#include <iterator>
#include <sstream>
#include <string>
#include <vector>
#include <set>
#include <unordered_map>

int main(int argc, char* argv[]){
    std::ifstream input_file("input.txt");
    std::string line;
    std::vector<std::vector<char>> board;

    while(getline(input_file, line)){
        std::vector<char> line_char(line.begin(), line.end());
        board.push_back(line_char);
    }

    std::pair<int, int> start_coord;
    for(int i = 0; i < board[0].size(); i++){
        if(board[0][i] == 'S'){
            start_coord = std::make_pair(0, i);
            break;
        }
    }

    int splits = 0;
    int curr_row = 1;
    std::vector<std::pair<int, int>> curr_beams = {start_coord};
    std::unordered_map<int, long long> beams = { {start_coord.second, 1LL} };
    for(;;){ // part 1
        if(curr_row == board.size()){
            break;
        }
        std::vector<std::pair<int, int>> new_beams;
        for(auto it = curr_beams.begin(); it != curr_beams.end(); it++){
            auto next_pos = std::make_pair(curr_row, it->second);
            if(board[next_pos.first][next_pos.second] == '^'){
                new_beams.push_back(std::make_pair(curr_row, it->second + 1));
                new_beams.push_back(std::make_pair(curr_row, it->second - 1));
                splits++;
            } else{
                new_beams.push_back(std::make_pair(curr_row, it->second));
            }
        }
        std::unordered_map<int, long long> new_beams_scores;
        for(const auto& [k, v]: beams){
            if(board[curr_row][k] == '.'){
                new_beams_scores[k] += v;
            } else {
                new_beams_scores[k - 1] += v;
                new_beams_scores[k + 1] += v;
            }
        }
        beams = new_beams_scores;
        std::set<std::pair<int, int>> tmp_beams(new_beams.begin(), new_beams.end());
        new_beams.assign(tmp_beams.begin(), tmp_beams.end());
        curr_beams = new_beams;
        curr_row++;
    }
    std::cout << splits << std::endl;
    long long timelines = 0LL;
    for(const auto& [k,v]: beams){
        timelines += v;
    }
    std::cout << timelines << std::endl;
}