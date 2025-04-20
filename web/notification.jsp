<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${not empty requestScope.message or not empty requestScope.error}">
    <div id="popupMessage" class="position-fixed" 
         style="top: 20px; right: 20px; max-width: 350px; background-color: ${not empty requestScope.message ? '#28a745' : '#dc3545'};
         color: white; padding: 15px; border-radius: 10px; box-shadow: 0px 4px 6px rgba(0,0,0,0.1); display: none; opacity: 0; transition: opacity 0.5s ease-in-out;">
        <c:choose>
            <c:when test="${not empty requestScope.message}">✅ ${requestScope.message}</c:when>
            <c:when test="${not empty requestScope.error}">❌ ${requestScope.error}</c:when>
        </c:choose>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            let popup = document.getElementById("popupMessage");
            if (popup) {
                popup.style.display = "block"; // Show the popup
                popup.style.opacity = "1"; // Fade in the popup

                setTimeout(() => {
                    popup.style.opacity = "0"; // Fade out the popup
                    setTimeout(() => popup.style.display = "none", 500); // Hide the popup after fade-out
                }, 5000); // Wait for 5 seconds before fading out
            }
        });
    </script>
</c:if>

<c:if test="${not empty sessionScope.message or not empty sessionScope.error}">
    <div id="popupMessage1" class="position-fixed" 
         style="top: 20px; right: 20px; max-width: 350px; background-color: ${not empty sessionScope.message ? '#28a745' : '#dc3545'};
         color: white; padding: 15px; border-radius: 10px; box-shadow: 0px 4px 6px rgba(0,0,0,0.1); display: none; opacity: 0; transition: opacity 0.5s ease-in-out;">
        <c:choose>
            <c:when test="${not empty sessionScope.message}">✅ ${sessionScope.message}</c:when>
            <c:when test="${not empty sessionScope.error}">❌ ${sessionScope.error}</c:when>
        </c:choose>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            let popup = document.getElementById("popupMessage1");
            if (popup) {
                popup.style.display = "block"; // Show the popup
                popup.style.opacity = "1"; // Fade in the popup

                setTimeout(() => {
                    popup.style.opacity = "0";
                    setTimeout(() => popup.style.display = "none", 500); 
                }, 5000); 
            }
        });
    </script>
</c:if>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        let popup = document.getElementById("popupMessage1");
        if (popup) {
            popup.style.display = "block";
            popup.style.opacity = "1";

            setTimeout(() => {
                popup.style.opacity = "0";
                setTimeout(() => {
                    popup.style.display = "none";

                    fetch('remove-message', {
                        method: 'POST'
                    });

                }, 500); 
            }, 5000); 
        }
    });
</script>
