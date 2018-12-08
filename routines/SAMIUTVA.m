SAMIUTVA ;;ven/lgc - UNIT TEST for SAMIVSTA ; 12/7/18 11:11am
 ;;18.0;SAMI;;
 ;
 ; VA-PALS will be using Sam Habiel's [KBANSCAU] broker
 ;   to pull information from the VA server into the
 ;   VA-PALS client and, to push TIU notes generated by
 ;   VA-PALS forms onto the VA server.
 ; Using this broker between VistA instances requires
 ;   not only the IP and Port for the server be known,
 ;   but also, that the Access and Verify of the user
 ;   on the server be sent across as well.  This is
 ;   required as the user on the server must have the
 ;   necessary Context menu(s) allowing use of the
 ;   Remote Procedure(s).
 ; Six parameters have been added to the client
 ;   VistA to prevent the necessity of hard coding
 ;   certain values and to allow for default values for others.
 ;   SAMI PORT
 ;   SAMI IP ADDRESS
 ;   SAMI ACCVER
 ;   SAMI DEFAULT PROVIDER
 ;   SAMI DEFAULT STATION NUMBER
 ;   SAMI TIU NOTE PRINT NAME
 ;   SAMI DEFAULT CLINIC IEN
 ;   SAMI SYSTEM TEST PATIENT DFN
 ; Note that the user selected must have active
 ;   credentials on both the Client and Server systems
 ;   and the following Broker context menu.
 ;      OR CPRS GUI CHART
 ;
 ; NOTE: Unit tests will pull data using the local
 ;       client VistA files rather than risk degrading
 ;       large datasets in use.  NEVERTHELESS, it is
 ;       recommended that UNIT TESTS be run when
 ;       VA-PALS is not in use as some Graphstore globals
 ;       are temporarily moved while testing is running.
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
START I $T(^%ut)="" W !,"*** UNIT TEST NOT INSTALLED ***" Q
 D EN^%ut($T(+0),2)
 Q
 ;
STARTUP ; Set up dfn and tiuien to use throughout testing
 ;s utdfn="dfn"_$J
 s utdfn=$$GET^XPAR("SYS","SAMI SYSTEM TEST PATIENT DFN",,"Q")
 s (utsuccess,tiuien)=0
 ; Set up graphstore graph on test patient
 n root s root=$$setroot^%wd("vapals-patients")
 k @root@("graph","XXX00001")
 n poo D PullUTarray^SAMIUTST(.poo,"all XXX00001 forms")
 m @root@("graph","XXX00001")=poo
 Q
SHUTDOWN ; ZEXCEPT: dfn,tiuien
 K utdfn,tiuien,utsuccess
 Q
SETUP Q
TEARDOWN Q
 ;
UTBLDTIU ; @TEST - Build a new TIU and Visit stub for a patient
 ; BLDTIU(.tiuien,DFN,TITLE,USER,CLINIEN)
 N D,D0,DG,DI,DIC,DICR,DIG,DIH
 n provduz,clinien,tiutitlepn,tiutitleien,ptdfn,KBAPFAIL
 s provduz=$$GET^XPAR("SYS","SAMI DEFAULT PROVIDER DUZ",,"Q")
 s clinien=$$GET^XPAR("SYS","SAMI DEFAULT CLINIC IEN",,"Q")
 s tiutitlepn=$$GET^XPAR("SYS","SAMI NOTE TITLE PRINT NAME",,"Q")
 s tiutitleien=$O(^TIU(8925.1,"D",tiutitlepn,0))
 I '$G(utdfn) D  Q
 . D FAIL^%ut("Patient DFN missing")
 I ('$g(provduz))!('$g(clinien))!('$g(tiutitleien)) D  Q
 . D FAIL^%ut("Provider,clinic, or tiu title missing")
 D BLDTIU^SAMIVSTA(.tiuien,utdfn,tiutitleien,provduz,clinien)
 H 3 ; Delay for time to build everything
 I '$g(tiuien) D  Q
 . D FAIL^%ut("Procedure failed to build new TIU note")
 n tiunode0 s tiunode0=$g(^TIU(8925,tiuien,0))
 I '($P(tiunode0,"^",1,2)=(tiutitleien_"^"_utdfn)) D  Q
 . D FAIL^%ut("Procedure failed to build CORRECT TIU note")
 I '$P(tiunode0,"^",3) D  Q
 . D FAIL^%ut("Procedure failed to build TIU visit")
 n aupnvist0 s aupnvist0=$G(^AUPNVSIT(+$P(tiunode0,"^",3),0))
 D CHKEQ^%ut(+aupnvist0,+$P(tiunode0,"^",7),"Testing building TIU note FAILED!")
 Q
 ;
UTSTEXT ; @TEST - Push text into an existing TIU note
 ; SETTEXT(.tiuien,.dest)
 N D,D0,DG,DI,DIC,DICR,DIG,DIH
 n poo
 s poo(1)="First line of UNIT TEST text."
 s poo(2)="Second line of UNIT TEST text."
 s poo(3)="Setting text time:"_$$HTE^XLFDT($H)
 s poo(4)="Forth and last line of UNIT TEST text"
 n dest s dest="poo"
 D SETTEXT^SAMIVSTA(.tiuien,dest)
 H 1 ; Delay for time to build everything
 I '$G(tiuien) D  Q
 . D FAIL^%ut("Procedure failed to set text in TIU note")
 s poo=0
 n I F I=1:1:4 D  Q:poo
 . I '($G(^TIU(8925,tiuien,"TEXT",I,0))=poo(I)) S poo=1
 D CHKEQ^%ut(poo,0,"Testing setting text in TIU note FAILED!")
 Q
 ;
UTENCTR ; @TEST - Update TIU with encounter and HF information
 ; BLDENCTR(.tiuien,.HFARRAY)
 N D,D0,DG,DI,DIC,DICR,DIG,DIH
 n VSTR,provduz
 I '$G(utdfn) D  Q
 . D FAIL^%ut("Update tiu with encounter missing utdfn FAILED!")
 S VSTR=$$VISTSTR^SAMIVSTA(tiuien)
 I '($L(VSTR,";")=3) D  Q
 . D FAIL^%ut("Update tiu with encounter VSTR FAILED!")
 s provduz=$$GET^XPAR("SYS","SAMI DEFAULT PROVIDER DUZ",,"Q")
 I '$G(provduz) D  Q
 . D FAIL^%ut("Update tiu with encounter no provduz FAILED!")
 ; Time to build the HF array for the next call
 N HFARRAY
 S HFARRAY(1)="HDR^0^^"_VSTR
 S HFARRAY(2)="VST^DT^"_$P(VSTR,";",2)
 S HFARRAY(3)="VST^PT^"_utdfn
 S HFARRAY(4)="VST^HL^"_$P(VSTR,";")
 S HFARRAY(5)="VST^VC^"_$P(VSTR,";",3)
 S HFARRAY(6)="PRV^"_provduz_"^^^"_$P($G(^VA(200,provduz,0)),"^")_"^1"
 S HFARRAY(7)="POV+^F17.210^COUNSELING AND SCREENING^Nicotine dependence, cigarettes, uncomplicated^1^^0^^^1"
 S HFARRAY(8)="COM^1^@"
 S HFARRAY(9)="HF+^999001^LUNG SCREENING HF^LCS-ENROLLED^@^^^^^2^"
 S HFARRAY(10)="COM^2^@"
 S HFARRAY(11)="CPT+^99203^NEW PATIENT^Intermediate Exam  26-35 Min^1^71^^^0^3^"
 S HFARRAY(12)="COM^3^@"
 ;
 S utsuccess=$$BLDENCTR^SAMIVSTA(.tiuien,.HFARRAY)
 D CHKEQ^%ut(utsuccess,tiuien,"Testing adding encounter to TIU note FAILED!")
 Q
 ;
UTPTINF ; @TEST - Pull additional patient information
 ; D PTINFO^SAMIVSTA(dfn)
 ; Find patient without SSN filed in Graphstore
 N D,D0,DG,DI,DIC,DICR,DIG,DIH
 N root s root=$$setroot^%wd("patient-lookup")
 N gien s gien=0
 F  S gien=$O(@root@(gien)) Q:'gien  Q:'($D(@root@(gien,"ssn")))
 I 'gien D  Q
 . D FAIL^%ut("Unable to find Graphstore entry without SSN - FAILED!")
 N utdfn s utdfn=@root@(gien,"dfn")
 I 'utdfn D  Q
 . D FAIL^%ut("Unable to find patient dfn in Graphstore - FAILED!")
 s utsuccess=$$PTINFO^SAMIVSTA(utdfn)
 D CHKEQ^%ut(utsuccess,("2^"_utdfn),"Testing PTINFO FAILED!")
 Q
 ;
UTADDNS ; @TEST - Add additional signers to a TIU note
 ; D ADDSIGN
 ; NOTE: Signers will not show up on tiu in CPRS until it is
 ;       edited or signed
 N D,D0,DG,DI,DIC,DICR,DIG,DIH
 s utsuccess=0
 I '$G(tiuien) D  Q
 . D FAIL^%ut("Add additional signers failed - no tiuien")
 n filter
 S filter("add signers",1)="64^Smith,Mary"
 D ADDSIGN^SAMIVSTA
 H 1
 D CHKEQ^%ut(utsuccess,1,"Testing Adding additional signers  FAILED!")
 Q
 ;
 ;
UTSSN ; @TEST - Pull SSN on a patient
 ; D PTSSN(dfn)
 ; Find patient without SSN filed in Graphstore
 N D,D0,DG,DI,DIC,DICR,DIG,DIH
 N root s root=$$setroot^%wd("patient-lookup")
 N gien s gien=0
 F  S gien=$O(@root@(gien)) Q:'gien  Q:'($D(@root@(gien,"ssn")))
 I 'gien D  Q
 . D FAIL^%ut("Unable to find Graphstore entry without SSN - FAILED!")
 N utdfn s utdfn=@root@(gien,"dfn")
 I 'utdfn D  Q
 . D FAIL^%ut("Unable to find patient dfn in Graphstore - FAILED!")
 s utsuccess=$$PTSSN^SAMIVSTA(utdfn) ; 2^999989135
 I '($P(utsuccess,"^",2)=$P(^DPT(utdfn,0),"^",9)) D  Q
 . D FAIL^%ut("Unable to pull correct patient ssn - FAILED!")
 N GSssn S GSssn=$G(@root@(gien,"ssn"))
 D CHKEQ^%ut($P(utsuccess,"^",2),GSssn,"Testing PTSSN FAILED!")
 Q
 ;
UTVIT ; @TEST - Pull Vitals on a patient
 ; D VIT(dfn,sdate,edate)
 ; Find entry in patient-lookup without a 'vitals node'
 ;  however the patient has vitals in 120.5
 N D,D0,DG,DI,DIC,DICR,DIG,DIH
 N root s root=$$setroot^%wd("patient-lookup")
 N gien s gien=0
 N gnode,utdfn,utNeedsVitUpdate s utNeedsVitUpdate=0
 F  S gien=$O(@root@(gien)) Q:'gien  D  Q:utNeedsVitUpdate
 . S utdfn=$G(@root@(gien,"dfn")) Q:'utdfn
 . I $O(^GMR(120.5,"C",utdfn,0)) D
 .. s gnode=$NA(@root@(gien,"vitals")),gnode=$Q(@gnode)
 .. I '(gnode["vitals") s utNeedsVitUpdate=1
 I 'gien D  Q
 . D FAIL^%ut("Unable to find suitable patient for Vitals - FAILED!")
 ;Found a good patient
 S utsuccess=$$VIT^SAMIVSTA(utdfn)
 s gnode=$NA(@root@(gien,"vitals")),gnode=$Q(@gnode)
 s utsuccess=(gnode["vitals")
 D CHKEQ^%ut(utsuccess,1,"Testing updating Vitals FAILED!")
 Q
 ;
UTVPR ; @TEST - Pull Virtual Patient Record (VPR) on a patient
 ; D VPR(dfn)
 ; Find entry in patient-lookup without an 'inpatient' node'
 N D,D0,DG,DI,DIC,DICR,DIG,DIH
 N root s root=$$setroot^%wd("patient-lookup")
 N gien s gien=0
 N gnode,utdfn,utNeedsVPRUpdate s utNeedsVPRUpdate=0
 F  S gien=$O(@root@(gien)) Q:'gien  D  Q:utNeedsVPRUpdate
 . S utdfn=$G(@root@(gien,"dfn")) Q:'utdfn
 . I '$D(@root@(gien,"inpatient")) s utNeedsVPRUpdate=1
 I 'gien D  Q
 . D FAIL^%ut("Unable to find suitable patient for VPR - FAILED!")
 ;Found a good patient
 S utsuccess=$$VPR^SAMIVSTA(utdfn)
 H 1
 s utsuccess=$D(@root@(gien,"inpatient"))
 D CHKEQ^%ut(utsuccess,1,"Testing updating with VPR  FAILED!")
 Q
 ;
UTVSTR ; @TEST - Get Visit string (VSTR) for a TIU note
 ; D VisitString(tiuien)
 N D,D0,DG,DI,DIC,DICR,DIG,DIH
 n tiuien,node0,node12,VSTR,tiuVSTR
 s tiuien=$O(^TIU(8925,"A"),-1)
 S VSTR=$$VISTSTR^SAMIVSTA(tiuien)
 s node0=$G(^TIU(8925,tiuien,0))
 s node12=$G(^TIU(8925,tiuien,12))
 s tiuVSTR=$P(node12,"^",5)_";"_$P(node0,"^",7)_";"_$P(node0,"^",13)
 D CHKEQ^%ut(VSTR,tiuVSTR,"Testing getting Visit String FAILED!")
 Q
 ;
UTKASAVE ; @TEST - Kill ASAVE node for a TIU note
 N D,D0,DG,DI,DIC,DICR,DIG,DIH
 n provduz
 s provduz=$$GET^XPAR("SYS","SAMI DEFAULT PROVIDER DUZ",,"Q")
 I '$G(provduz) D  Q
 . D FAIL^%ut("Unable to obtain Provider DUZ for ASAVE  - FAILED!")
 I '$G(tiuien) D  Q
 . D FAIL^%ut("Unable to obtain tiuien for ASAVE  - FAILED!")
 s utsuccess=$$KASAVE^SAMIVSTA(provduz,tiuien)
 D CHKEQ^%ut(utsuccess,1,"Testing updating with VPR  FAILED!")
 Q
 ;
UTSIGN ; @TEST - Sign TIU note
 N D,D0,DG,DI,DIC,DICR,DIG,DIH
 I '$G(tiuien) D  Q
 . D FAIL^%ut("Unable to obtain tiuien for SIGN TIU  - FAILED!")
 n status s status=$P(^TIU(8925,tiuien,0),"^",5)
 I '(status=5) D  Q
 . D FAIL^%ut("TIU status not 'unsigned' for SIGN TIU  - FAILED!")
 S utsuccess=$$SIGNTIU^SAMIVSTA(tiuien)
 D CHKEQ^%ut(utsuccess,1,"Testing Signing of TIU FAILED!")
 Q
 ;
UTADDND ; @TEST - Add an addendum to a signed note
 ; $$TIUADND(tiuien,userduz)
 N D,D0,DG,DI,DIC,DICR,DIG,DIH
 I '$G(tiuien) D  Q
 . D FAIL^%ut("Unable to obtain tiuien for Adding Addendum  - FAILED!")
 n provduz
 s provduz=$$GET^XPAR("SYS","SAMI DEFAULT PROVIDER DUZ",,"Q")
 I '$G(provduz) D  Q
 . D FAIL^%ut("Unable to obtain Provider DUZ to Add Addendum  - FAILED!")
 n tiuaien s tiuaien=$$TIUADND^SAMIVSTA(tiuien,provduz)
 S:($G(tiuaien)>0) tiuien=tiuien_"^"_tiuaien
 s utsuccess=($G(tiuaien)>0)
 ; Sign the addendum
 N OK S OK=$$SIGNTIU^SAMIVSTA(tiuaien)
 D CHKEQ^%ut(utsuccess,1,"Testing Adding Addendum FAILED!")
 Q
 ;
UTDELTIU ; @TEST - Deleting an unsigned TIU note
 N D,D0,DG,DI,DIC,DICR,DIG,DIH
 N tiuaien S tiuaien=$S($P(tiuien,"^",2):$P(tiuien,"^",2),1:0)
 s tiuien=+$G(tiuien)
 I '$G(tiuien) D  Q
 . D FAIL^%ut("Unable to obtain tiuien for Deleting TIU  - FAILED!")
 ; Set note status back to UNSIGNED so we can delete it
 S:$D(^TIU(8925,+tiuien,0)) $P(^TIU(8925,+tiuien,0),"^",5)=5
 S:$D(^TIU(8925,+tiuaien,0)) $P(^TIU(8925,+tiuaien,0),"^",5)=5
 ;
 s:$G(tiuaien) utsuccess=$$DELTIU^SAMIVSTA(tiuaien)
 s utsuccess=$$DELTIU^SAMIVSTA(tiuien)
 ;
 D CHKEQ^%ut(utsuccess,1,"Testing Deleting TIU FAILED!")
 Q
 ;
UTURBR ; @TEST - extrinsic to return urban or rural depending on zip code
 n uturr,uturu
 s uturu=$$URBRUR^SAMIVSTA(40714)
 s uturr=$$URBRUR^SAMIVSTA(40713)
 s utsuccess=((uturu_uturr)="ur")
 D CHKEQ^%ut(utsuccess,1,"Testing Urban/Rural extrinsic FAILED!")
 q
 ;
UTTASK ; @TEST - test TASKIT creation of new note,text, and encounter
 S filter("form")="siform-2018-11-13"
 s filter("studyid")="XXX00001"
 n tiuien s tiuien=0
 k ^TMP("UNIT TEST","UTTASK^SAMIUTVA",$J)
 D TASKIT^SAMIVSTA
 s tiuien=$g(^TMP("UNIT TEST","UTTASK^SAMIUTVA",$J))
 s utsuccess=$S(tiuien>0:1,1:0)
 D CHKEQ^%ut(utsuccess,1,"Testing creating a new TIU note FAILED!")
 ; If a new note was generated add encounter info
 i tiuien d
 . n ptdfn s ptdfn=$p(^TIU(8925,tiuien,0),"^",2)
 . n provduz
 . s provduz=$$GET^XPAR("SYS","SAMI DEFAULT PROVIDER DUZ",,"Q")
 . D ENCNTR^SAMIVSTA
 . s utsuccess=(tiuien>0)
 . D CHKEQ^%ut(utsuccess,1,"Testing adding encounter informatin FAILED!")
 ; If new note was generated, delete it
 i tiuien d
 . N D,D0,DG,DI,DIC,DICR,DIG,DIH
 . s utsuccess=$$DELTIU^SAMIVSTA(tiuien)
 . D CHKEQ^%ut(utsuccess,1,"Testing deleting TASKIT note  FAILED!")
 q
 ;
EOR ;End of routine SAMIUTVA
