package Util;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.sql.SQLException;

@WebListener
public class AdminSeedStartupListener implements ServletContextListener {

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
