# tpcds-kit

The official TPC-DS tools can be found at [tpc.org](http://www.tpc.org/tpc_documents_current_versions/current_specifications.asp).

This tpcds-kit is ported from [gregrahn/tpcds-kit](https://github.com/gregrahn/tpcds-kit), thanks to [gregrahn](https://github.com/gregrahn), this version is based on v2.7.0 and has been modified to:
* Allow compilation under macOS (commit [2ec45c5](https://github.com/gregrahn/tpcds-kit/commit/2ec45c5ed97cc860819ee630770231eac738097c))
* Address obvious query template bugs like
  * https://github.com/gregrahn/tpcds-kit/issues/30
  * https://github.com/gregrahn/tpcds-kit/issues/31
  * https://github.com/gregrahn/tpcds-kit/issues/33

## 1. Setup

### 1.1 install required development tools

Make sure the required development tools are installed:

- Ubuntu: `sudo apt-get install gcc make flex bison byacc git`
- CentOS/RHEL: `sudo yum install gcc make flex bison byacc git`
- MacOS: `xcode-select --install`

### 1.2 clone the code

`git clone https://github.com/huaj1101/petadata-tpcds-kit.git`

### 1.3 build

- Linux: `cd tools && make OS=LINUX -j8 && cd -`
- MacOS: `cd tools && make OS=MACOS -j8 && cd -`

## 2. Data generation

Data generation is done via `dsdgen`:
```sh
# "-sc" is used to specify the volume of data to generate in GB.
cd tools && ./dsdgen -sc 100 -f && cd -
```

## 3. Load data into mysql first
The mysql should on ecs, in the same zone with petadata

```sh
mysql -u root -p123 -e "drop database if exists tpcds;"
mysql -u root -p123 -e "create database tpcds;"
mysql -u root -p123 -D tpcds < tools/tpcds_mysql.sql
./load_data.sh
```
The load data step may take hours

## 4. Load Data into petadata
Create database tpcds in petadata first, user name: htap, passwd: AAbb1234

Create tables in petadata:
```sh
mysql -h pd-2ze37xe0ba465f75o.petadata.rds.aliyuncs.com -u htap -pAAbb1234 -D tpcds < tools/tpcds.sql
./load_data.sh
```

Use aliyun dms service to transmit from mysql to petadata

## 5. Query generation

Query generation is done via `dsqgen` with query templetes, here we use a pre-written shell script file [genquery.sh](./genquery.sh), after running this script, queries are located in directory "queries":
```sh
./genquery.sh
```

All supported TPC-DS queries for TiDB are generated in `tools/queries`

