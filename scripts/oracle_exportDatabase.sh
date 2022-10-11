#!/bin/bash

#Linux
VARIABLE_DATABASE_DIR="/DatabaseDir" #Put your Dump File in this Directory 

#Windows
#VARIABLE_DATABASE_DIR="C:/DatabaseDir" #Put your Dump File in this Directory 

VARIABLE_DATABASE_DUMP="myDump.dmp"
VARIABLE_PDB="MyPDB"
VARIABLE_SYS_ACCOUNT_PASSWORD="password"
VARIABLE_SYSTEM_ACCOUNT_PASSWORD="password"
VARIABLE_SCRIPT_TEMP_PATH=$(mktemp)
VARIABLE_SCRIPT_TEMP_PATH+='.sql'

echo "Generating SQL Script under $VARIABLE_SCRIPT_TEMP_PATH"

echo "/* Begin SQL Script */

alter session set container=$VARIABLE_PDB

CREATE OR REPLACE DIRECTORY DatabaseDir AS '$VARIABLE_DATABASE_DIR';

alter session set \"_ORACLE_SCRIPT\"=true;

alter pluggable database $VARIABLE_PDB close immediate;

alter pluggable database $VARIABLE_PDB open upgrade;

alter session set container=$VARIABLE_PDB;

alter system set MAX_STRING_SIZE=extended;

@?/rdbms/admin/utl32k.sql

alter pluggable database $VARIABLE_PDB close immediate;

alter pluggable database $VARIABLE_PDB open;

@?/rdbms/admin/utlrp.sql

alter session set \"_ORACLE_SCRIPT\"=true;

alter session set container=$VARIABLE_PDB;

CREATE OR REPLACE DIRECTORY DatabaseDir AS '$VARIABLE_DATABASE_DIR';

commit;
/* End SQL Script */" >> $VARIABLE_SCRIPT_TEMP_PATH

echo "EXIT;" >> $VARIABLE_SCRIPT_TEMP_PATH

VARIABLE_TIMESTAMP=$(date "+%Y-%m-%d_%H_%M_%S")
VARIABLE_LOG_FILE="$VARIABLE_DATABASE_DUMP_"
VARIABLE_LOG_FILE+=$VARIABLE_TIMESTAMP

echo "##############################################" 
echo "#### BEGIN EXECUTION OF SQL PLUS COMMANDS ####"
echo "##############################################" 
echo ""

VARIABLE_LOG_FILE_SQLPLUS=$VARIABLE_LOG_FILE.sqlplus.log

sqlplus "sys/$VARIABLE_SYS_ACCOUNT_PASSWORD@$VARIABLE_PDB as sysdba" @$VARIABLE_SCRIPT_TEMP_PATH >> $VARIABLE_LOG_FILE_SQLPLUS

echo ""
echo "#########################################" 
echo "#### BEGIN EXECUTION OF DUMP COMMAND ####" 
echo "#########################################" 
echo ""

VARIABLE_LOG_FILE_EXPDP=$VARIABLE_LOG_FILE.expdp.log

expdp "system/$VARIABLE_SYSTEM_ACCOUNT_PASSWORD@$VARIABLE_PDB" full=y directory=DatabaseDir dumpfile=$VARIABLE_DATABASE_DUMP logfile="$VARIABLE_LOG_FILE_EXPDP"