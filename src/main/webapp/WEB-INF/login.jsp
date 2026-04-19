<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SarkarSathi - Login</title>
    <link rel="stylesheet" href="css/auth.css">
</head>
<body>
    <div class="auth-container">
        <!-- Left Panel -->
        <div class="auth-left">
            <h1>Empowering<br>Citizens, Building<br>Cities.</h1>
            <p>Connecting you to municipal excellence through a unified digital gateway. Experience governance that works for you.</p>
            <div class="btn-official">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                    <polyline points="22 4 12 14.01 9 11.01"></polyline>
                </svg>
                OFFICIAL PORTAL
            </div>
        </div>

        <!-- Right Panel -->
        <div class="auth-right">
            <div class="auth-form-wrapper">
                <div class="logo-container">
                    <div class="logo-icon">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M3 21h18"></path>
                            <path d="M5 21v-4"></path>
                            <path d="M19 21v-4"></path>
                            <path d="M7 17v-4"></path>
                            <path d="M17 17v-4"></path>
                            <path d="M12 17v-4"></path>
                            <path d="M3 13L12 4l9 9"></path>
                        </svg>
                    </div>
                    <div class="brand-name">SarkarSathi</div>
                    <p style="color: #475569; font-size: 0.875rem;">Access your municipal services with ease. Please login to your account.</p>
                </div>

                <div class="auth-card">
                    <form action="${pageContext.request.contextPath}/api/auth/login" method="post">
                        <div class="form-group">
                            <label class="form-label">EMAIL ADDRESS</label>
                            <div class="form-input-container">
                                <input type="email" name="email" class="form-input" placeholder="name@example.com" required>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="form-label">
                                <span>PASSWORD</span>
                                <a href="#">Forgot Password?</a>
                            </div>
                            <div class="form-input-container">
                                <input type="password" name="password" class="form-input" placeholder="••••••••" required>
                            </div>
                        </div>

                        <button type="submit" class="btn-primary">
                            Login to Dashboard
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <line x1="5" y1="12" x2="19" y2="12"></line>
                                <polyline points="12 5 19 12 12 19"></polyline>
                            </svg>
                        </button>
                    </form>

                    <div class="auth-footer">
                        Don't have an account? <a href="register.jsp">Register as a Citizen</a>
                    </div>
                </div>

                <div class="secure-badge">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
                    </svg>
                    SECURE GOVERNMENT PORTAL • DATA ENCRYPTED
                </div>
            </div>
        </div>
    </div>

    <footer class="page-footer">
        <div class="copyright">
            © 2024 SarkarSathi Municipal Governance Portal. All rights reserved.
        </div>
        <div class="footer-links">
            <a href="#">Privacy Policy</a>
            <a href="#">Terms of Service</a>
            <a href="#">Help Desk</a>
            <a href="#">Contact Us</a>
        </div>
    </footer>
</body>
</html>