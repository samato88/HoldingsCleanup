#!/usr/bin/perl 

# Crude script to remove some holdings statements that look problematic and slightyl pretty up long strings if possible.

#  Given an SCS generated holdings file:
#  input file format: OCLC\tLSN\tHoldings - assumes file has already been parsed to remove lines w/o holdings
#  Remove possibley problematic holdings, e.g. c.1, index, leave index, suppl, etc. 
#  concatinate any contiguous v.1, v.2  
#  concatinate any contigous bk.1, bk.2 

use strict ;
use utf8;

 

my $infile =  "Full Path to your input file.tsv" ;
my $outfile = "Full Path to your output file.tsv";


open (INPUT, "$infile") or die $!;
open (OUTPUT, "> $outfile") or die $!;


my $totalwithholdings=0;
my $totalrecs=0;

while (<INPUT>) {
  ++$totalrecs;
  my ($oclc, $LSN, $holdings, $fromcallnumber) = split("\t", $_);
  $holdings =~ s/\s?$//;
  $holdings =~ s/\n//; 
  $holdings =~ s/"//g;
  $fromcallnumber =~ s/\s?$//;
  $fromcallnumber =~ s/\n//; 

  my $oldholdings = $holdings ;
  
  if (($holdings =~ /^aid/i ) or # add any regexes here that you want to remove
      ($holdings =~ /answers/i ) or  #   
      ($holdings =~ /^append/i ) or  #   
      ($holdings =~ /^appx/i ) or
      ($holdings =~ /^atlas/i ) or
      ($holdings =~ /^binder/i ) or
      ($holdings =~ /^bk/i ) or
      ($holdings =~ /book/i ) or # book, codebook, ...
      ($holdings =~ /^bound/i ) or  #  bound, unbound
      ($holdings =~ /broch/i ) or  #  brochure
      ($holdings =~ /^c\./i ) or
      ($holdings =~ /^cass/i ) or # remove lines that start with cass., cassette, etc.
      ($holdings =~ /cd/i ) or # cd anywhere in line
      ($holdings =~ /^ch/i ) or    # remove lines that start with ch., chapter, chart, etc.
      ($holdings =~ /^cop/i) or # cop. copy 
      ($holdings =~ /^cum/i ) or  # remove lines that start with cum., cumulative ...
      ($holdings =~ /^disk/i ) or
      ($holdings =~ /disc/i ) or
      ($holdings =~ /^draw/i ) or # drawings
      ($holdings =~ /^dup/i ) or # duplicates
      ($holdings =~ /^*dvd*/i ) or  # dvds
      ($holdings =~ /^*diskette*/i ) or  # dvds
      ($holdings =~ /^guide/i ) or  
      ($holdings =~ /^handbook/i ) or
      ($holdings =~ /ill/i ) or # Ill  Illus
      ($holdings =~ /^ind/i ) or  # index
      ($holdings =~ /info/i ) or  # info anywhere in line
      ($holdings =~ /intro/i ) or  # intro anywhere in line
      ($holdings =~ /instruc/i ) or #  instructor's manual, anywhere in line
      ($holdings =~ /jacket/i ) or  # jacket anywhere in line
      ($holdings =~ /^kit/i ) or #  
      ($holdings =~ /manu/i ) or # manuel, anywhere in line
      ($holdings =~ /^map/i ) or  #
      ($holdings =~ /micro/i ) or  # micro (fiche, film) anywhere in line
      ($holdings =~ /^plate/i ) or  #  
      ($holdings =~ /^portfolio/i ) or  #
      ($holdings =~ /^study/i ) or  #
      ($holdings =~ /supp/i ) or  # # supp anywhere in line
      ($holdings =~ /text/i ) or  #
      ($holdings =~ /^vis/i ) or  #  visual
      ($holdings =~ /^work/i ))   #  worksheets,etc.
    {  
      next;
    }
  
  # here strip each @iholdings of a-z then sort and see if last number = size of array and if so make summary statement
  my @iholdings = split(",", $holdings) ;

  if (scalar @iholdings > 1) { # only want to do this on holdings string with more than one item
    my @volumes = () ;
    
    foreach my $h (@iholdings) {
      $h =~ s/\s+//; # trim any white space
      my ($element, $numeric) = split(/\./, $h) ; 

      $numeric =~ s/\s+//g ;
      if ( ($numeric != "") and ($numeric =~ /^[0-9]*$/ ) ) { # check is not empty and is a number
	push(@volumes, $numeric) ;                            
      } # end $numeric is not null and is a number, should now have array of numbers
    } # end foreach iholding
    
     if (scalar @volumes > 3) { # short things prone to error and look fine anyway, fixing below v.1, v.2
       my $first = $volumes[0];
       my $last = $volumes[-1]; 
       if ($last - $first + 1 == scalar @iholdings  ) {
	 print "\n:Holdings: *$holdings* - FIRST: $first, LAST: $last\n" ;
	 print "    BECOMES: $iholdings[0] - $iholdings[-1] : size of  @ volumes = ", scalar @volumes, "\n" ;
	 $holdings = "$iholdings[0]-$iholdings[-1]" ;
      }
    } # end if volumes > 3
  } # more than one item in holdings string

  if ($holdings =~ /^V\.\s*?1,\s*?V\.\s*?2$/i) { # e.g. V. 1, V. 2 ;  v.1,v.2
    $holdings = "v.1-v.2" ;
  } # end if v.1, v.2

  if ($holdings =~ /^pt\.\s*?1,\s*?pt\.\s*?2$/i) { # pt
    $holdings = "pt.1-pt.2" ;
  } # end if pt.1, pt.2

  if ($holdings =~ /^Bd\.\s*?1,\s*?Bd\.\s*?2$/i) { # bd
    $holdings = "Bd.1-Bd.2" ;
  } # end if bd.1, bd.2

  if ($holdings =~ /^t\.\s*?1,\s*?t\.\s*?2$/i) { # t
    $holdings = "t.1-t.2" ;
  } # end if t.1, t.2

  if ($holdings =~ /^V\.\s*?1,\s*?V\.\s*?2,\s*?V\.\s*?3$/i) { # e.g. V. 1, V. 2, V. 3 ;  v.1,v.2,v.3
    $holdings = "v.1-v.3" ;
  } # end if v.1, v.2, v. 3
  
  if ($holdings =~ /^pt\.\s*?1,\s*?pt\.\s*?2,\s*?pt\.\s*?3$/i) { # pt
    $holdings = "pt.1-pt.3" ;
  } # end if p.1, p.2, p. 3

  if ($holdings =~ /^bd\.\s*?1,\s*?bd\.\s*?2,\s*?bd\.\s*?3$/i) { # bd
    $holdings = "Bd.1-Bd.3" ;
  } # end if bd.1, bd.2, bd. 3
  
  if ($holdings =~ /^t\.\s*?1,\s*?t\.\s*?2,\s*?t\.\s*?3$/i) { # t
    $holdings = "t.1-t.3" ;
  } # end if t.1, t.2, t. 3


  ++$totalwithholdings;
  #print "*$holdings*\n";
  print OUTPUT "$oclc\t$LSN\t$holdings\t$fromcallnumber" ;
  #if ($oldholdings ne $holdings) { print OUTPUT "\tFIXED" ; }
  print OUTPUT "\n" ;
    

} # end while input

close(OUTPUT); # marc recs w/o holdings recs


print "\n" ;

print "$totalrecs total records\n" ;
print "$totalwithholdings with holdings\n" ;

print "Done\n" ;
 
