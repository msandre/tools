#!/bin/bash -e

# MIT License
#
# Copyright (c) 2018 Michael Andre
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

readonly branch=$(git symbolic-ref --short HEAD)

readonly merge_base=$(git merge-base master $branch)

readonly tmpdir=$(mktemp -d)

git diff --name-only --diff-filter=ACMRTUXB $merge_base $branch | grep --regexp="\(.*\.h\|.*\.cpp\)" > $tmpdir/changes.txt

cppcheck --xml --language=c++ --std=c++11 --force --enable=warning,style,performance,portability --output-file=$tmpdir/check.xml $@ $(tr '\n' ' ' < $tmpdir/changes.txt)

mkdir $tmpdir/report
cppcheck-htmlreport --file=$tmpdir/check.xml --report-dir=$tmpdir/report --source-dir=$pwd

chromium-browser --new-window $tmpdir/report/index.html
