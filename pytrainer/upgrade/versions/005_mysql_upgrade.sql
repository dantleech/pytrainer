-- athlete stats added in version 1.7.2
create table athletestats (
	id_athletestat integer primary key auto_increment,
	date date,
	weight float,
	bodyfat float,
	restinghr integer,
	maxhr integer
);