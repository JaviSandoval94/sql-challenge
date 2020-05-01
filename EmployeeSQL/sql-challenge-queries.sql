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