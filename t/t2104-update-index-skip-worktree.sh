#!/bin/sh
#
# Copyright (c) 2008 Nguyễn Thái Ngọc Duy
#
test_description='skip-worktree bit test'	

TEST_PASSES_SANITIZE_LEAK=true	
. ./test-lib.sh	

sane_unset GIT_TEST_SPLIT_INDEX	

test_set_index_version () {	
    GIT_INDEX_VERSION="$1"	
    export GIT_INDEX_VERSION	
}	

test_set_index_version 3	

cat >expect.full <<EOF	
H 1	
H 2	
H sub/1	
H sub/2	
EOF	

cat >expect.skip <<EOF	
S 1	
H 2	
S sub/1	
H sub/2	
EOF	

test_expect_success 'setup' '
	mkdir sub &&
	touch ./1 ./2 sub/1 sub/2 &&
	git add 1 2 sub/1 sub/2 &&
	output=$(git ls-files -t)
	echo "$output" | test_cmp expect.full -
	if [ $? -ne 0 ]; then
	    exit 1
	fi
'

test_expect_success 'update-index --skip-worktree' '
	git update-index --skip-worktree 1 sub/1 &&
	output=$(git ls-files -t)
	echo "$output" | test_cmp expect.skip -
	if [ $? -ne 0 ]; then
	    exit 1
	fi
'

test_expect_success 'ls-files -t' '
	output=$(git ls-files -t)
	echo "$output" | test_cmp expect.skip -
	if [ $? -ne 0 ]; then
	    exit 1
	fi
'

test_expect_success 'update-index --no-skip-worktree' '
	git update-index --no-skip-worktree 1 sub/1 &&
	output=$(git ls-files -t)
	echo "$output" | test_cmp expect.full -
	if [ $? -ne 0 ]; then
	    exit 1
	fi
'
