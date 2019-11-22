SAMIHOM4 ;ven/gpl,arc - ielcap: forms;2018-11-30T17:45Z ; 4/16/19 12:17pm
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; @section 0 primary development
 ;
 ; @routine-credits
 ; @primary-dev: George P. Lilly (gpl)
 ;  gpl@vistaexpertise.net
 ; @additional-dev: Alexis Carlson (arc)
 ;  alexis@vistaexpertise.net
 ; @primary-dev-org: Vista Expertise Network (ven)
 ;  http://vistaexpertise.net
 ; @copyright: 2012/2018, ven, all rights reserved
 ; @license: Apache 2.0
 ;  https://www.apache.org/licenses/LICENSE-2.0.html
 ;
 ; @application: SAMI
 ; @version: 18.0
 ; @patch-list: none yet
 ;
 ; @to-do
 ;   Add label comments
 ;
 ; @section 1 code
 ;
 quit  ; No entry from top
 ;
 ;
WSHOME ; web service for SAMI homepage
 ; WSHOME^SAMIHOM3(SAMIRTN,SAMIFILTER) goto WSHOME^SAMIHOM4
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;web service;procedure;
 ;@called-by
 ;@calls
 ; GETHOME
 ;@input
 ; SAMIFILTER
 ;@output
 ;.SAMIRTN
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ; no parameters required
 ;
 ;@stanza 2 present development or temporary homepage
 ;
 if $get(SAMIFILTER("test"))=1 do  quit
 . do DEVHOME^SAMIHOM3(.SAMIRTN,.SAMIFILTER)
 . quit
 ;
 if $g(SAMIFILTER("samiroute"))'="" do  quit  ; workaround for "get" access to pages
 . new SAMIBODY set SAMIBODY(1)=""
 . do WSVAPALS^SAMIHOM3(.SAMIFILTER,.SAMIBODY,.SAMIRTN)
 ;
 if $get(SAMIFILTER("dfn"))'="" do  quit  ; V4W/DLW - workaround for "get" access from CPRS
 . new dfn set dfn=$get(SAMIFILTER("dfn"))
 . new root set root=$$setroot^%wd("vapals-patients")
 . new studyid set studyid=$get(@root@(dfn,"samistudyid"))
 . new SAMIBODY
 . if studyid'="" do
 . . set SAMIBODY(1)="samiroute=casereview&dfn="_dfn_"&studyid="_studyid
 . else  do
 . . set SAMIBODY(1)="samiroute=lookup&dfn="_dfn_"&studyid="_studyid
 . do WSVAPALS^SAMIHOM3(.SAMIFILTER,.SAMIBODY,.SAMIRTN)
 ;
 do GETHOME^SAMIHOM3(.SAMIRTN,.SAMIFILTER) ; VAPALS homepage
 ;
 ;@stanza 3 termination
 ;
 quit  ; end of WSHOME
 ;
 ;
WSVAPALS ; vapals post web service - all calls come through this gateway
 ; WSVAPALS^SAMIHOM3(SAMIARG,SAMIBODY,SAMIRESULT) goto WSVAPALS^SAMIHOM4
 m ^SAMIUL("vapals")=SAMIARG
 m ^SAMIUL("vapals","BODY")=SAMIBODY
 ;
 new vars,SAMIBDY
 set SAMIBDY=$get(SAMIBODY(1))
 do parseBody^%wf("vars",.SAMIBDY)
 m vars=SAMIARG
 k ^SAMIUL("vapals","vars")
 merge ^SAMIUL("vapals","vars")=vars
 ;
 n route s route=$g(vars("samiroute"))
 i route=""  d GETHOME^SAMIHOM3(.SAMIRESULT,.SAMIARG) ; on error go home
 ;
 i route="lookup" d  q  ;
 . m SAMIARG=vars
 . d WSLOOKUP^SAMISRC2(.SAMIARG,.SAMIBODY,.SAMIRESULT)
 ;
 i route="newcase" d  q  ;
 . m SAMIARG=vars
 . d WSNEWCAS^SAMIHOM3(.SAMIARG,.SAMIBODY,.SAMIRESULT)
 ;
 i route="casereview" d  q  ;
 . m SAMIARG=vars
 . d WSCASE^SAMICASE(.SAMIRESULT,.SAMIARG)
 ;
 i route="nuform" d  q  ;
 . m SAMIARG=vars
 . d WSNUFORM^SAMICASE(.SAMIRESULT,.SAMIARG)
 ;
 i route="addform" d  q  ;
 . m SAMIARG=vars
 . d WSNFPOST^SAMICASE(.SAMIARG,.SAMIBODY,.SAMIRESULT)
 ;
 i route="form" d  q  ;
 . m SAMIARG=vars
 . d wsGetForm^%wf(.SAMIRESULT,.SAMIARG)
 ;
 i route="postform" d  q  ;
 . m SAMIARG=vars
 . d wsPostForm^%wf(.SAMIARG,.SAMIBODY,.SAMIRESULT)
 . i $g(SAMIARG("form"))["siform" d  ;
 . . if $$NOTE^SAMINOT1(.SAMIARG) d  ;
 . . . n SAMIFILTER
 . . . s SAMIFILTER("studyid")=$G(SAMIARG("studyid"))
 . . . s SAMIFILTER("form")=$g(SAMIARG("form")) ;
 . . . n tiuien
 . . . s tiuien=$$SV2VISTA^SAMIVSTA(.SAMIFILTER)
 . . . s SAMIFILTER("tiuien")=tiuien
 . . . ;d SV2VSTA^SAMIVSTA(.FILTER)
 . . . m ^SAMIUL("newFILTER")=SAMIFILTER
 . . . d WSNOTE^SAMINOT1(.SAMIRESULT,.SAMIARG)
 ;
 i route="deleteform" d  q  ;
 . m SAMIARG=vars
 . d DELFORM^SAMICASE(.SAMIRESULT,.SAMIARG)
 ;
 i route="ctreport" d  q  ;
 . m SAMIARG=vars
 . d WSREPORT^SAMICTR0(.SAMIRESULT,.SAMIARG)
 . ;d wsReport^SAMICTRT(.SAMIRESULT,.SAMIARG)
 ;
 i route="note" d  q  ; 
 . m SAMIARG=vars
 . d WSNOTE^SAMINOT1(.SAMIRESULT,.SAMIARG)
 ;
 i route="report" d  q  ; 
 . m SAMIARG=vars
 . d WSREPORT^SAMIUR(.SAMIRESULT,.vars)
 ;
 i route="addperson" d  q  ;
 . m SAMIARG=vars
 . n form
 . s form="vapals:addperson"
 . d RTNPAGE^SAMIHOM4(.SAMIRESULT,form,.SAMIARG) q  ;
 ;
 i route="editperson" d  q  ;
 . m SAMIARG=vars
 . n sid s sid=$g(vars("studyid")) ; must have a sid
 . i sid="" d  q  ;
 . . d GETHOME^SAMIHOM3(.SAMIRESULT,.SAMIARG) ; on error go home 
 . n sien s sien=$$SID2NUM^SAMIHOM3(sid)
 . i sien="" d  q  ;
 . . d GETHOME^SAMIHOM3(.SAMIRESULT,.SAMIARG) ; on error go home 
 . n root s root=$$setroot^%wd("vapals-patients")
 . s vars("saminame")=$g(@root@(sien,"saminame"))
 . s vars("dob")=$g(@root@(sien,"dob"))
 . s vars("sbdob")=$g(@root@(sien,"dob"))
 . s vars("gender")=$g(@root@(sien,"gender"))
 . s vars("sex")=$g(@root@(sien,"sex"))
 . s vars("icn")=$g(@root@(sien,"icn"))
 . s vars("ssn")=$g(@root@(sien,"ssn"))
 . s vars("last5")=$g(@root@(sien,"last5"))
 . s vars("dfn")=$g(@root@(sien,"dfn"))
 . m SAMIARG=vars
 . n form,err,zhtml
 . s form="vapals:addperson"
 . d RTNPAGE^SAMIHOM4(.SAMIRESULT,form,.SAMIARG) q  ;
 ;
 i route="register" d  q  ;
 . m SAMIARG=vars
 . d REG^SAMIHOM4(.SAMIRESULT,.SAMIARG)
 ; 
 quit  ; End of WSVAPALS
 ;
 ;
REG(SAMIRTN,SAMIARG) ; manual registration
 ;
 m ^gpl("reg")=SAMIARG
 n ssn s ssn=SAMIARG("ssn")
 s ssn=$tr(ssn,"-")
 s SAMIARG("errorMessage")=""
 s SAMIARG("errorField")=""
 ; test for duplicate ssn
 ;
 i $$DUPSSN(ssn) d  ;
 . ;s SAMIARG("errorMessage")=SAMIARG("errorMessage")_" Duplicate SSN."
 . s SAMIARG("errorMessage")=SAMIARG("errorMessage")_" Duplicate SSN error. A person with that SSN is already entered in the system."
 . s SAMIARG("errorField")="ssn"
 ;
 ; test for duplicate icn
 ;
 n icn s icn=$g(SAMIARG("icn"))
 i icn'="" i $$DUPICN(icn) d  ;
 . s SAMIARG("errorMessage")=SAMIARG("errorMessage")_" Duplicate ICN error. A person with that ICN is already entered in the system."
 . s SAMIARG("errorField")="icn"
 ;
 ; test for wellformed ICN
 ;
 i icn'="" i $$BADICN(icn) d  ;
 . s SAMIARG("errorMessage")=SAMIARG("errorMessage")_" Invalid ICN error. The check digits in the ICN do not match"
 . s SAMIARG("errorField")="icn"
 ;
 ; if there is an error, send back to edit with error message
 i $g(SAMIARG("errorMessage"))'="" d  q  ;
 . n form
 . s form="vapals:addperson"
 . d RTNERR(.SAMIRESULT,form,.SAMIARG)
 ;
 n root s root=$$setroot^%wd("patient-lookup")
 n proot s proot=$$setroot^%wd("vapals-patients")
 n ptlkien s ptlkien=""
 n sid s sid=$g(SAMIARG("studyid"))
 n dfn s dfn=""
 n sien s sien=""
 i sid'="" d  ; this is an edit
 . s sien=$$SID2NUM^SAMIHOM3(sid)
 . s dfn=$g(@proot@(sien,"dfn"))
 . s pklkien=$o(@root@("dfn",dfn,"")) ; patient lookup ien
 i ptlkien="" s ptlkien=$o(@root@("AAAAAA"),-1)+1
 n name s name=$g(SAMIARG("name"))
 s @root@(ptlkien,"saminame")=name
 s @root@(ptlkien,"sinamef")=$p(name,",",1)
 s @root@(ptlkien,"sinamel")=$p(name,",",2)
 n fmdob s fmdob=$$FMDT^SAMIUR2(SAMIARG("dob"))
 n ptlkdob s ptlkdob=$$FMTE^XLFDT(fmdob,7)
 s ptlkdob=$TR(ptlkdob,"/","-")
 s @root@(ptlkien,"dob")=ptlkdob
 s @root@(ptlkien,"sbdob")=ptlkdob
 n gender s gender=SAMIARG("gender")
 s @root@(ptlkien,"gender")=$s(gender="M":"M^MALE",1:"F^FEMALE")
 s @root@(ptlkien,"sex")=SAMIARG("gender")
 s @root@(ptlkien,"icn")=SAMIARG("icn")
 s @root@(ptlkien,"ssn")=ssn
 n last5 s last5=$$UCASE($e(name,1))_$e(ssn,6,9)
 s @root@(ptlkien,"last5")=last5
 ;n dfn
 s dfn=$o(@root@("dfn"," "),-1)+1
 i dfn<9000001 s dfn=9000001
 s @root@(ptlkien,"dfn")=dfn
 d INDXPTLK(ptlkien)
 s SAMIFILTER("samiroute")="addperson"
 d SETINFO(.SAMIFILTER,name_" was successfully entered")
 ;d SETWARN(.SAMIFILTER,"We might want to give you a warning")
 do WSVAPALS^SAMIHOM3(.SAMIFILTER,.SAMIARG,.SAMIRESULT)
 q
 ;
DUPSSN(ssn) ; extrinsic returns true if duplicate ssn
 n proot s proot=$$setroot^%wd("patient-lookup")
 i $d(@proot@("ssn",ssn)) q 1
 q 0
 ;
DUPICN(icn) ; extrinsic returns true if duplicate icn
 n proot s proot=$$setroot^%wd("patient-lookup")
 n tmpicn s tmpicn=$p(icn,"V",1)
 i $d(@proot@("icn",icn)) q 1
 i $d(@proot@("icn",tmpicn)) q 1
 q 0
 ;
BADICN(icn) ; extrinsic returns true if ICN checkdigits are wrong
 n zchk s zchk=$p(icn,"V",2)
 n zicn s zicn=$p(icn,"V",1)
 q:zchk="" 1
 i zchk'=$$CHECKDG^MPIFSPC(zicn) q 1
 q 0
 ;
SETINFO(vars,msg) ; set the information message text
 ; vars are the screen variables passed by reference
 s vars("infoMessage")=msg
 q
 ;
SETWARN(vars,msg) ; set warning message text
 ; vars are the screen variables passed by reference
 s vars("warnMessage")=msg
 q
 ; 
RTNERR(rtn,form,vals,msg,fld) ; redisplays a page with an error message
 ; rtn is the return array
 ; form is the form the page requires
 ; vals are the values for the page. passed by reference
 ; msg is the error message to be displayed
 ; fld is the name of the field where the cursor should be put
 ;
 n zhtml ; work area for the tempate
 d SAMIHTM^%wf(.zhtml,form,.err)
 d MERGEHTM^%wf(.zhtml,.vals,.err)
 m SAMIRESULT=zhtml
 set HTTPRSP("mime")="text/html" ; set mime type
 q
 ;
RTNPAGE(rtn,form,vals) ; displays a page
 ; rtn is the return array
 ; form is the form the page requires
 ; vals are the values for the page. passed by reference
 ;
 n err
 n zhtml ; work area for the tempate
 d SAMIHTM^%wf(.zhtml,form,.err)
 d MERGEHTM^%wf(.zhtml,.vals,.err)
 m SAMIRESULT=zhtml
 set HTTPRSP("mime")="text/html" ; set mime type
 q
 ;
REINDXPL ; reindex patient lookup
 n root s root=$$setroot^%wd("patient-lookup")
 n zi s zi=0
 k @root@("ssn")
 k @root@("name")
 k @root@("last5")
 k @root@("sinamef")
 k @root@("sinamel")
 k @root@("icn")
 f  s zi=$o(@root@(zi)) q:+zi=0  d  ;
 . d INDXPTLK(zi)
 q
 ;
INDXPTLK(ien) ; generate index entries in patient-lookup graph
 ; for entry ien
 n proot set proot=$$setroot^%wd("patient-lookup")
 n name s name=$g(@proot@(ien,"saminame"))
 s @proot@("name",name,ien)=""
 n ucname s ucname=$$UCASE(name)
 s @proot@("name",ucname,ien)=""
 n x
 s x=$g(@proot@(ien,"dfn")) w !,x
 s:x'="" @proot@("dfn",x,ien)=""
 s x=$g(@proot@(ien,"last5")) w !,x
 s:x'="" @proot@("last5",x,ien)=""
 s x=$g(@proot@(ien,"icn")) w !,x
 i x'["V" d  ;
 . n chk s chk=$$CHECKDG^MPIFSPC(x)
 . s @proot@(ien,"icn")=x_"V"_chk
 . s x=x_"V"_chk
 s:x'="" @proot@("icn",x,ien)=""
 s x=$g(@proot@(ien,"ssn")) w !,x
 s:x'="" @proot@("ssn",x,ien)=""
 s x=$g(@proot@(ien,"sinamef")) w !,x
 s:x'="" @proot@("sinamef",x,ien)=""
 s x=$g(@proot@(ien,"sinamel")) w !,x
 s:x'="" @proot@("sinamel",x,ien)=""
 set @proot@("Date Last Updated")=$$HTE^XLFDT($horolog)
 q
 ;
UCASE(STR) ; extrinsic returns uppercase of STR
 N X,Y
 S X=STR
 X ^%ZOSF("UPPERCASE")
 q Y
 ;
DEVHOME ; temporary home page for development
 ; DEVHOME^SAMIHOM3(SAMIRTN,SAMIFILTER) goto DEVHOME^SAMIHOM4
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by
 ; WSHOME
 ;@calls
 ; htmltb2^%yottaweb
 ; PATLIST
 ; genhtml^%yottautl
 ; addary^%yottautl
 ;@input
 ; SAMIFILTER =
 ;@output
 ;.SAMIRTN =
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 ?
 ;
 new gtop,gbot
 do htmltb2^%yottaweb(.gtop,.gbot,"SAMI Test Patients")
 ;
 new html,ary,hpat
 do PATLIST^SAMIHOM3("hpat")
 quit:'$data(hpat)
 ;
 set ary("title")="SAMI Test Patients on this system"
 set ary("header",1)="StudyId"
 set ary("header",2)="Name"
 ;
 new cnt set cnt=0
 new zi set zi=""
 for  set zi=$order(hpat(zi)) quit:zi=""  do  ;
 . set cnt=cnt+1
 . new url set url="<a href=""/cform.cgi?studyId="_zi_""">"_zi_"</a>"
 . set ary(cnt,1)=url
 . set ary(cnt,2)=""
 . quit
 ;
 do genhtml^%yottautl("html","ary")
 ;
 do addary^%yottautl("SAMIRTN","gtop")
 do addary^%yottautl("SAMIRTN","html")
 set SAMIRTN($order(SAMIRTN(""),-1)+1)=gbot
 kill SAMIRTN(0)
 ;
 set HTTPRSP("mime")="text/html"
 ;
 ;@stanza ? termination
 ;
 quit  ; end of DEVHOME
 ;
 ;
GETHOME ; homepage accessed using GET
 ; GETHOME^SAMIHOM3(SAMIRTN,SAMIFILTER) goto GETHOME^SAMIHOM4
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by
 ; WSHOME
 ; WSNEWCAS
 ; WSNFPOST^SAMICASE
 ; wsLookup^SAMISRCH
 ;@calls
 ; GETTMPL^SAMICASE
 ; findReplace^%ts
 ; $$SCANFOR
 ; ADDCRLF^VPRJRUT
 ;@input
 ; SAMIFILTER =
 ;@output
 ;.SAMIRTN =
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 get template for homepage
 ;
 new temp,tout
 do GETTMPL^SAMICASE("temp","vapals:home")
 quit:'$data(temp)
 ;
 ;@stanza 3 process homepage template
 ;
 new cnt set cnt=0
 new zi set zi=0
 for  set zi=$order(temp(zi)) quit:+zi=0  do  ;
 . ;
 . n ln s ln=temp(zi)
 . n touched s touched=0
 . ;
 . i ln["href" i 'touched d  ;
 . . d FIXHREF^SAMIFORM(.ln)
 . . s temp(zi)=ln
 . ;
 . i ln["src" d  ;
 . . d FIXSRC^SAMIFORM(.ln)
 . . s temp(zi)=ln
 . ;
 . i ln["id" i ln["studyIdMenu" d  ;
 . . s zi=zi+4
 . ;
 . set cnt=cnt+1
 . set tout(cnt)=temp(zi)
 . quit
 ;
 ;@stanza 4 add cr/lf & save to return array
 ;
 do ADDCRLF^VPRJRUT(.tout)
 merge SAMIRTN=tout
 ;
 ;@stanza 5 termination
 ;
 quit  ; end of GETHOME
 ;
 ;
WSNEWCAS ; receives post from home & creates new case
 ; WSNEWCAS^SAMIHOM3(SAMIARGS,SAMIBODY,SAMIRESULT) goto WSNEWCAS^SAMIHOM4
 ;
 ;@stanza 1 invocation, binding, & branching
 ;
 ;ven/gpl;private;procedure;
 ;@called-by
 ;@calls
 ; parseBody^%wf
 ; $$setroot^%wd
 ; $$NEXTNUM
 ; $$GENSTDID^SAMIHOM3
 ; $$NOW^XLFDT
 ; $$KEYDATE^SAMIHOM3
 ; $$VALDTNM
 ; GETHOME
 ; PREFILL
 ; MKSBFORM
 ; MKSIFORM^SAMIHOM3
 ; WSCASE^SAMICASE
 ;@input
 ;.ARGS =
 ; BODY =
 ;.RESULT =
 ;@output: ?
 ;@examples [tbd]
 ;@tests [tbd]
 ;
 ;@stanza 2 ?
 ;
 merge ^SAMIUL("newCase","ARGS")=SAMIARGS
 merge ^SAMIUL("newCase","BODY")=SAMIBODY
 ;
 new vars,bdy
 set SAMIBDY=$get(SAMIBODY(1))
 do parseBody^%wf("vars",.SAMIBDY)
 merge ^SAMIUL("newCase","vars")=vars
 ;
 new root set root=$$setroot^%wd("vapals-patients")
 ;
 new saminame set saminame=$get(vars("name"))
 if saminame="" s saminame=$get(vars("saminame"))
 ;if $$VALDTNM(saminame,.ARGS)=-1 do  quit  ;
 ;. new r1
 ;. do GETHOME(.r1,.ARGS) ; home page to redisplay
 ;. merge RESULT=r1
 ;. quit
 ;
 new dfn s dfn=$get(vars("dfn"))
 ;if dfn="" do  quit  ;
 ;. new r1
 ;. do GETHOME(.r1,.ARGS) ; home page to redisplay
 ;. merge RESULT=r1
 ;. quit
 ;
 ;new gien set gien=$$NEXTNUM
 new gien set gien=dfn
 ;
 m ^SAMIUL("newCase","G1")=root
 ; create dfn index
 set @root@("dfn",dfn,gien)=""
 ;
 set @root@(gien,"saminum")=gien
 set @root@(gien,"saminame")=saminame
 ;
 new studyid set studyid=$$GENSTDID^SAMIHOM3(gien)
 set @root@(gien,"samistudyid")=studyid
 set @root@("sid",studyid,gien)=""
 ;
 new datekey set datekey=$$KEYDATE^SAMIHOM3($$NOW^XLFDT)
 set @root@(gien,"samicreatedate")=datekey
 ;
 merge ^SAMIUL("newCase",gien)=@root@(gien)
 ;
 ;
 do PREFILL^SAMIHOM3(dfn) ; prefills from the "patient-lookup" graph
 ;
 n siformkey
 ;do makeSbform(gien) ; create a background form for new patient
 set siformkey=$$MKSIFORM^SAMIHOM3(gien) ; create an intake for for new patient
 ;
 set SAMIARGS("studyid")=studyid
 set SAMIARGS("form")="vapals:"_siformkey
 do wsGetForm^%wf(.SAMIRESULT,.SAMIARGS)
 ;do WSCASE^SAMICASE(.SAMIRESULT,.SAMIARGS) ; navigate to the case review page
 ;
 ;@stanza ? termination
 ;
 quit  ; end of WSNEWCAS
 ;
 ;
EOR ; End of routine SAMIHOM4
