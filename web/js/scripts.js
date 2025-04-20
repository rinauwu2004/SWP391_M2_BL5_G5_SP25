/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


document.addEventListener("DOMContentLoaded", () => {
    // Mobile menu toggle
    const mobileMenuButton = document.createElement("button");
    mobileMenuButton.classList.add("mobile-menu-button");
    mobileMenuButton.innerHTML = '<i class="fas fa-bars"></i>';

    const navbar = document.querySelector(".navbar");
    const nav = document.querySelector("nav");

    if (window.innerWidth <= 768) {
        navbar.insertBefore(mobileMenuButton, nav);

        mobileMenuButton.addEventListener("click", () => {
            nav.classList.toggle("active");
        });
    }

    // Smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
        anchor.addEventListener("click", function (e) {
            e.preventDefault();

            const targetId = this.getAttribute("href");
            if (targetId === "#")
                return;

            const targetElement = document.querySelector(targetId);
            if (targetElement) {
                window.scrollTo({
                    top: targetElement.offsetTop - 80,
                    behavior: "smooth"
                });
            }
        });
    });

    // Add active class to current page in navigation
    const currentPage = window.location.pathname.split("/").pop();
    const navLinks = document.querySelectorAll("nav ul li a");

    navLinks.forEach((link) => {
        const linkPage = link.getAttribute("href");
        if (linkPage === currentPage || (currentPage === "" && linkPage === "Homepage.jsp")) {
            link.classList.add("active");
        }
    });
});