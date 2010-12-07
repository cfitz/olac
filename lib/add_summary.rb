#!/usr/bin/env ruby

require 'rubygems'
require 'fastercsv'
require 'pp'


newSummaries = {}

newWorks = FasterCSV.open('/tmp/new.csv', "w")
newWorks << ["WorkNum","WorkTitle",	"WorkType",	"WorkDate",	"WorkLang",	"WorkAspectRatio",	"WorkAspectText",	"WorkColor",	"WorkSound","WorkDuration",	"Summary"]																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																					

works = FasterCSV.read("/tmp/newWorks.csv", :headers => true)
summaries = File.open("/tmp/WorkSummaries.csv", 'r').each_line do |line| 
  l = line.split("\t")
  id =  l[0].chomp.to_i
  pp(l)
  newSummaries[id] = l[1].chomp
end
pp(newSummaries)

works.each do |w|
  w["Summary"] = newSummaries[w["WorkNum"].to_i]
  newWorks << w 
end

newWorks.close