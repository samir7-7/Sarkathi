<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SarkarSathi - Governance for a Better Tomorrow</title>
    <link rel="stylesheet" href="css/style.css">
    <script src="https://unpkg.com/lucide@latest"></script>
</head>
<body>

    <!-- Navbar -->
    <header class="container">
        <nav class="navbar">
            <a href="index.jsp" class="logo">Sarkar<span>Sathi</span></a>
            <div class="nav-links">
                <a href="#">Services</a>
                <a href="#">About Us</a>
                <a href="#">Announcements</a>
                <a href="#">Agriculture</a>
            </div>
            <div class="nav-actions">
                <a href="login.jsp" class="login-link">Login</a>
                <a href="register.jsp" class="btn-primary">Register</a>
            </div>
        </nav>
    </header>

    <main>
        <!-- Hero Section -->
        <section class="container hero">
            <div class="hero-content">
                <div class="badge">
                    <div class="badge-dot"></div>
                    Official Portal of Nepal Municipality
                </div>
                <h1>Governance for a <br><i>Better Tomorrow.</i></h1>
                <p>Experience a seamless bridge between citizens and administration. Access public services, track progress, and contribute to your community's growth effortlessly.</p>
                <div class="hero-actions">
                    <a href="register.jsp" class="btn-primary">Get Started <i data-lucide="arrow-right" style="width: 18px; height: 18px;"></i></a>
                    <a href="#" class="btn-outline">Explore Services</a>
                </div>
            </div>
            <div class="hero-image">
                <img src="https://images.unsplash.com/photo-1544735716-392fe2489ffa?q=80&w=800&auto=format&fit=crop" alt="Himalayas">
                <div class="glass-card">
                    <div class="glass-icon">
                        <i data-lucide="shield-check"></i>
                    </div>
                    <div class="glass-text">
                        <h4>99.9% Transparent</h4>
                        <p>Blockchain-verified records ensure complete administrative honesty.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Announcement Banner -->
        <div class="container">
            <div class="announcement">
                <div class="announcement-content">
                    <span class="tag">LATEST</span>
                    <p>Land ownership re-verification starts from next Sunday. Please bring original deeds.</p>
                </div>
                <a href="#" class="view-all">View All Announcements <i data-lucide="chevron-right" style="width: 16px; height: 16px;"></i></a>
            </div>
        </div>

        <!-- Steps Section -->
        <section class="container steps-section">
            <h2 class="section-title">Empowerment in 3 Steps</h2>
            <p class="section-subtitle">Digitizing your civic duties should be effortless and natural.</p>
            
            <div class="steps-grid">
                <div class="step-card">
                    <div class="step-icon">
                        <i data-lucide="user-plus"></i>
                    </div>
                    <h3>Create Profile</h3>
                    <p>Register with your citizenship ID to access a personalized civic dashboard.</p>
                </div>
                <div class="step-card">
                    <div class="step-icon">
                        <i data-lucide="pointer"></i>
                    </div>
                    <h3>Select Service</h3>
                    <p>Browse through tax payments, registrations, or building permits effortlessly.</p>
                </div>
                <div class="step-card">
                    <div class="step-icon">
                        <i data-lucide="check-circle"></i>
                    </div>
                    <h3>Get Results</h3>
                    <p>Track your applications in real-time and download certified documents digitally.</p>
                </div>
            </div>
        </section>

        <!-- Services Ecosystem -->
        <section class="container services-section">
            <div class="services-header">
                <div>
                    <h2 class="section-title">Service Ecosystem</h2>
                    <p class="section-subtitle" style="margin-bottom: 0;">Integrated solutions designed for your everyday civic needs.</p>
                </div>
                <a href="#" class="view-all">Explore Full Directory</a>
            </div>

            <div class="services-grid">
                <div class="service-card">
                    <div class="service-icon">
                        <i data-lucide="home"></i>
                    </div>
                    <h3>Property Tax</h3>
                    <p>Calculate, file, and pay your municipal property taxes securely online. View your payment history and download receipts.</p>
                    <a href="#" class="service-link">Pay Now <i data-lucide="arrow-right" style="width: 16px; height: 16px;"></i></a>
                </div>
                <div class="service-card primary-card">
                    <div class="service-icon" style="display: flex; justify-content: space-between; align-items: center; width: 100%; background: transparent;">
                        <div style="width: 60px; height: 60px; background-color: rgba(255,255,255,0.1); border-radius: 12px; display: flex; align-items: center; justify-content: center;">
                            <i data-lucide="file-text"></i>
                        </div>
                        <span style="background: rgba(34, 197, 94, 0.2); color: #4ade80; padding: 4px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: 600;">ESSENTIAL</span>
                    </div>
                    <h3 style="margin-top: 1rem;">Vital Registration</h3>
                    <p>Register births, deaths, marriages, and other vital events. Request certified copies of certificates digitally.</p>
                    <a href="#" class="service-link">Register Event <i data-lucide="arrow-right" style="width: 16px; height: 16px;"></i></a>
                </div>
                <div class="service-card">
                    <div class="service-icon">
                        <i data-lucide="hard-hat"></i>
                    </div>
                    <h3>Building Permits</h3>
                    <p>Submit building plans, track approval status, and request inspections through our streamlined permit portal.</p>
                    <a href="#" class="service-link">Apply for Permit <i data-lucide="arrow-right" style="width: 16px; height: 16px;"></i></a>
                </div>
            </div>
        </section>
    </main>

    <!-- Footer -->
    <footer>
        <div class="container footer-grid">
            <div>
                <a href="#" class="footer-logo">Sarkar<span>Sathi</span></a>
                <p class="footer-desc">Building the foundation of digital Nepal through transparent and accessible civic engagement.</p>
                <div class="social-links">
                    <a href="#" class="social-btn"><i data-lucide="share-2" style="width: 18px; height: 18px;"></i></a>
                    <a href="#" class="social-btn"><i data-lucide="mail" style="width: 18px; height: 18px;"></i></a>
                </div>
            </div>
            <div class="footer-col">
                <h4>Legal</h4>
                <ul>
                    <li><a href="#">Privacy Policy</a></li>
                    <li><a href="#">Terms of Service</a></li>
                    <li><a href="#">Accessibility</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Support</h4>
                <ul>
                    <li><a href="#">Grievance Redressal</a></li>
                    <li><a href="#">Directory</a></li>
                    <li><a href="#">Citizen Charter</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Connect</h4>
                <ul>
                    <li><p>Central Ward Office,</p></li>
                    <li><p>Kathmandu, Nepal</p></li>
                    <li><a href="tel:+97714200000" style="color: var(--primary); font-weight: 600;">+977 1 4200000</a></li>
                </ul>
            </div>
        </div>
        <div class="container footer-bottom">
            <p>&copy; 2024 SarkarSathi Municipal Council. All Rights Reserved.</p>
            <p>Version 2.4.0 (Lumbini)</p>
        </div>
    </footer>

    <script>
        lucide.createIcons();
    </script>
</body>
</html>
