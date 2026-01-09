# Freelance Skill Demand & Pricing Analysis
 ## Project Overview

The freelance market is highly competitive, and both freelancers and clients struggle to understand which skills are in demand, how experience affects opportunities, and how pricing varies across job types.
This project analyzes freelance job postings to uncover skill demand patterns, experience-level trends, pricing structures, and geographic distribution of jobs using SQL and Power BI.

## Objectives

Identify high-demand freelance skills

Analyze job distribution across experience levels

Compare hourly vs fixed-price job trends

Understand country-wise hiring patterns

Present insights through an interactive dashboard

## Dataset

The dataset contains freelance job postings with fields such as:

Job category

Required skills

Experience level

Job type (hourly / fixed price)

Budget or hourly rate

Client country

(Dataset was pre-cleaned for analysis using SQL queries.)

## Tools & Technologies

SQL (MySQL) – data cleaning, aggregation, and analysis

Power BI – interactive dashboard creation

GitHub – version control and project sharing

## Methodology

Data Cleaning

Removed irrelevant columns

Handled missing and inconsistent values

Standardized categorical fields (experience level, job type)

SQL Analysis

Aggregated jobs by skill, category, and experience level

Compared hourly vs fixed-price job distribution

Analyzed pricing trends across job categories

Grouped job postings by client country

## Visualization

Built an interactive Power BI dashboard

Used slicers for category, experience level, and job type

Created charts for skill demand, pricing, and geographic insights

## Key Insights

Intermediate-level roles dominate freelance job postings

Marketing and social media skills appear frequently across projects

Hourly contracts are more common than fixed-price jobs

Specialized business and CRM-related skills tend to command higher pay

A small number of countries account for a large share of job postings

## Sample SQL Queries

### Job Distribution by Experience Level
```sql
SELECT experience_level, COUNT(*) AS job_count
FROM freelance_jobs
GROUP BY experience_level
ORDER BY job_count DESC;


