KIDS Distribution saved on Apr 02, 2020@23:45:42
sami site file with print template and option
**KIDS**:SAMISITE*1.0*1^

**INSTALL NAME**
SAMISITE*1.0*1
"BLD",10490,0)
SAMISITE*1.0*1^SAMI^0^3200402^n
"BLD",10490,1,0)
^^1^1^3200402^
"BLD",10490,1,1,0)
SAMI SITE FILE, PRINT TEMPLATE AND PRINT OPTION
"BLD",10490,4,0)
^9.64PA^311.12^1
"BLD",10490,4,311.12,0)
311.12
"BLD",10490,4,311.12,222)
y^y^f^^n^^y^o^n
"BLD",10490,4,"B",311.12,311.12)

"BLD",10490,6.3)
1
"BLD",10490,"KRN",0)
^9.67PA^779.2^20
"BLD",10490,"KRN",.4,0)
.4
"BLD",10490,"KRN",.4,"NM",0)
^9.68A^1^1
"BLD",10490,"KRN",.4,"NM",1,0)
SAMI SITE USER MAP    FILE #311.12^311.12^0
"BLD",10490,"KRN",.4,"NM","B","SAMI SITE USER MAP    FILE #311.12",1)

"BLD",10490,"KRN",.401,0)
.401
"BLD",10490,"KRN",.402,0)
.402
"BLD",10490,"KRN",.403,0)
.403
"BLD",10490,"KRN",.5,0)
.5
"BLD",10490,"KRN",.84,0)
.84
"BLD",10490,"KRN",3.6,0)
3.6
"BLD",10490,"KRN",3.8,0)
3.8
"BLD",10490,"KRN",9.2,0)
9.2
"BLD",10490,"KRN",9.8,0)
9.8
"BLD",10490,"KRN",19,0)
19
"BLD",10490,"KRN",19,"NM",0)
^9.68A^1^1
"BLD",10490,"KRN",19,"NM",1,0)
SAMI SITE USER MAP^^0
"BLD",10490,"KRN",19,"NM","B","SAMI SITE USER MAP",1)

"BLD",10490,"KRN",19.1,0)
19.1
"BLD",10490,"KRN",101,0)
101
"BLD",10490,"KRN",409.61,0)
409.61
"BLD",10490,"KRN",771,0)
771
"BLD",10490,"KRN",779.2,0)
779.2
"BLD",10490,"KRN",870,0)
870
"BLD",10490,"KRN",8989.51,0)
8989.51
"BLD",10490,"KRN",8989.52,0)
8989.52
"BLD",10490,"KRN",8994,0)
8994
"BLD",10490,"KRN","B",.4,.4)

"BLD",10490,"KRN","B",.401,.401)

"BLD",10490,"KRN","B",.402,.402)

"BLD",10490,"KRN","B",.403,.403)

"BLD",10490,"KRN","B",.5,.5)

"BLD",10490,"KRN","B",.84,.84)

"BLD",10490,"KRN","B",3.6,3.6)

"BLD",10490,"KRN","B",3.8,3.8)

"BLD",10490,"KRN","B",9.2,9.2)

"BLD",10490,"KRN","B",9.8,9.8)

"BLD",10490,"KRN","B",19,19)

"BLD",10490,"KRN","B",19.1,19.1)

"BLD",10490,"KRN","B",101,101)

"BLD",10490,"KRN","B",409.61,409.61)

"BLD",10490,"KRN","B",771,771)

"BLD",10490,"KRN","B",779.2,779.2)

"BLD",10490,"KRN","B",870,870)

"BLD",10490,"KRN","B",8989.51,8989.51)

"BLD",10490,"KRN","B",8989.52,8989.52)

"BLD",10490,"KRN","B",8994,8994)

"DATA",311.12,1,0)
330^PHX
"DATA",311.12,1,3)
^^1
"DATA",311.12,2,0)
328^PHI
"DATA",311.12,2,3)
^^1
"DATA",311.12,3,0)
160^ATG
"DATA",311.12,3,3)
^^1
"DATA",311.12,4,0)
303^TVH
"DATA",311.12,4,3)
^^1
"DATA",311.12,5,0)
202^CLE
"DATA",311.12,5,3)
^^1
"DATA",311.12,6,0)
256^IND
"DATA",311.12,6,3)
^^1
"DATA",311.12,7,0)
248^HIN
"DATA",311.12,7,3)
^^1
"DATA",311.12,8,0)
403^MIW
"DATA",311.12,8,3)
^^1
"DATA",311.12,9,0)
346^STL
"DATA",311.12,9,3)
^^1
"DATA",311.12,10,0)
220^DEN
"DATA",311.12,10,3)
^^1
"FIA",311.12)
SAMI SITE
"FIA",311.12,0)
^SAMI(311.12,
"FIA",311.12,0,0)
311.12PI
"FIA",311.12,0,1)
y^y^f^^n^^y^o^n
"FIA",311.12,0,10)

"FIA",311.12,0,11)

"FIA",311.12,0,"RLRO")

"FIA",311.12,0,"VR")
1.0^SAMISITE
"FIA",311.12,311.12)
0
"KRN",.4,1562,-1)
0^1
"KRN",.4,1562,0)
SAMI SITE USER MAP^3200325.2047^@^311.12^^@^3200327
"KRN",.4,1562,"DXS",1,9)
S I(0,0)=$G(D0),DIP(1)=$S($D(^SAMI(311.12,D0,0)):^(0),1:""),D0=$P(DIP(1),U,1) S:'D0!'$D(^DIC(4,+D0,0)) D0=-1 S D0=D0 S I(100,0)=$G(D0) X DXS(1,9.4) S X="" S D0=I(0,0)
"KRN",.4,1562,"DXS",1,9.2)
S Y(9.1,201)=$S($D(^VA(200,D0,0)):^(0),1:"") S X=$P(Y(9.1,201),U,1)
"KRN",.4,1562,"DXS",1,9.3)
S (D,D0)=$QS(DIMQ,$QL(DIMQ)-1) I D,$D(^VA(200,D,0)) S X=$P(^(0),U)  X DXS(1,9.2) X DICMX
"KRN",.4,1562,"DXS",1,9.4)
N DIMQ,DIMSTRT,DIMSCNT S (DIMQ,DIMSTRT)=$NA(^VA(200,"AH",I(100,0))),DIMSCNT=$QL(DIMQ) F  S DIMQ=$Q(@DIMQ) Q:DIMQ=""  Q:$NA(@DIMQ,DIMSCNT)'=DIMSTRT   X DXS(1,9.3) Q:'$D(D)  S D=D0
"KRN",.4,1562,"F",2)
X DXS(1,9) W X K DIP;m;Z;".01:NEW PERSON:NAME"~
"KRN",.4,1562,"H")
SAMI SITE List
"KRN",19,11804,-1)
0^1
"KRN",19,11804,0)
SAMI SITE USER MAP^SITE USER MAP^^P^^^^^^^^SAMI
"KRN",19,11804,1,0)
^19.06^1^1^3200325^^
"KRN",19,11804,1,1,0)
PRINTS THE MAP OF SITES AND USERS ASSIGNED TO EACH SITE
"KRN",19,11804,60)
SAMI(311.12,
"KRN",19,11804,62)
0
"KRN",19,11804,63)
[SAMI SITE USER MAP]
"KRN",19,11804,64)
[SAMI SITE USER SORT]
"KRN",19,11804,65)

"KRN",19,11804,66)

"KRN",19,11804,"U")
SITE USER MAP
"MBREQ")
0
"ORD",5,.4)
.4;5;;;EDEOUT^DIFROMSO(.4,DA,"",XPDA);FPRE^DIFROMSI(.4,"",XPDA);EPRE^DIFROMSI(.4,DA,$E("N",$G(XPDNEW)),XPDA,"",OLDA);;EPOST^DIFROMSI(.4,DA,"",XPDA);DEL^DIFROMSK(.4,"",%)
"ORD",5,.4,0)
PRINT TEMPLATE
"ORD",18,19)
19;18;;;OPT^XPDTA;OPTF1^XPDIA;OPTE1^XPDIA;OPTF2^XPDIA;;OPTDEL^XPDIA
"ORD",18,19,0)
OPTION
"PKG",230,-1)
1^1
"PKG",230,0)
SAMI^SAMI^SCREENING APPLICATIONS MANAGEMENT - IELCAP
"PKG",230,20,0)
^9.402P^^
"PKG",230,22,0)
^9.49I^1^1
"PKG",230,22,1,0)
1.0^3181203
"PKG",230,22,1,"PAH",1,0)
1^3200402
"PKG",230,22,1,"PAH",1,1,0)
^^1^1^3200402
"PKG",230,22,1,"PAH",1,1,1,0)
SAMI SITE FILE, PRINT TEMPLATE AND PRINT OPTION
"QUES","XPF1",0)
Y
"QUES","XPF1","??")
^D REP^XPDH
"QUES","XPF1","A")
Shall I write over your |FLAG| File
"QUES","XPF1","B")
YES
"QUES","XPF1","M")
D XPF1^XPDIQ
"QUES","XPF2",0)
Y
"QUES","XPF2","??")
^D DTA^XPDH
"QUES","XPF2","A")
Want my data |FLAG| yours
"QUES","XPF2","B")
YES
"QUES","XPF2","M")
D XPF2^XPDIQ
"QUES","XPI1",0)
YO
"QUES","XPI1","??")
^D INHIBIT^XPDH
"QUES","XPI1","A")
Want KIDS to INHIBIT LOGONs during the install
"QUES","XPI1","B")
NO
"QUES","XPI1","M")
D XPI1^XPDIQ
"QUES","XPM1",0)
PO^VA(200,:EM
"QUES","XPM1","??")
^D MG^XPDH
"QUES","XPM1","A")
Enter the Coordinator for Mail Group '|FLAG|'
"QUES","XPM1","B")

"QUES","XPM1","M")
D XPM1^XPDIQ
"QUES","XPO1",0)
Y
"QUES","XPO1","??")
^D MENU^XPDH
"QUES","XPO1","A")
Want KIDS to Rebuild Menu Trees Upon Completion of Install
"QUES","XPO1","B")
NO
"QUES","XPO1","M")
D XPO1^XPDIQ
"QUES","XPZ1",0)
Y
"QUES","XPZ1","??")
^D OPT^XPDH
"QUES","XPZ1","A")
Want to DISABLE Scheduled Options, Menu Options, and Protocols
"QUES","XPZ1","B")
NO
"QUES","XPZ1","M")
D XPZ1^XPDIQ
"QUES","XPZ2",0)
Y
"QUES","XPZ2","??")
^D RTN^XPDH
"QUES","XPZ2","A")
Want to MOVE routines to other CPUs
"QUES","XPZ2","B")
NO
"QUES","XPZ2","M")
D XPZ2^XPDIQ
"SEC","^DIC",311.12,311.12,0,"AUDIT")
@
"SEC","^DIC",311.12,311.12,0,"DD")
@
"SEC","^DIC",311.12,311.12,0,"DEL")
@
"SEC","^DIC",311.12,311.12,0,"LAYGO")
@
"SEC","^DIC",311.12,311.12,0,"RD")
@
"SEC","^DIC",311.12,311.12,0,"WR")
@
"VER")
8.0^22.2
"^DD",311.12,311.12,0)
FIELD^^.03^3
"^DD",311.12,311.12,0,"DT")
3200327
"^DD",311.12,311.12,0,"ID","W.02")
W "   ",$P(^(0),U,2)
"^DD",311.12,311.12,0,"IX","B",311.12,.01)

"^DD",311.12,311.12,0,"NM","SAMI SITE")

"^DD",311.12,311.12,.01,0)
SITE^RP4'^DIC(4,^0;1^Q
"^DD",311.12,311.12,.01,.1)
SAMI SITE
"^DD",311.12,311.12,.01,1,0)
^.1
"^DD",311.12,311.12,.01,1,1,0)
311.12^B
"^DD",311.12,311.12,.01,1,1,1)
S ^SAMI(311.12,"B",$E(X,1,30),DA)=""
"^DD",311.12,311.12,.01,1,1,2)
K ^SAMI(311.12,"B",$E(X,1,30),DA)
"^DD",311.12,311.12,.01,3)
NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
"^DD",311.12,311.12,.01,"DT")
3200325
"^DD",311.12,311.12,.02,0)
SYMBOL^FJ3^^0;2^K:$L(X)>3!($L(X)<1) X
"^DD",311.12,311.12,.02,.1)
SITE SYMBOL
"^DD",311.12,311.12,.02,3)
Answer must be 1-3 characters in length.
"^DD",311.12,311.12,.02,"DT")
3200327
"^DD",311.12,311.12,.03,0)
ACTIVE^St11^^3;3^Q
"^DD",311.12,311.12,.03,.1)
IS THE SITE ACTIVE
"^DD",311.12,311.12,.03,"DT")
3200327
"^DIC",311.12,311.12,0)
SAMI SITE^311.12
"^DIC",311.12,311.12,0,"GL")
^SAMI(311.12,
"^DIC",311.12,311.12,"%",0)
^1.005^^
"^DIC",311.12,"B","SAMI SITE",311.12)

**END**
**END**
