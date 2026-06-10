# 📊 Automatic Grading System (Bash)

## 📌 Overview
This project is a Bash-based automatic grading system that evaluates student submissions by executing solutions, comparing outputs, and updating a gradebook.

The script is designed to simulate a real-world grading pipeline using basic Linux command-line tools.

---

## ⚙️ How It Works

The grading system follows these steps:

1. Reads a roster of student usernames
2. Executes instructor-provided solution commands
3. Stores expected outputs for each problem
4. Runs each student’s submitted commands
5. Compares outputs using `diff`
6. Assigns:
   - **1 point** → exact match
   - **0.5 points** → minor differences (< 10 lines)
   - **0 points** → incorrect output
7. Updates the main grade table automatically

---

## 📁 Project Structure
project/
│
├── instructor/
│   ├── roster
│   ├── solution
│   ├── maintable
│
├── stu1/
│   └── hw
│
├── stu2/
│   └── hw
│
├── stu3/
│   └── hw
│
└── grade_script.sh
