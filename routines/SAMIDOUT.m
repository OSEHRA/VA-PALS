SAMIDOUT ;ven/toad - dd: output ;2018-02-06T00:00Z
 ;;18.0;SAMI;;
 ;
 ; Routine SAMIDOUT contains subroutines for outputing the data
 ; dictionary of SAMI fields to the va-pals repository in tab-delimited
 ; format
 ; CURRENTLY UNTESTED & IN PROGRESS
 ;
 quit  ; no entry from top
 ;
 ;
 ;
 ;@section 0 primary development
 ;
 ;
 ;
 ;@routine-credits
 ;@primary-dev: Frederick D. S. Marshall (toad)
 ; toad@vistaexpertise.net
 ;@primary-dev-org: Vista Expertise Network (ven)
 ; http://vistaexpertise.net
 ;@copyright: 2017-2018, toad, all rights reserved
 ;@license: Apache 2.0
 ; https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ;@last-updated: 2018-02-06T00:00Z
 ;@application: Screening Applications Management (SAM)
 ;@module: Screening Applications Management - IELCAP (SAMI)
 ;@suite-of-files: SAMI Forms (311.101-311.199)
 ;@version: 18.0T04
 ;@release-date: not yet released
 ;@patch-list: none yet
 ;
 ;@module-credits
 ;@project: VA Partnership to Increase Access to Lung Screening
 ; (VA-PALS)
 ; http://va-pals.org/
 ;@funding: 2017/2018, Bristol-Myers Squibb Foundation (bmsf)
 ; https://www.bms.com/about-us/responsibility/bristol-myers-squibb-foundation.html
 ;@partner-org: Veterans Affairs Office of Rural health
 ; https://www.ruralhealth.va.gov/
 ;@partner-org: International Early Lung Cancer Action Program (I-ELCAP)
 ; http://ielcap.com/
 ;@partner-org: Paraxial Technologies
 ; http://paraxialtech.com/
 ;@partner-org: Open Source Electronic Health Record Alliance (OSEHRA)
 ; https://www.osehra.org/groups/va-pals-open-source-project-group
 ;
 ;@module-log
 ; 2017-09-18 ven/toad v18.0t01 SAMIDOUT: create, building on Mash
 ; tools in %cp & %sfo; ONE,ALL.
 ;
 ; 2018-01-03 ven/toad v18.0t04 SAMIDOUT: convert dmis to ppis; stanza
 ; terminology; ONE,ALL.
 ;
 ; 2018-02-05 ven/toad v18.0t04 SAMIDOUT: upgrade license & attribution.
 ;
 ;@to-do
 ; annotate more fully
 ; develop examples, tests, mini-meter calls, and timers
 ;
 ;@contents
 ;
 ; ALL: code for ppi ALL^SAMID, export all sami dds
 ; ONE: code for ppi ONE^SAMID, export sami dd
 ;
 ;
 ;
 ;@section 1 ppis
 ;
 ;
 ;
ALL(SAMILOG) ; code for ppi ALL^SAMID, export all sami dds
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/toad;private;procedure;clean;silent;0% tests;SAC VIOLATIONS:
 ; 1. [tied to unix file name syntax]
 ; 2. lowercase calls: mini^%u
 ;@signature
 ; do ALL^SAMID()
 ;@branches-from
 ; ALL^SAMID
 ;@calls:
 ; mini^%u: performance mini-meter
 ; $$FIND1^DIC = find package by name
 ; GETS^DIQ: retrieve package git-repository path & file range
 ; ONE^SAMID: export SAMI dd
 ;@input:
 ; ^DIC(9.4) = file Package
 ;@output:
 ; file path/name-dd-m.csv created/updated for each file
 ;@examples: [tbd]
 ;@tests: [tbd]
 ;
 ; export is in quoted, tab-delimited format
 ;
 ;@stanza 2 fetch SAMI package#
 ;
 set:$get(SAMILOG)="" SAMILOG=0 ; default to no mini-meter
 do:SAMILOG mini^%u(2,.SAMILOG)
 ;
 new SAMIPKG set SAMIPKG="" ; package#
 do
 . new DIERR,DIMSG,DIHELP ; fileman status flags
 . new SAMIMSG
 . set SAMIPKG=$$FIND1^DIC(9.4,,"X","SAMI",,,"SAMIMSG") ; find by name
 . set SAMIPKG=SAMIPKG_"," ; convert to ien string
 . quit
 quit:'SAMIPKG  ; done if could not find package#
 ;
 ;@stanza 3 fetch git-repository path & file range
 ;
 do:SAMILOG mini^%u(3,.SAMILOG)
 ;
 new SAMIPATH set SAMIPATH="" ; path to git repository
 new SAMIMIN set SAMIMIN="" ; minimum file#
 new SAMIMAX set SAMIMAX="" ; maximum file#
 do
 . new DIERR,DIMSG,DIHELP ; fileman status flags
 . new SAMIFDA ; return array
 . ; retrieve fields *Lowest File Number, *Highest File Number, &
 . ; Silver Output Path
 . do GETS^DIQ(9.4,SAMIPKG,"10.6;11;310.03","I","SAMIFDA","SAMIMSG")
 . set SAMIPATH=$get(SAMIFDA(9.4,SAMIPKG,310.03,"I"))
 . set SAMIPKG("PATH")=SAMIPATH ; copy for input to ONE
 . set SAMIMIN=$get(SAMIFDA(9.4,SAMIPKG,10.6,"I"))
 . set SAMIMAX=$get(SAMIFDA(9.4,SAMIPKG,11,"I"))
 . set:SAMIMAX SAMIMAX=SAMIMAX_"999999" ; extend decimal depth of max
 . quit
 quit:SAMIPATH=""  ; done if no path to git repository
 quit:SAMIMIN=""  ; done if no minimum file#
 quit:SAMIMAX=""  ; done if no maximum file#
 ;
 ;@stanza 4 export SAMI files
 ;
 do:SAMILOG mini^%u(4,.SAMILOG)
 ;
 new SAMIFILE set SAMIFILE=$order(^DIC(SAMIMIN),-1) ; back up from min
 for  do  quit:SAMIFILE>SAMIMAX  ; traverse SAMI's files
 . set SAMIFILE=$order(^DIC(SAMIFILE))
 . quit:SAMIFILE>SAMIMAX  ; done if run out of SAMI file dds
 . quit:SAMIFILE=""  ; also done if run out of all files
 . ;
 . do ONE^SAMID(SAMIFILE,.SAMIPKG) ; export this SAMI dd
 . quit
 ;
 ;@stanza 5 termination
 ;
 do:SAMILOG mini^%u(5,.SAMILOG)
 ;
 quit  ; end of ALL
 ;
 ;
 ;
ONE(SAMIDD,SAMIPKG,SAMILOG) ; code for ppi ONE^SAMID, export sami dd
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/toad;private;procedure;clean;silent;0% tests;SAC VIOLATIONS:
 ; 1. [tied to unix file name syntax]
 ; 2. lowercase calls: mini^%u,$$lowcase^%ts,properties^%sfo
 ;@signature
 ; do ONE^SAMID(SAMIDD,.SAMIPKG)
 ;@branches-from
 ; ALL^SAMID
 ;@calls:
 ; mini^%u: performance mini-meter
 ; FILE^DID: retrieve file name
 ; $$lowcase^%ts = convert string to lowercase
 ; properties^%sfo: build field table
 ; $$GTF^%ZISH: pseudo-function to copy array to host file
 ;@input:
 ; SAMIDD = dd# of file definition to output
 ;.SAMIPKG = package#
 ; SAMIPKG("PATH") = directory path to dd-output repository
 ;@output:
 ; file path/name-dd-m.csv created/updated
 ;@examples: [tbd]
 ;@tests: [tbd]
 ;
 ; export is in quoted, tab-delimited format
 ;
 ;@stanza 2 calculate export-file name
 ;
 set:$get(SAMILOG)="" SAMILOG=0 ; default to no mini-meter
 do:SAMILOG mini^%u(2,.SAMILOG)
 ;
 new SAMINAME set SAMINAME="" ; fileman-file name
 do
 . new DIERR,DIMSG,DIHELP ; fileman status flags
 . new SAMIATT ; file attributes array
 . new SAMIMSG ; dba message array
 . do FILE^DID(SAMIDD,,"NAME","SAMIATT","SAMIMSG") ; get file name
 . quit:$get(DIERR)  ; done if dd file retriever fails
 . set SAMINAME=$get(SAMIATT("NAME")) ; file name
 . quit
 quit:SAMINAME=""  ; done if no file retrieved
 ;
 ; clear package prefix from file name
 set:$extract(SAMINAME,1,5)="SAMI " $extract(SAMINAME,1,5)=""
 set SAMINAME=$$lowcase^%ts(SAMINAME) ; convert to lowercase
 set SAMINAME=$translate(SAMINAME," _/.","---") ; normalize punctuation
 set SAMINAME=SAMINAME_"-dd-m.csv" ; append std export-file suffix
 ;
 ;@stanza 3 generate dd-export array
 ;
 do:SAMILOG mini^%u(3,.SAMILOG)
 ;
 do
 . kill ^TMP("SAMIDOUT",$job) ; clear loading dock
 . new SAMIFLDS ; field table
 . do properties^%sfo(.SAMIFLDS,SAMIDD) ; build table
 . quit:'$data(SAMIFLDS(1)) ; done if no content returned
 . kill SAMIFLDS("key") ; remove field index
 . merge ^TMP("SAMIDOUT",$job)=SAMIFLDS ; copy table to loading dock
 . quit
 quit:'$data(^TMP("SAMIDOUT",$job))  ; done if loading dock empty
 ;
 ;@stanza 4 set new dd-export file
 ;
 do:SAMILOG mini^%u(4,.SAMILOG)
 ;
 do
 . new SAMIROOT set SAMIROOT=$name(^TMP("SAMIDOUT",$job,0)) ; dock root
 . ;
 . new SAMIPATH set SAMIPATH=$get(SAMIPKG("PATH")) ; path to repository
 . quit:SAMIPATH=""  ; can't export w/o path
 . set SAMIPATH=SAMIPATH_"elements/dd/" ; extend path to dd elements
 . ;
 . ; export dd
 . new PSEUDO set PSEUDO=$$GTF^%ZISH(SAMIROOT,3,SAMIPATH,SAMINAME)
 . kill ^TMP("SAMIDOUT",$job) ; clear loading dock
 . quit
 ;
 ;@stanza 5 termination
 ;
 do:SAMILOG mini^%u(5,.SAMILOG)
 ;
 quit  ; end of ONE
 ;
 ;
 ;
EOR ; end of routine SAMIDOUT
