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


if [[ $# != 1 ]]; then
    echo "Only one argument is allowed (name of branch)"
    exit
fi

readonly branch=$1
readonly dir=$(pwd)/$branch

if test -e $dir; then
    echo "error: $dir already exists" >&2
    exit 1
fi

git clone https://github.com/KratosMultiphysics/Kratos.git $dir && cd $dir
git fetch origin $branch:$branch

readonly merge_base=$(git merge-base master $branch)
git checkout $merge_base

for file in $(git diff --name-only --diff-filter=ACMRTUXB $merge_base $branch); do
    git checkout $branch -- $file
done

for file in $(git diff --name-only --diff-filter=D $merge_base $branch); do
    git rm -- $file
done
