# HoldingsCleanup

Crude script to remove some holdings statements that look problematic and slightyl pretty up long strings if possible.

Enter path to input and output files in $infile / $outfile

Input file format: OCLC\tLSN\tHoldings - assumes file has already been parsed to remove lines w/o holdings 

Given an SCS generated holdings file:


+ Removes possibley problematic holdings, e.g. c.1, index, leave index, suppl, etc. 

+ Concatinates any contiguous v.1, v.2  

+ Concatinates any contigous bk.1, bk.2 
