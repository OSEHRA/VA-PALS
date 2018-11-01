SAMIRU ;ven/gpl - sami user reports ;2018-03-08T17:53Z
 ;;18.0;SAM;;
 ;
 ; SAMIRU contains the routines to handle rural/urban status
 ; It is currently untested & in progress.
 ;
 quit  ; no entry from top
 ;
 ; sirs = rural status r,u,n
 ; sipsa = preferred address
 ;
 ; $$UrbanRural^SAMIVSTA(zipcode) returns r u
 ;
 ; NCHS Urban-Rural graph for zip code table
 ;
index ; create the zip index in the zip graph
 n root
 s root=$$setroot^%wd("NCHS Urban-Rural")
 n zi s zi=0
 f  s zi=$o(@root@(zi)) q:+zi=0  d  ;
 . n ruca30
 . s ruca30=$g(@root@(zi,"ruca30"))
 . q:ruca30=""
 . s @root@("zip",zi)=ruca30
 q
 ;
wsGetRU(rtn,filter) ; web service to return counts for rural and urban
 ;
 n root s root=$$setroot^%wd("vapals-patients")
 n rural,urban
 s (rural,urban)=0
 n zi s zi=0
 f  s zi=$o(@root@(zi)) q:+zi=0  d  ;
 . n sid s sid=@root@(zi,"sisid")
 . q:sid=""
 . n gr s gr=$na(@root@("graph",sid))
 . n siform
 . s siform=$o(@gr@("siform-"))
 . i $g(@gr@(siform,"sirs"))="u" s urban=urban+1
 . i $g(@gr@(siform,"sirs"))="r" s rural=rural+1
 n rslt
 s rslt("result","urban")=urban
 s rslt("result","rural")=rural
 d ENCODE^VPRJSON("rslt","rtn")
 q
 ;
