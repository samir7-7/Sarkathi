package Util;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.sql.SQLException;

/**
 * Servlet context listener that runs the admin seeder once on application
 * startup, but only if no admin accounts exist yet.
 * <p>
 * That guard means a freshly-installed instance gets a usable set of admin
 * logins out of the box, while existing instances with custom admins are
 * left alone. Failures are logged to the servlet context but never
 * rethrown — we don't want a seed problem to take down the whole webapp.
 *
 * @author SarkarSathi
 */
@WebListener
public class AdminSeedStartupListener implements ServletContextListener {

    /**
     * Called by the servlet container right after the context is created.
     * Delegates to {@link AdminSeeder#seedAdminsIfMissing()} and logs the
     * outcome.
     *
     * @param sce the startup event from the container
     */
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();

        try {
            boolean seeded = AdminSeeder.seedAdminsIfMissing();
            if (seeded) {
                context.log("Seeded default admin accounts during application startup.");
            } else {
                context.log("Admin seed skipped during startup because admin accounts already exist.");
            }
        } catch (SQLException e) {
            context.log("Failed to seed default admin accounts during startup.", e);
        }
    }
}
