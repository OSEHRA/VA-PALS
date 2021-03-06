SAMIUTS2 ;ven/lgc - UNIT TEST for SAMICASE,SAMICAS2,SAMICAS3 ;Jan 17, 2020@12:52
 ;;18.0;SAMI;;
 ;
 ;@license: see routine SAMIUL
 ;
 ; @section 0 primary development
 ;
 ; @routine-credits
 ; @primary-dev: Larry Carlson (lgc)
 ;  larry@fiscientific.com
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
 ;
 ; @section 1 code
 ;
START I $t(^%ut)="" W !,"*** UNIT TEST NOT INSTALLEd ***" Q
 d EN^%ut($t(+0),2)
 Q
 ;
 ;
STARTUP n utsuccess
 D SVAPT1^SAMIUTST  ; Save VA's DFN 1 patient data
 D LOADTPT^SAMIUTST  ; Load unit test patient data
 q
 ;
SETUP q
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 k utsuccess
 D LVAPT1^SAMIUTST  ; Return VA's DPT 1 patient's data
 q
 ;
 ;
UTQUIT ; @TEST - Quit at top of routine
 D ^SAMICASE
 d SUCCEED^%ut
 D ^SAMICAS2
 d SUCCEED^%ut
 D ^SAMICAS3
 d SUCCEED^%ut
 q
 ;
UTGTMPL ; @TEST - get html template
 ;GETTMPL(return,form)
 n temp,SAMIUPOO
 d GETTMPL^SAMICASE("temp","vapals:casereview")
 D SVUTARR^SAMIUTST(.temp,"UTGTMPL^SAMIUTS2")
 d PLUTARR^SAMIUTST(.SAMIUPOO,"UTGTMPL^SAMIUTS2")
 s utsuccess=1
 n nodep,nodet s nodep=$na(SAMIUPOO),nodet=$na(temp)
 f  s nodep=$q(@nodep),nodet=$q(@nodet) q:nodep=""  d  q:'utsuccess
 .; ignore the one node in arrays that have a date as
 .;  we can't know ahead of time what date the unit test
 .;  will be run on
 . i $e($tr(@nodep,""""" "),1,10)?4N1"."2N1"."2N q
 . i (@nodep["meta content") q
 . i '(@nodep=@nodet) s utsuccess=0
 i '(nodet="") s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing getting vapals:casereview template FAILED!")
 q
 ;
UTHMNY ; @TEST - extrinsic returns how many forms the patient has used before deleting a patient
 ;CNTITEMS(sid)
 n rootvp,gienut,dfn,gienvp,studyid,uforms,forms
 ; get test patient
 s dfn=1
 ; get studyid on patient
 set rootvp=$$setroot^%wd("vapals-patients")
 s gienvp=$O(@rootvp@("dfn",dfn,0))
 i '$g(gienvp) d  q
 . d FAIL^%ut("Test patient not found in vapals-patients Graphstore")
 s studyid=$G(@rootvp@(gienvp,"sisid"))
 i '$l($g(studyid)) d  q
 . d FAIL^%ut("Test patient did not have studyid in vapals-patients Graphstore")
 ; get number of forms on test patient
 n uforms,forms,zi s uforms=0,zi=""
 f  s zi=$o(@rootvp@("graph",studyid,zi)) q:zi=""  d
 . s uforms=uforms+1
 s forms=$$CNTITEMS^SAMICAS2(studyid)
 s utsuccess=(uforms=forms)
 d CHKEQ^%ut(utsuccess,1,"Testing getting how many forms for patient FAIL!")
 q
 ;
UTCNTITM ; @TEST - get items available for studyid
 ;GETITEMS(ary,sid)
 n rootvp,gienut,dfn,gienvp,studyid,uforms,forms
 ; get test patient
 s dfn=1
 ; get studyid on patient
 set rootvp=$$setroot^%wd("vapals-patients")
 s gienvp=$O(@rootvp@("dfn",dfn,0))
 i '$g(gienvp) d  q
 . d FAIL^%ut("Test patient not found in vapals-patients Graphstore")
 s studyid=$G(@rootvp@(gienvp,"sisid"))
 i '$l($g(studyid)) d  q
 . d FAIL^%ut("Test patient did not have studyid in vapals-patients Graphstore")
 ; get number of forms on test patient
 n uforms,forms,zi s uforms=0,zi=""
 f  s zi=$o(@rootvp@("graph",studyid,zi)) q:zi=""  d
 . s uforms(zi)=""
 d GETITEMS^SAMICASE("SAMIUPOO",studyid)
 s utsuccess=1
 s zi="" f  s zi=$o(uforms(zi)) q:zi=""  d
 . i '$d(SAMIUPOO(zi)) s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing getting available forms for patient FAILED!")
 q
 ;
UTGDTK ; @TEST - date portion of form key
 ;getDateKey(formid)
 n fdtkey s fdtkey=$$GETDTKEY^SAMICAS2("MYFORM-2018-10-03")
 d CHKEQ^%ut(fdtkey,"2018-10-03","Testing get date portion of form  FAILED!")
 q
 ;
UTK2DDT ; @TEST - date in elcap format from key date
 ;KEY2DSPD(zkey)
 n ecpdt s ecpdt=$$KEY2DSPD^SAMICAS2("2018-10-03")
 d CHKEQ^%ut(ecpdt,"10/3/2018","Testing date in elcap form  FAILED!")
 q
 ;
UTVPLSD ; @TEST - extrinsic which return the vapals format for dates
 ;VAPALSDT(fmdate)
 n vpdate s vpdate=$$VAPALSDT^SAMICASE("3181003")
 d CHKEQ^%ut(vpdate,"10/3/2018","Testing fmdate to elcap date form  FAILED!")
 q
 ;
UTWSNF ; @TEST - select new form for patient (get service)
 ;WSNUFORM(rtn,filter)
 n rtn,SAMIUARGS,SAMIUPOO,SAMIUARC
 s SAMIUARGS("studyid")="XXX00001"
 d WSNUFORM^SAMICASE(.SAMIUPOO,.SAMIUARGS)
 d PLUTARR^SAMIUTST(.SAMIUARC,"UTWSNF^SAMIUTS2")
 s utsuccess=1
 n nodep,nodea s nodep=$na(SAMIUPOO),nodea=$na(SAMIUARC)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d  q:'utsuccess
 . i $e($tr(@nodea," "),1,10)?4N1P2N1P2N q
 . i @nodea["<meta" q
 . i '(@nodep=@nodea) s utsuccess=0
 i '(nodea="") s utsuccess=0
 d CHKEQ^%ut(1,utsuccess,"Testing wsNuForm FAILED!")
 q
 ;
UTK2FM ; @TEST - convert a key to a fileman date
 ; KEY2FM
 n SAMIKEY,fmd
 s SAMIKEY="unittestform-2018-11-13"
 s fmd=$$KEY2FM^SAMICASE(SAMIKEY)
 s utsuccess=(fmd=3181113)
 d CHKEQ^%ut(1,utsuccess,"Testing key2fm FAILED!")
 q
 ;
UTMKSBF ; @TEST - create background form
 ;MKSBFORM(sid,key)
 d CHKFORM^SAMIUTS2("sbform","MKSBFORM",.utsuccess)
 d CHKEQ^%ut(1,utsuccess,"Testing create background form FAILED!")
 q
 ;
UTMKCEF ; @TEST - create ct evaluation form
 ;MKCEFORM(sid,key)
 d CHKFORM^SAMIUTS2("ceform","MKCEFORM",.utsuccess)
 d CHKEQ^%ut(utsuccess,1,"Testing create ct eval form FAILED!")
 q
 ;
UTMKFUF ; @TEST - create Follow-up form
 ;MKFUFORM(sid,key)
 d CHKFORM^SAMIUTS2("fuform","MKFUFORM",.utsuccess)
 d CHKEQ^%ut(utsuccess,1,"Testing create followup  form FAILED!")
 q
 ;
UTMKPTF ; @TEST - create pt form
 ;MKPTFORM(sid,key)
 d CHKFORM^SAMIUTS2("ptform","MKPTFORM",.utsuccess)
 d CHKEQ^%ut(utsuccess,1,"Testing create pt form FAILED!")
 q
 ;
UTMKITF ; @TEST - create intervention form
 ;MKITFORM(sid,key)
 d CHKFORM^SAMIUTS2("itform","MKITFORM",.utsuccess)
 d CHKEQ^%ut(utsuccess,1,"Testing create intervention form FAILED!")
 q
 ;
UTMKBXF ; @TEST - create biopsy form
 ;MKBXFORM(sid,key)
 d CHKFORM^SAMIUTS2("bxform","MKBXFORM",.utsuccess)
 d CHKEQ^%ut(utsuccess,1,"Testing create bx ct eval form FAILED!")
 q
 ;
UTWSCAS ; @TEST - generate case review page
 ;WSCASE(rtn,filter)
 n SAMIUFLTR s SAMIUFLTR("studyid")="XXX00001"
 n SAMIUPOO d WSCASE^SAMICASE(.SAMIUPOO,.SAMIUFLTR)
 n SAMIUARC d PLUTARR^SAMIUTST(.SAMIUARC,"UTWSCAS^SAMIUTS2")
 s utsuccess=1
 n nodep,nodea s nodep=$na(SAMIUPOO),nodea=$na(SAMIUARC)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d
 . q:(@nodep["(incomplete)")
 . q:(@nodep["<meta content")
 . q:($e($tr(@nodep," "),1,10))?4N1P2N1P2N
 . i '($qs(nodep,1)=$qs(nodea,1)) s utsuccess=0
 . i '(@nodep=@nodea) s utsuccess=0
 i '(nodea="") s utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing generating case review page FAILED!")
 q
 ;
UTGSAMIS ; @TEST - get 'samistatus' to val in form
 ;GSAMISTA(sid,form)
 n root,form,sid,ss1,ss2
 s root=$$setroot^%wd("vapals-patients")
 s form="sbform-2018-10-21"
 s sid="XXX00001"
 s ss1=$g(@root@("graph",sid,"sbform-2018-10-21","samistatus"))
 s ss2=$$GSAMISTA^SAMICAS2(sid,form)
 s utsuccess=(ss1=ss2)
 d CHKEQ^%ut(utsuccess,1,"Testing get samistatus FAILED!")
 q
 ;
UTSSAMIS ; @TEST - set 'samistatus' to val in form
 ;SSAMISTA(sid,form,val)
 n root,form,sid,ss1,ss2,val
 s root=$$setroot^%wd("vapals-patients")
 s form="sbform-2018-10-21"
 s sid="XXX00001"
 s val="unit test"
 s ss1=$g(@root@("graph",sid,"sbform-2018-10-21","samistatus"))
 d SSAMISTA^SAMICASE(sid,form,val)
 s ss2=$g(@root@("graph",sid,"sbform-2018-10-21","samistatus"))
 ;return to original value
 s @root@("graph",sid,"sbform-2018-10-21","samistatus")=ss1
 s utsuccess=(ss2="unit test")
 d CHKEQ^%ut(utsuccess,1,"Testing set samistatus FAILED!")
 q
 ;
UTDELFM ; @TEST - deletes a form if it is incomplete
 ;DELFORM(RESULT,SAMIUARGS)
 n SAMIUARGS,root,sbexist,sbexistd,SAMIUPOO,SAMIURTN
 s root=$$setroot^%wd("vapals-patients")
 s studyid="XXX00001"
 s form="sbform-2018-10-21"
 S SAMIUARGS("studyid")=studyid
 S SAMIUARGS("form")=form
 s sbexist=$d(@root@("graph",studyid,form))
 i 'sbexist d  q
 . d FAIL^%ut("sbform-2018-10-21 not in vapals-patients Graphstore")
 m SAMIUPOO=@root@("graph",studyid,form)
 d DELFORM^SAMICASE(.SAMIURTN,.SAMIUARGS)
 s sbexistd=$d(@root@("graph",studyid,form))
 ; now put back original sbform
 k @root@("graph",studyid,form)
 m @root@("graph",studyid,form)=SAMIUPOO
 d CHKEQ^%ut(sbexistd,0,"Testing deleting sbform FAILED!")
 q
 ;
UTINITS ; - set all forms to 'incomplete'
 ;initStatus
 ; This sets ALL patient forms except their siform
 ;   to incomplete.  We don't want to test these
 ;   few lines once real patients are filed
 q
 ;
UTCSRT ; @TEST - generates case review table
 ;CASETBL(ary)
 n SAMIUPOO,SAMIUARC
 d CASETBL^SAMICAS3("SAMIUPOO")
 d PLUTARR^SAMIUTST(.SAMIUARC,"casetbl-SAMICASE")
 s utsuccess=1
 n pnode,anode
 s pnode=$na(SAMIUPOO),anode=$na(SAMIUARC)
 f  s pnode=$q(@pnode),anode=$q(@anode) q:pnode=""  d
 . I '(@pnode=@anode) s utsuccess=0
 s:'(anode="") utsuccess=0
 d CHKEQ^%ut(utsuccess,1,"Testing generate case review  FAILED!")
 q
 ;
 ;
UTNFPST ; @TEST - post new form selection (post service)
 ;WSNFPOST(SAMIUARGS,BODY,RESULT)
 ; This call adds new forms of each type so must
 ;   be run after the above tests that generate
 ;   one of each type separately
 n SAMIUBODY,SAMIUARGS,SAMIURSLT,root,newform
 s root=$$setroot^%wd("vapals-patients")
 s SAMIUBODY(1)=""
 s SAMIUARGS("studyid")="XXX00001"
 ;
 ; now call for form="ceform","sbform","fuform","bxform","ptform"
 ;   "itform"
 ;
 s SAMIUARGS("form")="ceform"
 s newform=$O(@root@("graph","XXX00001","ceforms"),-1)
 d WSNFPOST^SAMICASE(.SAMIUARGS,.SAMIUBODY,.SAMIURSLT)
 s newform=$O(@root@("graph","XXX00001",newform))
 s utsuccess=(newform["ceform")
 ; now kill the extra form just built
 k @root@("graph","XXX00001",newform)
 d CHKEQ^%ut(utsuccess,1,"Testing post ceform FAILED!")
 ;
 ;s SAMIUARGS("form")="sbform"
 ;s newform=$O(@root@("graph","XXX00001","sbforms"),-1)
 ;d WSNFPOST^SAMICASE(.SAMIUARGS,.SAMIUBODY,.SAMIURSLT)
 ;s newform=$O(@root@("graph","XXX00001",newform))
 ;s utsuccess=(newform["sbform")
 ; now kill the extra form just built
 ;k @root@("graph","XXX00001",newform)
 ;d CHKEQ^%ut(utsuccess,1,"Testing post sbform FAILED!")
 ;
 s SAMIUARGS("form")="fuform"
 s newform=$O(@root@("graph","XXX00001","fuforms"),-1)
 d WSNFPOST^SAMICASE(.SAMIUARGS,.SAMIUBODY,.SAMIURSLT)
 s newform=$O(@root@("graph","XXX00001",newform))
 s utsuccess=(newform["fuform")
 ; now kill the extra form just built
 k @root@("graph","XXX00001",newform)
 d CHKEQ^%ut(utsuccess,1,"Testing post fuform FAILED!")
 ;
 s SAMIUARGS("form")="bxform"
 s newform=$O(@root@("graph","XXX00001","bxforms"),-1)
 d WSNFPOST^SAMICASE(.SAMIUARGS,.SAMIUBODY,.SAMIURSLT)
 s newform=$O(@root@("graph","XXX00001",newform))
 s utsuccess=(newform["bxform")
 ; now kill the extra form just built
 k @root@("graph","XXX00001",newform)
 d CHKEQ^%ut(utsuccess,1,"Testing post bxform FAILED!")
 ;
 s SAMIUARGS("form")="ptform"
 s newform=$O(@root@("graph","XXX00001","ptforms"),-1)
 d WSNFPOST^SAMICASE(.SAMIUARGS,.SAMIUBODY,.SAMIURSLT)
 s newform=$O(@root@("graph","XXX00001",newform))
 s utsuccess=(newform["ptform")
 ; now kill the extra form just built
 k @root@("graph","XXX00001",newform)
 d CHKEQ^%ut(utsuccess,1,"Testing post ptform FAILED!")
 ;
 s SAMIUARGS("form")="itform"
 s newform=$O(@root@("graph","XXX00001","itforms"),-1)
 d WSNFPOST^SAMICASE(.SAMIUARGS,.SAMIUBODY,.SAMIURSLT)
 s newform=$O(@root@("graph","XXX00001",newform))
 s utsuccess=(newform["itform")
 ; now kill the extra form just built
 k @root@("graph","XXX00001",newform)
 d CHKEQ^%ut(utsuccess,1,"Testing post itform FAILED!")
 ;
 q
 ;
 ; Builds the form found in 'form' by calling
 ;   the entry point in SAMICASE named in 'label'
 ; Enter
 ;   form       = name of the form to build (e.g. "sbform")
 ;   label      = the datekey to use to identify this
 ;                generated form (e.g. "2018-10-21")
 ;   utsuccess  = variable by reference
 ; Returns
 ;   utsuccess 0=fail, 1=success
 ;
CHKFORM(form,LABEL,utsuccess) ;
 n sid s sid="XXX00001"
 n rootvp s rootvp=$$setroot^%wd("vapals-patients")
 n datekey s datekey="2018-10-21"
 n key set key=form_"-"_datekey
 ; delete existing entry
 k @rootvp@("graph",sid,key)
 s SAMIUARGS("key")=key
 s SAMIUARGS("studyid")=sid
 s SAMIUARGS("form")="vapals:"_form
 n rtn s rtn=LABEL_"^SAMICAS3(sid,key)" d @rtn
 ; i.e. @rootvp@("graph","XXX00001",form_"-2018-10-21"
 ;
 new temp m temp=@rootvp@("graph",sid,key)
 ;
 ; fail if nodes not set in vapals-patients Graphstore
 i '$d(@rootvp@("graph",sid,key)) d  q
 . s utsuccess=0
 . d FAIL^%ut(form_" not set in vapals-patients Graphstore")
 ;
 ; Check that the vapals-patients node created is correct
 ;
 d PLUTARR^SAMIUTST(.SAMIUPOO,LABEL)
 ; correct age in saved array
 n ss s ss=""
 f  s ss=$O(SAMIUPOO(ss)) q:ss=""  d
 . i ss="sidob" do
 .. n X,Y s X=SAMIUPOO("sidob") do ^%DT s SAMIUPOO("age")=$$age^%th(Y)
 ;
 s utsuccess=1
 s ss=""
 f  s ss=$O(SAMIUPOO(ss)) q:ss=""  d  q:'utsuccess
 . i '$d(temp(ss)) s utsuccess=0
 . i '($g(SAMIUPOO(ss))=$g(temp(ss))) s utsuccess=0
 q
EOR ;End of routine SAMIUTS2
