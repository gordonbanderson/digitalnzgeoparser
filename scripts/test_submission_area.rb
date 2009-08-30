#!/usr/bin/env ../digitalnz/script/runner
s=Submission.find(1739)
s.calculate_area

for s in Submission.find(:all)
  s.calculate_area
end