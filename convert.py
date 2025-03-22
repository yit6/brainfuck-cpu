#!/bin/python

import sys

if __name__=="__main__":
    for line in sys.stdin:
        for c in line:
            if c not in "><+-.,[]": continue

            i = "><+-.,[]".index(c)
            print([
                "\t\t\"10000000\"&x\"00\", -- bf: >",
                "\t\t\"01000000\"&x\"00\", -- bf: <",
                "\t\t\"00100000\"&x\"00\", -- bf: +",
                "\t\t\"00010000\"&x\"00\", -- bf: -",
                "\t\t\"00001000\"&x\"00\", -- bf: .",
                "\t\t\"00000100\"&x\"00\", -- bf: ,",
                "\t\t\"00000010\"&x\"00\", -- bf: [",
                "\t\t\"00000001\"&x\"00\", -- bf: ]",
            ][i])
