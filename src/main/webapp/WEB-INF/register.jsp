<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SarkarSathi - Register</title>
    <link rel="stylesheet" href="style/auth.css">
</head>
<body>
    <div class="auth-container">
        <!-- Left Panel -->
        <div class="auth-left">
            <h1>Join<br>SarkarSathi:<br>Empowering<br>Your Civic<br>Journey</h1>
            <p>A modern bridge between citizens and municipal excellence. Secure, fast, and accessible for everyone.</p>

            <div class="avatars-group">
                <div class="avatars">
                    <img src="images/avatar.png" alt="Citizen" class="avatar">
                    <img src="images/avatar.png" alt="Citizen" class="avatar">
                    <img src="images/avatar.png" alt="Citizen" class="avatar">
                </div>
                <span class="avatars-text">+10k Citizens Joined This Week</span>
            </div>
        </div>

        <!-- Right Panel -->
        <div class="auth-right">
            <div class="auth-form-wrapper register-form-wrapper">
                <div class="form-header">
                    <h2>Create Your Citizen Account</h2>
                    <p>Complete the form below to access municipal services.</p>
                </div>

                <div class="auth-card register-card">
                    <form action="${pageContext.request.contextPath}/api/auth/register/citizen" method="post">
                        <div class="form-group">
                            <label class="form-label">Full Name</label>
                            <div class="form-input-container">
                                <input type="text" name="fullName" class="form-input" placeholder="John Doe" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Email Address</label>
                            <div class="form-input-container">
                                <input type="email" name="email" class="form-input" placeholder="name@domain.com" required>
                                <svg class="input-icon-right" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                                </svg>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Phone Number</label>
                            <div class="form-input-container">
                                <input type="tel" name="phone" class="form-input" placeholder="+977-9800000000" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">Password</label>
                            <div class="form-input-container">
                                <input type="password" name="password" class="form-input" required>
                            </div>
                            <div class="form-hint">Must be at least 8 characters, with one uppercase and one symbol.</div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Date of Birth</label>
                                <div class="form-input-container">
                                    <input type="date" name="dateOfBirth" class="form-input" required>
                                </div>
                            </div>

                            <div class="form-group">
                                <label class="form-label">Gender</label>
                                <div class="toggle-group">
                                    <button type="button" class="toggle-btn active">Male</button>
                                    <button type="button" class="toggle-btn">Female</button>
                                    <button type="button" class="toggle-btn">Other</button>
                                    <!-- Hidden input for form submission -->
                                    <input type="hidden" name="gender" id="gender-input" value="Male">
                                </div>
                            </div>
                        </div>

                        <button type="submit" class="btn-primary">
                            Register
                        </button>
                    </form>

                    <div class="auth-footer" style="margin-top: 2rem;">
                        Already have an account? <a href="login.jsp" class="login-link">Login</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer class="page-footer light-footer">
        <div class="brand-name" style="font-size: 1.25rem; margin-bottom: 0;">SarkarSathi</div>
        <div class="footer-links">
            <a href="#">Privacy Policy</a>
            <a href="#">Terms of Service</a>
            <a href="#">Accessibility</a>
            <a href="#">Sitemap</a>
        </div>
        <div class="copyright">
            © 2024 SarkarSathi Municipal Services. All rights reserved.
        </div>
    </footer>

    <script>
        // Simple script to handle gender toggle buttons
        document.querySelectorAll('.toggle-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                // Remove active class from all
                document.querySelectorAll('.toggle-btn').forEach(b => b.classList.remove('active'));
                // Add to clicked
                this.classList.add('active');
                // Update hidden input
                document.getElementById('gender-input').value = this.innerText;
            });
        });
    </script>
</body>
</html>