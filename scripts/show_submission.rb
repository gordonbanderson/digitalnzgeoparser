#!/usr/bin/env ../digitalnz/script/runner

submission_id = ARGV[0]

s = Submission.find(submission_id)
puts s.geo_description