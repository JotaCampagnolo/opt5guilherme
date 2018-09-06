movies = LOAD 'movies.dat' USING PigStorage(':') AS (movieID:int, title:chararray, genre:chararray);
ratings = LOAD 'ratings.dat' USING PigStorage(':') AS (userID:int, movieID:int, rating:int, timestamp:long);
users = LOAD 'users.dat' USING PigStorage(':') AS (userID:int, gender:chararray, age:int, occupation:int, zipcode:int);

-- Q1: Encontrar os ids dos usuários que avaliaram mais de 10 filmes (usar  o aquivos ratings.dat):
outQ1 = group ratings by userID;
outQ1 = foreach outQ1 generate group, COUNT(ratings.userID);
outQ1 = order outQ1 by $1 desc;
outQ1 = limit outQ1 10;
dump outQ1;

-- Q2: Encontrar o número de usuários masculinos e femininos de cada grupo de idades (os dados do arquivo user.dat
-- já estão organizados em categorias):
males = filter users by gender == 'M';
females = filter users by gender == 'F';
outQ2_M = group males by age;
outQ2_F = group females by age;
outQ2_M = foreach outQ2_M generate group, COUNT(males.age);
outQ2_F = foreach outQ2_F generate group, COUNT(females.age);
dump outQ2_M;
dump outQ2_F;

-- Q3: Encontrar o nome dos 10 filmes mais bem avaliados:
outQ3 = group ratings by movieID;
outQ3 = foreach outQ3 generate group, AVG(ratings.rating);
outQ3 = order outQ3 by $1 desc;
outQ3 = limit outQ3 10;
outQ3 = join movies by movieID, outQ3 by $0;
outQ3 = foreach outQ3 generate title;
dump outQ3;

-- Q4: Encontrar entre os 100 mais avaliados os 10 filmes com melhores notas:
outQ4 = group ratings by movieID;
outQ4 = foreach outQ4 generate group, COUNT(ratings.movieID), AVG(ratings.rating);
outQ4 = order outQ4 by $1 desc;
outQ4 = limit outQ4 100;
outQ4 = order outQ4 by $2 desc;
outQ4 = limit outQ4 10;
outQ4 = join movies by movieID, outQ4 by $0;
outQ4 = foreach outQ4 generate title, $5;
dump outQ4;

-- Q5: Encontrar entre os 100 que mais avaliaram o usuário M e o F com melhor  média de avaliação:
outQ5 = group ratings by userID;
outQ5 = foreach outQ5 generate group, COUNT(ratings.userID), AVG(ratings.rating);
outQ5 = order outQ5 by $1 desc;
outQ5 = limit outQ5 100;
outQ5 = join users by userID, outQ5 by $0;
outQ5_M = filter outQ5 by gender == 'M';
outQ5_M = order outQ5_M by $7 desc;
outQ5_M = limit outQ5_M 1;
outQ5_F = filter outQ5 by gender == 'F';
outQ5_F = order outQ5_F by $7 desc;
outQ5_F = limit outQ5_F 1;
DUMP outQ5_M;
DUMP outQ5_F;

 -- Q6: Listar os nomes dos filmes mais avaliados (top 100):
 outQ6 = group ratings by movieID;
 outQ6 = foreach outQ6 generate group, COUNT(ratings.movieID);
 outQ6 = order outQ6 by $1 desc;
 outQ6 = limit outQ6 100;
 outQ6 = join movies by movieID, outQ6 by $0;
 outQ6 = foreach outQ6 generate $1, $4;
 outQ6 = order outQ6 by $1 desc;
 dump outQ6;

-- Q7: Qual é o número da ocupação (campo da tabela user.dat) mais frequente que avaliaram o filme com nota = 1:
outQ7 = filter ratings by rating == 1;
outQ7 = join users by userID, outQ7 by $0;
outQ7 = group outQ7 by $3;
outQ7 = foreach outQ7 generate group, COUNT(outQ7.$0);
outQ7 = limit outQ7 1;
dump outQ7;

-- Q8: Qual é a faixa de idade do usuários que mais avaliam filmes:
outQ8 = join users by userID, ratings by userID;
outQ8 = group outQ8 by $2;
outQ8 = foreach outQ8 generate group, COUNT(outQ8.$0);
outQ8 = limit outQ8 1;
dump outQ8;
