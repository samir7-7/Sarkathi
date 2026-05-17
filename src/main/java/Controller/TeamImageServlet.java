package Controller;

import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

/**
 * Serves team profile images from the webapp assets folder without relying on
 * container-specific static asset configuration.
 */
@WebServlet(name = "teamImageServlet", urlPatterns = "/assets/team/*")
public class TeamImageServlet extends HttpServlet {
    private static final Map<String, String> ALLOWED_IMAGES = Map.of(
            "prajwal-koirala.jpg", "image/jpeg",
            "minkumar-pandey.png", "image/png",
            "nabin-adhikari.png", "image/png",
            "rhythm-shrestha.png", "image/png",
            "samir-nepal.png", "image/png"
    );

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.isBlank() || "/".equals(pathInfo)) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String fileName = pathInfo.startsWith("/") ? pathInfo.substring(1) : pathInfo;
        String contentType = ALLOWED_IMAGES.get(fileName);
        if (contentType == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        try (InputStream stream = getServletContext().getResourceAsStream("/assets/team/" + fileName)) {
            if (stream == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }

            response.setContentType(contentType);
            response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);
            response.setHeader("X-Content-Type-Options", "nosniff");

            try (ServletOutputStream output = response.getOutputStream()) {
                stream.transferTo(output);
                output.flush();
            }
        }
    }
}
