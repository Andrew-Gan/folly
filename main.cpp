#include "folly/crypto/LtHash.h"
#include <iostream>
#include <fstream> 
#include <string>
#include <chrono>

#define BLOCK_SIZE 8192

extern "C"
int main() {
    std::ifstream model_file("./model.pth", std::ios::in | std::ios::binary);
    model_file.seekg(0, std::ios::end);
    size_t file_size = model_file.tellg();
    model_file.seekg(0, std::ios::beg);
    std::cout << "file size: " << file_size << std::endl;
    std::cout << "num block: " << file_size / BLOCK_SIZE << std::endl;

    folly::crypto::LtHash<16, 1024> ltHash;
    std::array<char, BLOCK_SIZE> arr;

    auto start = std::chrono::high_resolution_clock::now();
    for (size_t i = 0; i < file_size / BLOCK_SIZE; i++) {
        model_file.read(arr.data(), BLOCK_SIZE);
        folly::ByteRange block(arr);
        ltHash.addObject(block);
    }
    ltHash.getChecksum();
    auto end = std::chrono::high_resolution_clock::now();

    model_file.close();

    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start);
    std::cout << duration.count() << " ms" << std::endl;

    return 0;
}