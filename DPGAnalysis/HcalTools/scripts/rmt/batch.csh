#!/bin/csh

set DAT=`date '+%Y-%m-%d_%H_%M_%S'`

set valdas=${1}
if( ${1} == "PEDESTAL" ) then
set valdas=pedestal
endif

if( ${1} == "LASER" ) then
set valdas=laser
endif

set ERA=${2}

echo ${valdas} ${ERA}

### set DAT="2015-10-07_14_50_47"

set RELEASE=CMSSW_10_4_0
### Get list of done from RDM webpage ###
set TYPE=${1}
echo ${TYPE}
if( ${TYPE} != "LED" && ${TYPE} != "LASER" && ${TYPE} != "PEDESTAL" ) then
echo "Please check type " ${TYPE} "should be LED or LASER or PEDESTAL"
exit
endif

set WD="/afs/cern.ch/cms/CAF/CMSALCA/ALCA_HCALCALIB/HCALMONITORING/RDMScript/${RELEASE}/src/RecoHcal/HcalPromptAnalysis/test/RDM"

echo ${WD}


${WD}/parce_newsql_valdas.csh ${valdas} ${DAT} ${ERA}
ls ${WD}/${TYPE}_LIST/runlist.tmp.${DAT}

set jold=194165
foreach i (`cat ${WD}/${TYPE}_LIST/runlist.tmp.${DAT}`)
echo "Run" ${i}

set iold=`echo ${i} | awk -F _ '{print $1}'`
set jold=`echo ${i} | awk -F _ '{print $2}'`
set year=`echo ${i} | awk -F _ '{print $3}' | awk -F - '{print $1}'`
set nevent=`echo ${i} | awk -F _ '{print $5}'`
echo ${iold} ${jold} ${year} ${nevent}
if( ${nevent} != "None" ) then
if( ${nevent} >= "500" && ${nevent} < "1000000") then  
echo  "Start job "
###${WD}/HcalRemoteMonitoringNewNew.csh ${iold} ${DAT} ${jold} ${nevent} ${TYPE}
###ls ${WD}/HcalRemoteMonitoringNewNew.csh
touch ${WD}/LOG1/batchlog_${iold}.log ${WD}/LOG1/ebatchlog_${iold}.log
ls ${WD}/LOG1/batchlog_${iold}.log 
ls ${WD}/LOG1/ebatchlog_${iold}.log
ls ${WD}/HcalRemoteMonitoringNewNew.csh 

/afs/cern.ch/cms/caf/scripts/cmsbsub -q cmscaf1nh -o ${WD}/LOG1/batchlog_${iold}.log -e ${WD}/LOG1/ebatchlog_${iold}.log ${WD}/HcalRemoteMonitoringNewNew.csh ${iold} ${DAT} ${jold} ${nevent} ${TYPE} ${ERA}

echo  "End job "
sleep 1
endif
endif
end
