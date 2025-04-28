// Counter for questions and answers
let questionCounter = 1;
const answerCounters = {1: 4}; // Question 1 starts with 4 answers

// Function to add a new answer to a question
function addAnswer(questionId) {
    // Increment the answer counter for this question
    if (!answerCounters[questionId]) {
        answerCounters[questionId] = 0;
    }
    answerCounters[questionId]++;
    const answerCount = answerCounters[questionId];

    // Create new answer HTML with question ID and answer number in placeholder
    const answerHtml = `
                    <div class="answer-item">
                    <input type="checkbox" name="correct_${questionId}_${answerCount}" class="answer-checkbox" id="answer_${questionId}_${answerCount}">
                    <input type="text" name="answer_${questionId}_${answerCount}" class="answer-input" placeholder="Enter answer option ${answerCount}">
                        <button type="button" class="delete-btn" onclick="deleteAnswer(this)">
                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-x" viewBox="0 0 16 16">
                                    <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
                            </svg>
                        </button>
                        </div>`;

    // Find the answers container for this question
    const questionPanel = document.querySelector(`.question-panel[data-question-id="${questionId}"]`);
    const answersContainer = questionPanel.querySelector(".answers-container");

    // Insert the new answer before the "Add Answer" button
    answersContainer.insertAdjacentHTML("beforeend", answerHtml);
}

// Function to delete an answer
function deleteAnswer(button) {
    const answerItem = button.closest(".answer-item");
    const questionPanel = button.closest(".question-panel");
    const questionId = questionPanel.getAttribute("data-question-id");

    // Remove the answer item
    answerItem.remove();

    // Update answer numbers for this question
    updateAnswerNumbers(questionId);
}

// Function to update answer numbers after deletion
function updateAnswerNumbers(questionId) {
    const questionPanel = document.querySelector(`.question-panel[data-question-id="${questionId}"]`);
    const answerItems = questionPanel.querySelectorAll(".answer-item");

    // Reset the answer counter for this question
    answerCounters[questionId] = answerItems.length;

    // Update all answer inputs and checkboxes in this question
    answerItems.forEach((item, answerIndex) => {
        const answerNumber = answerIndex + 1;
        const checkbox = item.querySelector(".answer-checkbox");
        const input = item.querySelector(".answer-input");

        // Update name and id attributes
        checkbox.name = `correct_${questionId}_${answerNumber}`;
        checkbox.id = `answer_${questionId}_${answerNumber}`;
        input.name = `answer_${questionId}_${answerNumber}`;

        // Update placeholder with the question ID and new answer number
        input.placeholder = `Enter answer option ${answerNumber}`;
    });
}

// Function to delete a question
function deleteQuestion(button) {
    const questionPanel = button.closest(".question-panel");

    // Don't allow deleting if it's the only question
    const questionCount = document.querySelectorAll(".question-panel").length;
    if (questionCount <= 1) {
        alert("You cannot delete the only question. At least one question is required.");
        return;
    }

    // Get the question ID before removing
    const questionId = parseInt(questionPanel.getAttribute("data-question-id"));

    // Remove the question panel
    questionPanel.remove();

    // Remove this question's entry from answerCounters
    delete answerCounters[questionId];

    // Update question counter
    questionCounter = document.querySelectorAll(".question-panel").length;

    // Update question numbers and their associated elements
    updateQuestionNumbers();
}

// Function to update question numbers after deletion
function updateQuestionNumbers() {
    const questionPanels = document.querySelectorAll(".question-panel");

    // Create a new answerCounters object to store updated values
    const newAnswerCounters = {};

    questionPanels.forEach((panel, index) => {
        const oldQuestionId = parseInt(panel.getAttribute("data-question-id"));
        const questionNumber = index + 1;

        // Update question panel attributes
        panel.setAttribute("data-question-id", questionNumber);
        panel.querySelector(".question-header").textContent = `Question ${questionNumber}`;

        // Update the question input name
        const questionInput = panel.querySelector(".question-input");
        questionInput.name = `question_${questionNumber}`;

        // Update all answer inputs and checkboxes in this question
        const answerItems = panel.querySelectorAll(".answer-item");
        answerItems.forEach((item, answerIndex) => {
            const answerNumber = answerIndex + 1;
            const checkbox = item.querySelector(".answer-checkbox");
            const input = item.querySelector(".answer-input");

            checkbox.name = `correct_${questionNumber}_${answerNumber}`;
            checkbox.id = `answer_${questionNumber}_${answerNumber}`;
            input.name = `answer_${questionNumber}_${answerNumber}`;

            // Update placeholder with the new question ID and answer number
            input.placeholder = `Enter answer option ${answerNumber}`;
        });

        // Update the add answer button
        const addAnswerBtn = panel.querySelector(".add-answer-btn");
        addAnswerBtn.setAttribute("onclick", `addAnswer(${questionNumber})`);

        // Update the answer counter for this question
        newAnswerCounters[questionNumber] = answerItems.length;
    });

    // Replace the old answerCounters with the new one
    Object.assign(answerCounters, newAnswerCounters);
}

// Function to add a new question
document.getElementById("addQuestionBtn").addEventListener("click", function () {
    // Increment question counter
    questionCounter++;
    // Initialize answer counter for this question
    answerCounters[questionCounter] = 2; // Start with 2 answers for new questions

    // Create new question HTML with question ID and answer number in placeholders
    const questionHtml = `
                    <div class="question-panel" data-question-id="${questionCounter}">
                        <div class="question-header">Question ${questionCounter}</div>
                        <button type="button" class="delete-btn delete-question-btn" onclick="deleteQuestion(this)">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-x" viewBox="0 0 16 16">
                                <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
                            </svg>
                        </button>
                        <input type="text" name="question_${questionCounter}" class="question-input" placeholder="Enter your question here">
                    
                        <div class="answers-container">
                            <!-- Answer 1 -->
                            <div class="answer-item">
                                <input type="checkbox" name="correct_${questionCounter}_1" class="answer-checkbox" id="answer_${questionCounter}_1">
                                <input type="text" name="answer_${questionCounter}_1" class="answer-input" placeholder="Enter answer option 1">
                                <button type="button" class="delete-btn" onclick="deleteAnswer(this)">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-x" viewBox="0 0 16 16">
                                        <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
                                    </svg>
                                </button>
                            </div>
                        
                            <!-- Answer 2 -->
                            <div class="answer-item">
                                <input type="checkbox" name="correct_${questionCounter}_2" class="answer-checkbox" id="answer_${questionCounter}_2">
                                <input type="text" name="answer_${questionCounter}_2" class="answer-input" placeholder="Enter answer option 2">
                                <button type="button" class="delete-btn" onclick="deleteAnswer(this)">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-x" viewBox="0 0 16 16">
                                        <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
                                    </svg>
                                </button>
                            </div>
                        </div>
                    
                        <button type="button" class="add-answer-btn" onclick="addAnswer(${questionCounter})">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-plus" viewBox="0 0 16 16">
                                <path d="M8 4a.5.5 0 0 1 .5.5v3h3a.5.5 0 0 1 0 1h-3v3a.5.5 0 0 1-1 0v-3h-3a.5.5 0 0 1 0-1h3v-3A.5.5 0 0 1 8 4z"/>
                            </svg>
                            Add Answer Option
                        </button>
                    </div>`;

    // Add the new question to the container
    const questionsContainer = document.getElementById("questionsContainer");
    questionsContainer.insertAdjacentHTML("beforeend", questionHtml);
});

// Function to validate the form before submission
function validateQuizForm() {
    let isValid = true;
    const questionPanels = document.querySelectorAll(".question-panel");

    questionPanels.forEach((panel, index) => {
        const questionNumber = index + 1;
        const questionInput = panel.querySelector(".question-input");
        const answerItems = panel.querySelectorAll(".answer-item");
        const correctAnswers = panel.querySelectorAll(".answer-checkbox:checked");

        // Check if question is empty
        if (!questionInput.value.trim()) {
            alert(`Question ${questionNumber} cannot be empty.`);
            isValid = false;
            return false; // Break the forEach loop
        }

        // Check if there are at least 2 answers
        if (answerItems.length < 2) {
            alert(`Question ${questionNumber} must have at least 2 answer options.`);
            isValid = false;
            return false;
        }

        // Check if at least one correct answer is selected
        if (correctAnswers.length === 0) {
            alert(`Question ${questionNumber} must have at least one correct answer selected.`);
            isValid = false;
            return false;
        }

        // Check if any answer is empty
        let emptyAnswerFound = false;
        answerItems.forEach((item, answerIndex) => {
            const answerInput = item.querySelector(".answer-input");
            if (!answerInput.value.trim()) {
                emptyAnswerFound = true;
            }
        });

        if (emptyAnswerFound) {
            alert(`All answer options in Question ${questionNumber} must be filled.`);
            isValid = false;
            return false;
        }
    });

    return isValid;
}

// Add form validation before submission
document.getElementById("quizForm").addEventListener("submit", function (event) {
    if (!validateQuizForm()) {
        event.preventDefault();
    }
});

// Function to update existing answer placeholders on page load
function updateExistingAnswerPlaceholders() {
    const questionPanels = document.querySelectorAll(".question-panel");

    questionPanels.forEach((panel) => {
        const questionId = panel.getAttribute("data-question-id");
        const answerItems = panel.querySelectorAll(".answer-item");

        answerItems.forEach((item, index) => {
            const answerNumber = index + 1;
            const input = item.querySelector(".answer-input");
            input.placeholder = `Enter answer option ${answerNumber}`;
        });
    });
}

// Call this function when the DOM is loaded
document.addEventListener("DOMContentLoaded", function () {
    updateExistingAnswerPlaceholders();
});
