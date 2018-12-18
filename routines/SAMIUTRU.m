SAMIUTRU ;ven/lgc - UNIT TEST for SAMIRU ; 12/17/18 3:28pm
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
STARTUP n utsuccess
 Q
 ;
SHUTDOWN ; ZEXCEPT: utsuccess
 K utsuccess
 Q
 ;
 ;
UTINDEX ; @TEST - create the zip index in the zip graph
 ;INDEX^SAMIRU
 n root,samid1,samid2,samid3,SAMIUPOO,SAMIUARC
 s root=$$setroot^%wd("NCHS Urban-Rural")
 s samid1=$d(@root@("zip")) ; should be 10
 i samid1=10 d
 . m SAMIUPOO=@root@("zip")
 . d SVUTARR^SAMIUTST(.SAMIUPOO,"ZIP index on NCHS Urban-Rural")
 ; if the "zip" index exists, delete it
 i samid1=10 k @root@("zip")
 ; confirm the "zip" index does not exist
 s samid2=$d(@root@("zip")) ; should be 0
 ; Fail if unable to kill the "zip" index
 i '(samid2=0) d  q
 . d PLUTARR^SAMIUTST(.SAMIUARC,"ZIP index on NCHS Urban-Rural")
 . m @root@("zip")=SAMIUARC
 . D FAIL^%ut("Error, unable to kill 'zip' index on on NCHS Urban-Rural!")
 d INDEX^SAMIRU
 ; confirm now the "zip" does exist
 s samid3=$d(@root@("zip")) ; should be 10 again
 i '(samid3=10) d
 . d PLUTARR^SAMIUTST(.SAMIUARC,"ZIP index on NCHS Urban-Rural")
 . m @root@("zip")=SAMIUARC
 s utsuccess=(samid3=10)
 D CHKEQ^%ut(utsuccess,1,"Create 'zip' index on NCHS Urban-Rural FAILED!")
 q
 ;
UTWSGRU ; @TEST - web service to return counts for rural and urban
 ;WSGETRU(rtn,filter)
 n SAMIURTN,SAMIUFLTR,root
 s root=$$setroot^%wd("vapals-patients")
 ;
 d WSGETRU^SAMIRU(.SAMIURTN,.SAMIUFLTR)
 s utsuccess=1
 i $g(SAMIURTN(1))'["result" s utsuccess=0
 i $g(SAMIURTN(1))'["rural" s utsuccess=0
 i $g(SAMIURTN(1))'["site" s utsuccess=0
 i $g(SAMIURTN(1))'["unknown" s utsuccess=0
 i $g(SAMIURTN(1))'["urban" s utsuccess=0
 D CHKEQ^%ut(utsuccess,1,"Testing web service counting rural and urban FAILED!")
 q
 ;
 ;
EOR ;End of routine SAMIUTRU
