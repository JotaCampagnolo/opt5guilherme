drivers = LOAD 'drivers.csv' USING PigStorage(',') AS (driverID:int, name:chararray, ssn:int, location:chararray, certified:int);
times = LOAD 'timesheet.csv' USING PigStorage(',') AS (driverID:int, week:int, hours:int, kms:int);

-- Q1: Encontrar o nome e o número de horas do motorista que mais dirigiu:
outQ1 = group times by driverID;
outQ1 = foreach outQ1 generate group, SUM(times.kms);
outQ1 = order outQ1 by $1 desc;
outQ1 = limit outQ1 1;
outQ1 = join drivers by driverID, outQ1 by $0;
outQ1 = foreach outQ1 generate $1, $6;
dump outQ1;

-- Q2: Encontrar os 10 motoristas com mais km rodados por hora:
outQ2 = group times by driverID;
outQ2 = foreach outQ2 generate group, SUM(times.kms)/SUM(times.hours);
outQ2 = order outQ2 by $1 desc;
outQ2 = limit outQ2 10;
outQ2 = join drivers by driverID, outQ2 by $0;
outQ2 = foreach outQ2 generate $1, $6;
outQ2 = order outQ2 by $1 desc;
dump outQ2;

-- Q3: Mostrar os motoristas com mais km rodados em ordem crescente pela velocidade -km/h (calcular a velocidade média):
outQ3 = group times by driverID;
outQ3 = foreach outQ3 generate group, SUM(times.kms)/SUM(times.hours);
outQ3 = order outQ3 by $1 asc;
outQ3 = join drivers by driverID, outQ3 by $0;
outQ3 = foreach outQ3 generate $1, $6;
outQ3 = order outQ3 by $1 asc;
dump outQ3;
