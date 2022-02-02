# TPC-H Benchmark for MySQL and MariaDB


The scripts hosted below are for implementing the TPC-H database, sample data and queries to MySQL and MariaDB Databases under Linux.
TPC-H is a benchmark for Decision support made available by the Transaction Processing Performance Council (TPC). 
ALL the necessary specifications and documentation for setting up the TPC-H database, generating data and queries are available on [TPC Website](http://tpc.org/tpc_documents_current_versions/current_specifications5.asp).
The generated items are SQL compliant and can be ported to all major relational databases. While the system can generate data for major databases, support for MYSQL and MariaDB shall benefit from further documentation.
This work is based on [
Catarina Ribeiro's port to MySQL ](https://github.com/catarinaribeir0/queries-tpch-dbgen-mysql). The previous work dates back to 2016, which used version 2.16 of TPC-H and was meant mainly for Windows-based machines.Because Linux systems are more strict with case sensitivity of characters, the existing SQL queries available do not work under Linux.
This work reviewed the SQL queries and created a script to make the task easier. All credits to the original author and the TPC team for making these tools available.



Implementation of TPC-H schema into MySQL and MariaDB. 

[Visit the Downloads page of TPC and download the latest version of TPC-H](http://tpc.org/tpc_documents_current_versions/current_specifications5.asp)  

Move the zipped folder to /tmp of the target Linux server
```
$ mv TPCH_Tools*.zip /tmp
``` 
Unzip the downloaded file

```
$ unzip TPCH_Tools*.zip
``` 

Navigate through the command line to DBGEN folder  
```
$ cd /tmp/TPCH_Tools_*/dbgen/
```  

Type make -v and gcc -v on shell to detect if necessary tools are installed.

Install ‘make’ and ‘gcc’ if not available. If both are not present, the command below shall help in ubuntu
```
$ sudo apt install make && sudo apt install gcc -y
```  

Make a copy of the dummy makefile  
```
$ cp makefile.suite makefile
```  

Still, in the dbgen folder edit the makefile with the command below to use Nano or alternative text editor.
```
$ sudo nano makefile
```  
 
Find the values CC, DATABASE, MACHINE and WORKLOAD and change them as follows
```
################
## CHANGE NAME OF ANSI COMPILER HERE
################
CC      = gcc
# Current values for DATABASE are: INFORMIX, DB2, TDAT (Teradata)
#                                  SQLSERVER, SYBASE, ORACLE, VECTORWISE
# Current values for MACHINE are:  ATT, DOS, HP, IBM, ICL, MVS, 
#                                  SGI, SUN, U2200, VMS, LINUX, WIN32 
# Current values for WORKLOAD are:  TPCH
DATABASE= ORACLE
MACHINE = LINUX
WORKLOAD = TPCH
#
...
```  

Quit Nano or the text editor of choice by saving the changes.


Inside the DBgen folder, run the make command.  
```
$ make
```  

Generate the files for the population. The -s represents the scale factor which has properly defined values in TPC-H documentation and can be a minimum of 1, representing 1 GB. For testing purposes, 0.1 is used here, representing 100MB of data.  
```
$ ./dbgen -s 0.1
```  

The generation of files will take some time. After completion, it will create a series of files ending with .tbl. To list them, type
```
$ ls -l *.tbl
``` 

Use the import_TPCH_to_MariaDB.sh script from this git repository. First clone it inside your folder using the code below.
```
$ git clone import_TPCH_to_MariaDB.sh tpch_to_mariadb.sql
``` 
 
Make sure that the codes are in dbgen folder. Then set the file to execution mode with chmod
```
$ chmod +x import_TPCH_to_MariaDB.sh
``` 

To execute the import_TPCH_to_MariaDB.sh, you will need the full administrative privileges of a database user. This is usually root access.
```
$ import_TPCH_to_MariaDB.sh root 
```
The system will ask for the database password. Once provided, the system will import the data into the database.
The import_TPCH_to_MariaDB.sh  is simply executing the tpch_to_mariadb.sql script. In case the script does not work, The files can be manually edited to meet the requirements of the server 

Once the make file is executed, TPC-H creates a folder in dbgen labelled queries that contains 22 queries for use to test the database. The queries require formatting for execution in MySQL and MariaDB.
The GitHub repository has a folder labelled sample queries that contain sample queries similar to the 22 generated ones. Users may refer to them to adapt their generated queries from the dbgen/queries folder for MySQL and MariaDB.

I hope this work becomes helpful to you.

Riyad
