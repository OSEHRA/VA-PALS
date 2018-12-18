SAMIUTVS ;;ven/arc/lgc - UNIT TEST for SAMIVSTS ; 12/7/18 10:26am
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
 ; @sac-exemption
 ;  sac 2.2.8 Vendor specific subroutines may not be called directly
 ;   except by Kernel, Mailman, & VA Fileman.
 ;  sac 2.3.3.2 No VistA package may use the following intrinsic
 ;   (system) variables unless they are accessed using Kernel or VA
 ;   FileMan supported references: $D[EVICE], $I[O], $K[EY],
 ;   $P[RINCIPAL], $ROLES, $ST[ACK], $SY[STEM], $Z*.
 ;   (Exemptions: Kernel & VA Fileman)
 ;  sac 2.9.1: Application software must use documented Kernel
 ;   supported references to perform all platform specific functions.
 ;   (Exemptions: Kernel & VA Fileman)
 ;  ============== UNIT TESTS ======================
 ;  NOTE: Unit tests will pull data using the local
 ;       client VistA files rather than risk degrading
 ;       large datasets in use.  NEVERTHELESS, it is
 ;       recommended that UNIT TESTS be run when
 ;       VA-PALS is not in use as some Graphstore globals
 ;       are temporarily moved while testing is running.
 ;
 ; @to-do
 ;
 ; @section 1 code
 ;
START I $T(^%ut)="" W !,"*** UNIT TEST NOT INSTALLED ***" Q
 D EN^%ut($T(+0),2)
 Q
 ;
STARTUP N UTSUCCESS
 Q
 ;
SHUTDOWN ; ZEXCEPT: UTSUCCESS
 K UTSUCCESS
 Q
 ;
UTMGPH ; @TEST - Test making 'patient-lookup' Graphstore
 I '$D(^KBAP("ALLPTS")) D  Q
 .  D FAIL^%ut("^KBAP(""ALLPTS"") must exist for TESTING")
 ;
 D MKGPH^SAMIVSTS ; Rebuild 'patient-lookup' Graphstore
 ; Check that the Graphstore was built
 n si s si=$O(^%wd(17.040801,"B","patient-lookup",0))
 I '$G(si) D  Q
 . D FAIL^%ut("MKGPH entry did not build 'patient-lookup' Graphstore")
 ;
 n NODE,SNODE,RSLT,root,gien,dfn,PTDATA
 s root=$$setroot^%wd("patient-lookup")
 S NODE=$NA(^KBAP("ALLPTS")),SNODE=$P(NODE,")")
 S UTSUCCESS=1
 F  S NODE=$Q(@NODE) Q:NODE'[SNODE  D  Q:'UTSUCCESS
 . S PTDATA=@NODE
 . S dfn=$P(PTDATA,"^",12)
 . s gien=$O(@root@("dfn",dfn,0))
 . I '$G(gien) S UTSUCCESS=0 Q
 .;
 .; Now compare the entries in this Graphstore node with
 .;  the information in the respective ^KBAP("ALLPTS" node
 . I '$O(@root@("last5",$P(PTDATA,"^",9),0)) S UTSUCCESS=0 Q
 . I '$L($P(PTDATA,"^")) S UTSUCCESS=0 Q
 . I '$O(@root@("name",$P(PTDATA,"^"),0)) S UTSUCCESS=0 Q
 . I '$L($P(PTDATA,"^",4)) S UTSUCCESS=0 Q
 . I '$O(@root@("name",$P(PTDATA,"^",4),0)) S UTSUCCESS=0 Q
 . I '$O(@root@("saminame",$P(PTDATA,"^",4),0)) S UTSUCCESS=0 Q
 ;
 I 'UTSUCCESS D  Q
 . D FAIL^%ut("'patient-lookup' Graphstore incorrectly built")
 D CHKEQ^%ut(UTSUCCESS,1,"Testing Complete Graphstore build  FAILED!")
 Q
 ;
UTAPTS ; @TEST - Test pulling patient data through broker
 K ^KBAP("ALLPTS UNITTEST")
 D ALLPTS1^SAMIVSTS("ALLPTS UNITTEST")
 ;                in file 2         in ALLPTS
 ;  NAME            piece 1          piece 1
 ;  sex             piece 2          piece 6
 ;  birthdate       piece 3 fmdt     piece 10 (yyyymmdd)
 ;
 ; Pull NAME from file 2 B cross
 ;   Get NAME,sex,birthdate,build last5
 ; Pull entry in Graphstore using last5
 ;   Knowing gien get NAME,sex,birthdate
 ; Compare
 N NAME2,sex2,dob2,last52,dfn2,NAMEG,sexG,dobG,last5G,dfnG
 N NODE2,nodeG,gien
 n root s root=$$setroot^%wd("patient-lookup")
 S UTSUCCESS=1
 S dfn2=0
 f  s dfn2=$O(^DPT(dfn2)) Q:'dfn2  D  Q:'UTSUCCESS
 . s NODE2=$G(^DPT(dfn2,0))
 . s NAME2=$P(NODE2,"^")
 . s sex2=$$UP^XLFSTR($E($P(NODE2,"^",2)))
 . s dob2=$$FMTHL7^XLFDT($P(NODE2,"^",3))
 . s dob2=$E(dob2,1,4)_"-"_$E(dob2,5,6)_"-"_$E(dob2,7,8)
 . s gien=$O(@root@("dfn",dfn2,0))
 . s last52=$$UP^XLFSTR($E(NAME2))_$E($P(NODE2,"^",9),6,9)
 . I '$G(gien) S UTSUCCESS=0 Q
 . I '$D(@root@("name",NAME2,gien)) S UTSUCCESS=0 Q
 . I '($P($G(@root@(gien,"gender")),"^")=sex2) D  Q
 .. S UTSUCCESS=0
 . I '$D(@root@("last5",last52,gien)) S UTSUCCESS=0 Q
 . I '($G(@root@(gien,"sbdob"))=dob2) S UTSUCCESS=0 Q
 K ^KBAP("ALLPTS UNITTEST")
 I 'UTSUCCESS D  Q
 . D FAIL^%ut("KBAP(""ALLPTS UNITTEST"") incorrectly built")
 D CHKEQ^%ut(UTSUCCESS,1,"Testing pulling patients through broker FAILED!")
 Q
 ;
UTPRVDS ; @TEST - Pulling Providers through the broker
 K ^KBAP("UNIT TEST PROVIDERS")
 n root s root=$$setroot^%wd("providers")
 m ^KBAP("UNIT TEST PROVIDERS")=@root
 S UTSUCCESS=1
 N KBAPPVDS
 S KBAPPVDS=$$PRVDRS^SAMIVSTS
 I '$G(KBAPPVDS) D  Q
 . M @root=^KBAP("UNIT TEST PROVIDERS") K ^KBAP("UNIT TEST PROVIDERS")
 . D FAIL^%ut("No providers pulled through broker")
 n ien,DUZG,NAMEG
 f ien=1:1:$G(KBAPPVDS) D  Q:'UTSUCCESS
 . s DUZG=@root@(ien,"duz")
 . s NAMEG=@root@(ien,"name")
 . I '$D(^XUSEC("PROVIDER",DUZG)) S UTSUCCESS=0 Q
 .; I '$$ACTIVE^XUSER(DUZG) S UTSUCCESS=0 Q
 . I '($$UP^XLFSTR(NAMEG))=($$UP^XLFSTR($P($G(^VA(200,DUZG,0)),"^"))) D  Q
 .. S UTSUCCESS=0
 m @root=^KBAP("UNIT TEST PROVIDERS") K ^KBAP("UNIT TEST PROVIDERS")
 D CHKEQ^%ut(UTSUCCESS,1,"Testing pulling Providers through broker FAILED!")
 Q
 ;
UTRMDRS ; @TEST - Pulling Reminders through the broker
 K ^KBAP("UNIT TEST REMINDERS")
 n root s root=$$setroot^%wd("reminders")
 m ^KBAP("UNIT TEST REMINDERS")=@root
 S UTSUCCESS=1
 N KBAPRMDR
 S KBAPRMDR=$$RMDRS^SAMIVSTS
 I '$G(KBAPRMDR) D  Q
 . M @root=^KBAP("UNIT TEST REMINDERS")
 . K ^KBAP("UNIT TEST REMINDERS")
 . D FAIL^%ut("No reminders pulled through broker")
 n ienV,ienG,NAMEG,PNAMEG,typeG
 f ienG=1:1:$G(KBAPRMDR) D  Q:'UTSUCCESS
 . s NAMEG=@root@(ienG,"name") ; Mixed case
 . s PNAMEG=@root@(ienG,"printname") ; All caps
 . s typeG=@root@(ienG,"type")
 . s ienV=@root@(ienG,"ien")
 . I typeG="R" D  Q:'UTSUCCESS
 .. I '$D(^PXD(811.9,"B",PNAMEG,ienV)) S UTSUCCESS=0 Q
 .. I '$D(^PXD(811.9,"D",NAMEG,ienV)) S UTSUCCESS=0 Q
 . I typeG="C" D  Q:'UTSUCCESS
 .. I '($G(^PXRMD(811.7,ienV,0))=NAMEG) S UTSUCCESS=0 Q
 m @root=^KBAP("UNIT TEST REMINDERS")
 K ^KBAP("UNIT TEST REMINDERS")
 D CHKEQ^%ut(UTSUCCESS,1,"Testing pulling Reminders through broker FAILED!")
 Q
 ;
 ;
UTCLNC ; @TEST - Pulling Clinics through the broker
 K ^KBAP("UNIT TEST CLINICS")
 n root s root=$$setroot^%wd("clinics")
 m ^KBAP("UNIT TEST CLINICS")=@root
 S UTSUCCESS=1
 N KBAPCLNC
 S KBAPCLNC=$$CLINICS^SAMIVSTS
 I '$G(KBAPCLNC) D  Q
 . M @root=^KBAP("UNIT TEST CLINICS")
 . K ^KBAP("UNIT TEST CLINICS")
 . D FAIL^%ut("No clinics pulled through broker")
 n ienG,ienV,NAMEG
 f ienG=1:1:$G(KBAPCLNC) D  Q:'UTSUCCESS
 . s NAMEG=@root@(ienG,"name")
 . s ienV=@root@(ienG,"ien")
 . I '$D(^SC("B",NAMEG,ienV)) S UTSUCCESS=0 Q
 m @root=^KBAP("UNIT TEST CLINICS")
 K ^KBAP("UNIT TEST CLINICS")
 D CHKEQ^%ut(UTSUCCESS,1,"Testing pulling Clinics through broker FAILED!")
 Q
 ;
 ;
UTHF ; @TEST - Pulling Health Factors through the broker
 K ^KBAP("UNIT TEST HEALTH FACTORS")
 n root s root=$$setroot^%wd("health-factors")
 m ^KBAP("UNIT TEST HEALTH FACTORS")=@root
 S UTSUCCESS=1
 N KBAPHF
 S KBAPHF=$$HLTHFCT^SAMIVSTS
 I '$G(KBAPHF) D  Q
 . M @root=^KBAP("UNIT TEST HEALTH FACTORS")
 . K ^KBAP("UNIT TEST HEALTH FACTORS")
 . D FAIL^%ut("No health factors pulled through broker")
 n ienV,ienG,NAMEG
 f ienG=1:1:$G(KBAPHF) D  Q:'UTSUCCESS
 . s NAMEG=@root@(ienG,"name")
 . s ienV=@root@(ienG,"ien")
 . I '($P($G(^AUTTHF(ienV,0)),"^")=NAMEG) S UTSUCCESS=0 Q
 m @root=^KBAP("UNIT TEST HEALTH FACTORS")
 K ^KBAP("UNIT TEST HEALTH FACTORS")
 D CHKEQ^%ut(UTSUCCESS,1,"Testing pulling Health Factors through broker FAILED!")
 Q
 ;
UTCLRG ; @TEST - Clear a Graphstore of entries
 n root s root=$$setroot^%wd("providers")
 K ^KBAP("UNIT TEST CLRGRPH") M ^KBAP("UNIT TEST CLRGRPH")=@root
 n cnt s cnt=$O(@root@("A"),-1)
 I 'cnt D  Q
 . D FAIL^%ut("No 'providers found' entry")
 s cnt=$$CLRGRPS^SAMIVSTS("providers"),cnt=$O(@root@("A"),-1)
 M @root=^KBAP("UNIT TEST CLRGRPH") K ^KBAP("UNIT TEST CLRGRPH")
 D CHKEQ^%ut(cnt,0,"Clear Graphstore FAILED!")
 Q
EOR ; End of Routine SAMIUTVS