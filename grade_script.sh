#!/bin/bash
# ========================================
# Automatic Grading Script
# ========================================

# ------------------------
# Configuration
# ------------------------
# Define file paths used in the grading process

ROSTER="instructor/roster"        # File containing list of student usernames
SOLUTION="instructor/solution"    # File containing correct commands (one per problem)
MAINTABLE="instructor/maintable"  # Main grade table where scores will be stored

TMP_DIR="tmp_grading"             # Temporary directory used during grading
mkdir -p $TMP_DIR                 # Create the temporary directory

# ------------------------
# Count the number of lines in the solution file.
# Each line represents one problem/command.

NUM_PROBLEMS=$(wc -l < $SOLUTION)
# ------------------------
# Step 1: Generate expected outputs
# ------------------------
# This section runs the correct solution commands and stores
# their outputs so we can compare student answers against them.

echo "Generating expected outputs..."

# Loop through each problem number from 1 to NUM_PROBLEMS
for i in $(seq 1 $NUM_PROBLEMS); do

    # Extract the i-th command from the solution file
    # Each line of the solution file corresponds to one problem
    CMD=$(sed -n "${i}p" $SOLUTION)

    # Execute the command and store its output in a temporary file
    # This file will contain the correct output for problem i
    eval "$CMD" > "$TMP_DIR/expected_output_$i"
done


# ------------------------
# Step 2: Grade students
# ------------------------
# This section runs each student's commands, compares their outputs
# with the expected outputs, and calculates a grade.

echo "Grading students..."

# Create a temporary column that will store grades for HW1
GRADE_COLUMN="$TMP_DIR/grades_column"

# Add the header "HW1" for the new homework column
echo "HW1" > $GRADE_COLUMN

# Read each student username from the roster file
while read STUDENT; do

    # Each student has a directory named after their username
    STUDENT_DIR="$STUDENT"

    # Their homework file is named "hw" inside their folder
    STUDENT_HW="$STUDENT_DIR/hw"

    # Initialize total score for this student
    TOTAL=0

    # Loop through each problem
    for i in $(seq 1 $NUM_PROBLEMS); do

        # Extract the student's command for problem i
        STUDENT_CMD=$(sed -n "${i}p" $STUDENT_HW)

        # Run the student's command and store the output in a temp file
        eval "$STUDENT_CMD" > "$TMP_DIR/student_output"

        # Compare student output with the expected output
        # diff prints differences; wc -l counts how many lines differ
        DIFF_LINES=$(diff "$TMP_DIR/student_output" "$TMP_DIR/expected_output_$i" | wc -l)

        # If there are no differences, give full credit
        if [ $DIFF_LINES -eq 0 ]; then
            TOTAL=$(echo "$TOTAL + 1" | bc -l)

        # If differences exist but are small (<10 lines), give partial credit
        elif [ $DIFF_LINES -lt 10 ]; then
            TOTAL=$(echo "$TOTAL + 0.5" | bc -l)
        fi
    done

    # Print the student's grade to the terminal
    echo "$STUDENT got $TOTAL"

    # Add the student's grade to the grade column file
    echo "$TOTAL" >> $GRADE_COLUMN

# Continue reading students from the roster file
done < $ROSTER


# ------------------------
# Step 3: Update main table
# ------------------------
# This section adds the new homework grades to the main grade table.

# paste merges the existing table with the new grade column
paste $MAINTABLE $GRADE_COLUMN > "$TMP_DIR/temp_table"

# Replace the old main table with the updated version
mv "$TMP_DIR/temp_table" $MAINTABLE


# ------------------------
# Step 4: Clean up
# ------------------------
# Remove the temporary directory and files used during grading

rm -rf $TMP_DIR


# Final message confirming grading finished
echo "Grading complete! Main table updated at $MAINTABLE"