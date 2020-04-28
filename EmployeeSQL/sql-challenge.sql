-- Data Modeling
-- Create table schema
-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/

CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
	"emp_no" INT NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "gender" VARCHAR(1)   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" INT   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

CREATE TABLE "titles" (
    "emp_no" INT   NOT NULL,
    "title" VARCHAR   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no_dept_no" FOREIGN KEY("emp_no", "dept_no")
REFERENCES "dept_emp" ("emp_no", "dept_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "titles" ADD CONSTRAINT "fk_titles_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

-- Import csv files to tables

-- Data Analysis
-- 1. List the following details of each employee: employee number, last name, first name, gender, and salary.
CREATE VIEW "1_employee_details" AS (
	SELECT e.emp_no, e.last_name, e.first_name, e.gender, s.salary
	FROM employees e 
	INNER JOIN salaries s ON e.emp_no = s.emp_no
);

-- 2. List employees who were hired in 1986.
CREATE VIEW "2_employees_1986" AS (
	SELECT emp_no, last_name, first_name, EXTRACT(year FROM hire_date) AS "hire_year"
	FROM employees
	WHERE EXTRACT(year FROM hire_date) = 1986
);

-- 3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name, and start and end employment dates.
CREATE VIEW "3_dept_managers" AS (
	SELECT dm.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name, dm.from_date, dm.to_date
	FROM dept_manager dm
	INNER JOIN departments d ON dm.dept_no = d.dept_no
	INNER JOIN employees e ON dm.emp_no = e.emp_no
);

-- 4. List the department of each employee with the following information: employee number, last name, first name, and department name.
CREATE VIEW "4_employee_dept" AS(
	SELECT e.emp_no, e.last_name, e.first_name, joint.dept_name
	FROM employees e
	INNER JOIN(
		SELECT d.dept_no, d.dept_name, de.emp_no
		FROM departments d
		INNER JOIN dept_emp de ON d.dept_no = de.dept_no
		) AS "joint"
	ON e.emp_no = joint.emp_no
);

-- 5. List all employees whose first name is "Hercules" and last names begin with "B."
CREATE VIEW "5_Hercules_B" AS(
	SELECT emp_no, last_name, first_name
	FROM employees
	WHERE first_name = 'Hercules' AND last_name LIKE 'B%'
);

-- 6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
CREATE VIEW "6_sales_dept" AS(	
	SELECT e.emp_no, e.last_name, e.first_name, joint.dept_name
	FROM employees e
	INNER JOIN(
		SELECT d.dept_no, d.dept_name, de.emp_no
		FROM departments d
		INNER JOIN dept_emp de ON d.dept_no = de.dept_no
		) AS "joint"
	ON e.emp_no = joint.emp_no
	WHERE joint.dept_name = 'Sales'
);

-- 7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
CREATE VIEW "7_sales_dev_depts" AS(	
	SELECT e.emp_no, e.last_name, e.first_name, joint.dept_name
	FROM employees e
	INNER JOIN(
		SELECT d.dept_no, d.dept_name, de.emp_no
		FROM departments d
		INNER JOIN dept_emp de ON d.dept_no = de.dept_no
		) AS "joint"
	ON e.emp_no = joint.emp_no
	WHERE joint.dept_name = 'Sales' OR joint.dept_name = 'Development'
);

-- 8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
CREATE VIEW "8_last_name_count" AS(
	SELECT last_name, COUNT(emp_no) AS "employee_count" FROM employees
	GROUP BY last_name
	ORDER BY last_name DESC
);





