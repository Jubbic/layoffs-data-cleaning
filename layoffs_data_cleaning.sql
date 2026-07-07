-- Data Cleaning


SELECT *
FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null values or blank values
-- 4. Remove any unwanted columns or rows

 

create table layoffs_staging
like layoffs;


SELECT *
FROM layoffs_staging;

insert layoffs_staging
SELECT *
FROM layoffs;


SELECT *,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, 'date') as row_num
FROM layoffs_staging;

with duplicate_cte as
(
SELECT *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
where row_num > 1;


SELECT *
FROM layoffs_staging
where company = 'casper';

 


with duplicate_cte as
(
SELECT *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
FROM layoffs_staging
)
DELETE
FROM duplicate_cte
where row_num > 1;





CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging2
where row_num > 1;

insert into layoffs_staging2
SELECT *,
row_number() over(
partition by company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions) as row_num
FROM layoffs_staging;





DELETE 
FROM layoffs_staging2
where row_num > 1;

SELECT *
FROM layoffs_staging2;


-- Standardizing data

SELECT company, trim(company)
FROM layoffs_staging2;

update layoffs_staging2    
set company = trim(company);


SELECT  *
FROM layoffs_staging2
where industry like 'crypto%';

update layoffs_staging2
set industry = 'crypto'
where industry like 'crypto%';


SELECT distinct country, trim(trailing '.' from country)
FROM layoffs_staging2
order by 1;

update layoffs_staging2
set country = trim(trailing '.' from country)
where country like 'united states%';

SELECT `date`
FROM layoffs_staging2;


update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y');


alter table layoffs_staging2
modify column `date` date;  


SELECT *
FROM layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

update layoffs_staging2
set industry = null
where industry = '';

SELECT *
FROM layoffs_staging2
where industry is null
or industry = '';

SELECT *
FROM layoffs_staging2
where company like 'Bally%';

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
join layoffs_staging2 t2
   on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

update layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null 
and t2.industry is not null;

SELECT *
from layoffs_staging2;



SELECT *
FROM layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;


DELETE
FROM layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
drop column row_num;