#!/bin/sh
#
# Copyright (c) 2008 Nguyễn Thái Ngọc Duy
#

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
