// Clock functionality
function updateClock() {
    const now = new Date()
    const options = {
        month: "short",
        day: "2-digit",
        year: "numeric",
        hour: "2-digit",
        minute: "2-digit",
        second: "2-digit",
        hour12: false,
    }
    document.querySelector(".timestamp").textContent = now.toLocaleDateString("en-US", options)
}

setInterval(updateClock, 1000)
updateClock()

// Timer functionality
let timeLeft = window.remainingSeconds || window.quizTimeLimit * 60
const timerElement = document.getElementById("timer")

function updateTimer() {
    const minutes = Math.floor(timeLeft / 60)
    const seconds = timeLeft % 60

    timerElement.textContent = `${minutes.toString().padStart(2, "0")}:${seconds.toString().padStart(2, "0")}`
    if (timeLeft <= 0) {
        clearInterval(timerInterval)
        submitQuiz()
    } else {
        timeLeft--
    }
}

// Initialize timer
updateTimer()
const timerInterval = setInterval(updateTimer, 1000)

// Thêm biến để theo dõi trạng thái tải
let isLoading = false

// Khởi tạo mảng answeredQuestionsArray trống
window.answeredQuestionsArray = []

// Hàm để lấy dữ liệu câu hỏi đã trả lời từ server ngay khi trang được tải
function initializeAnsweredQuestions() {
    const xhr = new XMLHttpRequest()
    xhr.open("POST", "do", true)
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")

    xhr.onload = () => {
        if (xhr.status === 200) {
            try {
                const data = JSON.parse(xhr.responseText)

                // Cập nhật mảng câu hỏi đã trả lời từ server
                if (data.answeredQuestions) {
                    window.answeredQuestionsArray = data.answeredQuestions
                    console.log("Answered questions initialized from server:", window.answeredQuestionsArray)

                    // Cập nhật UI cho các nút câu hỏi
                    updateQuestionButtonsUI()
                }
            } catch (e) {
                console.error("Error parsing JSON:", e)
            }
        }
    }

    // Gửi request để lấy dữ liệu câu hỏi hiện tại
    const currentQuestionNumber = Number.parseInt(document.getElementById("currentQuestionNumber").textContent)
    xhr.send("action=getQuestionData&questionNumber=" + currentQuestionNumber)
}

function navigateToQuestion(questionNumber) {
    // Nếu đang tải, không cho phép chuyển câu hỏi
    if (isLoading)
        return

    // Không cần cập nhật màu sắc ở đây nữa, sẽ được xử lý trong updateQuestionUI

    // Hiển thị trạng thái đang tải
    isLoading = true
    document.querySelector(".question-content").classList.add("loading")

    // Save current answers
    saveCurrentAnswers()

    // Use AJAX to get question data
    const xhr = new XMLHttpRequest()
    xhr.open("POST", "do", true)
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    xhr.timeout = 10000 // Timeout sau 10 giây

    xhr.onload = () => {
        isLoading = false
        document.querySelector(".question-content").classList.remove("loading")

        if (xhr.status === 200) {
            try {
                const data = JSON.parse(xhr.responseText)
                updateQuestionUI(data)

                // Update URL without reloading
                const url = new URL(window.location.href)
                url.searchParams.set("questionNumber", questionNumber)
                window.history.pushState({}, "", url)
            } catch (e) {
                console.error("Error parsing JSON:", e)
                alert("Error loading question. Please try again.")
            }
        }
    }

    xhr.onerror = () => {
        isLoading = false
        document.querySelector(".question-content").classList.remove("loading")
        alert("Error loading question. Please try again.")
    }

    xhr.ontimeout = () => {
        isLoading = false
        document.querySelector(".question-content").classList.remove("loading")
        alert("Request timed out. Please try again.")
    }

    xhr.send("action=getQuestionData&questionNumber=" + questionNumber)
}

function updateQuestionUI(data) {
    // Update question number
    document.getElementById("currentQuestionNumber").textContent = data.questionNumber

    // Update question title and content
    document.querySelector(".question-title").textContent = "Question " + data.questionNumber
    document.querySelector(".question-text").textContent = data.content

    // Lưu questionId vào form
    const form = document.getElementById("questionForm")
    form.setAttribute("data-question-id", data.questionId)

    // Cập nhật mảng câu hỏi đã trả lời từ dữ liệu server
    if (data.answeredQuestions) {
        window.answeredQuestionsArray = data.answeredQuestions
    }

    // Kiểm tra xem câu hỏi hiện tại có các tùy chọn được chọn không
    const hasSelectedAnswers = data.options.some((option) => option.selected)

    // Cập nhật mảng câu hỏi đã trả lời dựa trên việc kiểm tra các tùy chọn được chọn
    if (hasSelectedAnswers) {
        if (!window.answeredQuestionsArray.includes(data.questionNumber)) {
            window.answeredQuestionsArray.push(data.questionNumber)
        }
    } else {
        // Nếu không có câu trả lời nào được chọn, loại bỏ khỏi mảng câu hỏi đã trả lời
        const index = window.answeredQuestionsArray.indexOf(data.questionNumber)
        if (index !== -1) {
            window.answeredQuestionsArray.splice(index, 1)
        }
    }

    // Update question navigation buttons
    updateQuestionButtonsUI()

    // Cập nhật data attribute cho nút câu hỏi hiện tại
    const currentBtn = document.querySelector(".question-btn.current")
    if (currentBtn) {
        if (hasSelectedAnswers) {
            currentBtn.setAttribute("data-has-answers", "true")
        } else {
            currentBtn.setAttribute("data-has-answers", "false")
        }
    }

    // Update options
    const optionsContainer = document.querySelector(".answer-options")
    optionsContainer.innerHTML = ""

    data.options.forEach((option, index) => {
        const optionDiv = document.createElement("div")
        optionDiv.className = "answer-option"

        const checkbox = document.createElement("input")
        checkbox.type = "checkbox"
        checkbox.id = "option" + index
        checkbox.name = "answer"
        checkbox.value = option.id
        checkbox.checked = option.selected

        const label = document.createElement("label")
        label.htmlFor = "option" + index
        label.textContent = option.content

        optionDiv.appendChild(checkbox)
        optionDiv.appendChild(label)
        optionsContainer.appendChild(optionDiv)

        // Add change event listener
        checkbox.addEventListener("change", () => {
            const currentQuestionNumber = Number.parseInt(document.getElementById("currentQuestionNumber").textContent)

            // Kiểm tra xem có ít nhất một checkbox được chọn không
            const form = document.getElementById("questionForm")
            const hasSelectedAnswers = form.querySelectorAll('input[type="checkbox"]:checked').length > 0

            // Chỉ đánh dấu là đã trả lời nếu có ít nhất một câu trả lời được chọn
            if (hasSelectedAnswers) {
                if (!window.answeredQuestionsArray.includes(currentQuestionNumber)) {
                    window.answeredQuestionsArray.push(currentQuestionNumber)
                }

                // Cập nhật data attribute cho nút câu hỏi hiện tại
                const currentBtn = document.querySelector(".question-btn.current")
                if (currentBtn) {
                    currentBtn.setAttribute("data-has-answers", "true")
                }
            } else {
                // Nếu không có câu trả lời nào được chọn, loại bỏ khỏi mảng câu hỏi đã trả lời
                const index = window.answeredQuestionsArray.indexOf(currentQuestionNumber)
                if (index !== -1) {
                    window.answeredQuestionsArray.splice(index, 1)
                }

                // Cập nhật data attribute cho nút câu hỏi hiện tại
                const currentBtn = document.querySelector(".question-btn.current")
                if (currentBtn) {
                    currentBtn.setAttribute("data-has-answers", "false")
                }
            }

            // Cập nhật UI cho các nút câu hỏi
            updateQuestionButtonsUI()

            console.log("Answered questions after checkbox change:", window.answeredQuestionsArray)
        })
    })

    console.log("Current question UI updated. Answered questions:", window.answeredQuestionsArray)
}

// Hàm cập nhật UI cho các nút câu hỏi
function updateQuestionButtonsUI() {
    const buttons = document.querySelectorAll(".question-btn")
    const currentQuestionNumber = Number.parseInt(document.getElementById("currentQuestionNumber").textContent)

    buttons.forEach((btn) => {
        const btnNumber = Number.parseInt(btn.textContent)

        // Xóa tất cả các lớp trạng thái
        btn.classList.remove("current", "answered", "unanswered")
        btn.disabled = false

        // Nếu là câu hỏi hiện tại, luôn đặt class "current" và disabled
        if (btnNumber === currentQuestionNumber) {
            btn.classList.add("current")
            btn.disabled = true

            // Vẫn giữ data-has-answers attribute để hiển thị viền xanh lá nếu có câu trả lời
            const form = document.getElementById("questionForm")
            const hasSelectedAnswers = form.querySelectorAll('input[type="checkbox"]:checked').length > 0
            if (hasSelectedAnswers) {
                btn.setAttribute("data-has-answers", "true")
            } else {
                btn.setAttribute("data-has-answers", "false")
            }
        } else {
            // Nếu không phải câu hỏi hiện tại, hiển thị trạng thái answered/unanswered
            if (window.answeredQuestionsArray && window.answeredQuestionsArray.includes(btnNumber)) {
                btn.classList.add("answered")
            } else {
                btn.classList.add("unanswered")
            }
        }
    })
}

function nextQuestion() {
    // Lấy giá trị hiện tại từ UI
    const currentQuestionNumber = Number.parseInt(document.getElementById("currentQuestionNumber").textContent)
    const totalQuestions = Number.parseInt(
            document.getElementById("currentQuestionNumber").parentNode.textContent.split("/")[1],
            )

    const nextQuestionNumber = currentQuestionNumber + 1
    if (nextQuestionNumber <= totalQuestions) {
        navigateToQuestion(nextQuestionNumber)
    }
}

// Save answers for the current question
function saveCurrentAnswers() {
    const form = document.getElementById("questionForm")
    const checkboxes = form.querySelectorAll('input[type="checkbox"]:checked')
    const selectedValues = Array.from(checkboxes).map((cb) => cb.value)

    // Lấy questionId từ data-question-id của form
    const questionId = form.getAttribute("data-question-id")
    const currentQuestionNumber = Number.parseInt(document.getElementById("currentQuestionNumber").textContent)

    // Cập nhật mảng câu hỏi đã trả lời
    if (selectedValues.length > 0) {
        if (!window.answeredQuestionsArray.includes(currentQuestionNumber)) {
            window.answeredQuestionsArray.push(currentQuestionNumber)
        }
    } else {
        // Nếu không có câu trả lời nào được chọn, loại bỏ khỏi mảng câu hỏi đã trả lời
        const index = window.answeredQuestionsArray.indexOf(currentQuestionNumber)
        if (index !== -1) {
            window.answeredQuestionsArray.splice(index, 1)
        }
    }

    // Use AJAX to save the answers without page reload
    const xhr = new XMLHttpRequest()
    xhr.open("POST", "do", true)
    xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    xhr.send("action=saveAnswers" + "&questionId=" + questionId + "&answers=" + selectedValues.join(","))
}

// Submit confirmation
function showSubmitConfirmation() {
    document.getElementById("submitModal").style.display = "flex"
}

function hideSubmitConfirmation() {
    document.getElementById("submitModal").style.display = "none"
}

function submitQuiz() {
    // First save the current question's answers
    saveCurrentAnswers();
    
    // Create a form to submit
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = window.location.pathname; // Chỉ sử dụng pathname, không thêm query string
    
    // Add a hidden field to indicate this is a quiz submission
    const actionInput = document.createElement('input');
    actionInput.type = 'hidden';
    actionInput.name = 'action';
    actionInput.value = 'submitQuiz';
    form.appendChild(actionInput);
    
    // Append form to body, submit it, and then remove it
    document.body.appendChild(form);
    form.submit();
    document.body.removeChild(form);
}

// Khởi tạo khi trang được tải
document.addEventListener("DOMContentLoaded", () => {
    // Khởi tạo mảng answeredQuestionsArray và lấy dữ liệu từ server
    initializeAnsweredQuestions()

    // Kiểm tra câu hỏi hiện tại có các tùy chọn được chọn không
    const currentQuestionNumber = Number.parseInt(document.getElementById("currentQuestionNumber").textContent)
    const form = document.getElementById("questionForm")
    const hasSelectedAnswers = form.querySelectorAll('input[type="checkbox"]:checked').length > 0

    // Cập nhật data attribute cho nút câu hỏi hiện tại
    const currentBtn = document.querySelector(".question-btn.current")
    if (currentBtn) {
        if (hasSelectedAnswers) {
            currentBtn.setAttribute("data-has-answers", "true")
        } else {
            currentBtn.setAttribute("data-has-answers", "false")
        }
    }

    // Thêm sự kiện change cho các checkbox
    const checkboxes = document.querySelectorAll('input[type="checkbox"]')
    checkboxes.forEach((checkbox) => {
        checkbox.addEventListener("change", () => {
            const currentQuestionNumber = Number.parseInt(document.getElementById("currentQuestionNumber").textContent)

            // Kiểm tra xem có ít nhất một checkbox được chọn không
            const form = document.getElementById("questionForm")
            const hasSelectedAnswers = form.querySelectorAll('input[type="checkbox"]:checked').length > 0

            // Chỉ đánh dấu là đã trả lời nếu có ít nhất một câu trả lời được chọn
            if (hasSelectedAnswers) {
                if (!window.answeredQuestionsArray.includes(currentQuestionNumber)) {
                    window.answeredQuestionsArray.push(currentQuestionNumber)
                }

                // Cập nhật data attribute cho nút câu hỏi hiện tại
                const currentBtn = document.querySelector(".question-btn.current")
                if (currentBtn) {
                    currentBtn.setAttribute("data-has-answers", "true")
                }
            } else {
                // Nếu không có câu trả lời nào được chọn, loại bỏ khỏi mảng câu hỏi đã trả lời
                const index = window.answeredQuestionsArray.indexOf(currentQuestionNumber)
                if (index !== -1) {
                    window.answeredQuestionsArray.splice(index, 1)
                }

                // Cập nhật data attribute cho nút câu hỏi hiện tại
                const currentBtn = document.querySelector(".question-btn.current")
                if (currentBtn) {
                    currentBtn.setAttribute("data-has-answers", "false")
                }
            }

            // Cập nhật UI cho các nút câu hỏi
            updateQuestionButtonsUI()

            console.log("Answered questions after checkbox change:", window.answeredQuestionsArray)
        })
    })

    // Thêm CSS cho trạng thái loading và câu hỏi hiện tại có câu trả lời
    const style = document.createElement("style")
    style.textContent = `
  .question-content.loading {
      position: relative;
  }
  .question-content.loading::after {
      content: "Loading...";
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      display: flex;
      align-items: center;
      justify-content: center;
      background-color: rgba(255, 255, 255, 0.8);
      font-weight: bold;
      font-size: 18px;
  }
  
  /* Thêm dấu hiệu cho câu hỏi hiện tại có câu trả lời */
  .question-btn.current[data-has-answers="true"] {
      border: 2px solid #10b981 !important; /* Màu xanh lá cây */
  }
  `
    document.head.appendChild(style)
})
