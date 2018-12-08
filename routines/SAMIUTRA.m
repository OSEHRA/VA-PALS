SAMIUTRA ;ven/lgc - UNIT TEST for SAMICTRA ; 12/7/18 1:44pm
 ;;18.0;SAMI;;
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
 ;
STARTUP n UTSUCCESS
 n root s root=$$setroot^%wd("vapals-patients")
 k @root@("graph","XXX00001")
 n poo D PullUTarray^SAMIUTST(.poo,"all XXX00001 forms")
 m @root@("graph","XXX00001")=poo
 Q
 ;
SHUTDOWN ; ZEXCEPT: UTSUCCESS
 K UTSUCCESS
 Q
 ;
 ;
UTRCMD ; @TEST - Recommendation
 ;recommend(rtn,vals,dict)
 n vals,dict,si,samikey,root,poo,arc,nodea,nodep
 s root=$$setroot^%wd("vapals-patients")
 s si="XXX00001"
 s samikey="ceform-2018-10-21"
 s vals=$na(@root@("graph",si,samikey))
 s dict=$$setroot^%wd("cteval-dict")
 s dict=$na(@dict@("cteval-dict"))
 s cnt=1,para="POO"
 s UTSUCCESS=1
 D RCMND^SAMICTRA("poo",.vals,.dict)
 d PullUTarray^SAMIUTST(.arc,"UTRCMD^SAMIUTRA")
 n nodea,nodep s nodea=$na(arc),nodep=$na(poo)
 f  s nodep=$q(@nodep),nodea=$q(@nodea) q:nodep=""  d  q:'UTSUCCESS
 . i '(@nodep=@nodea) s UTSUCCESS=0
 i '(nodea="") s UTSUCCESS=0
 D CHKEQ^%ut(UTSUCCESS,1,"Testing recommend FAILED!")
 q
UTOUT ; @TEST - out line
 ;OUT(ln)
 n cnt,rtn,poo
 s cnt=1,rtn="poo",poo(1)="First line of test"
 n ln s ln="Second line test"
 s UTSUCCESS=0
 D OUT^SAMICTRA(ln)
 s UTSUCCESS=($g(poo(2))="Second line test")
 D CHKEQ^%ut(UTSUCCESS,1,"Testing out(ln) adds line to array FAILED!")
 q
UTHOUT ; @TEST - hout line
 ;HOUT(ln)
 n cnt,rtn,poo
 s cnt=1,rtn="poo",poo(1)="First line of test"
 n ln s ln="Second line test"
 s UTSUCCESS=0
 D HOUT^SAMICTRA(ln)
 s UTSUCCESS=($g(poo(2))="<p><span class='sectionhead'>Second line test</span>")
 D CHKEQ^%ut(UTSUCCESS,1,"Testing hout(ln) adds line to array FAILED!")
 q
UTXVAL ; @TEST - extrinsic returns the patient value for var
 ;xval(var,vals)
 s UTSUCCESS=0
 s arc(1)="Testing xval"
 s UTSUCCESS=($$XVAL^SAMICTRA(1,"arc")="Testing xval")
 D CHKEQ^%ut(UTSUCCESS,1,"Testing xval(var,vals) FAILED!")
 q
UTXSUB ; @TEST - extrinsic which returns the dictionary value defined by var
 ;xsub(var,vals,dict,valdx)
 n vals,var,poo,valdx,result
 s UTSUCCESS=0
 s vals="poo"
 s var="cteval-dict"
 s poo(1)="biopsy"
 s valdx=1
 s dict=$$setroot^%wd("cteval-dict")
 s result=$$XSUB^SAMICTRA(var,vals,dict,valdx)
 s UTSUCCESS=(result="CT-guided biopsy")
 D CHKEQ^%ut(UTSUCCESS,1,"Testing xsub(var,vals,dict,valdx) FAILED!")
 q
 ;
EOR ;End of routine SAMIUTRA
