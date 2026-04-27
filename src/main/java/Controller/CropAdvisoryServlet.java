package Controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;

@WebServlet(name = "cropAdvisoryServlet", urlPatterns = "/api/crop-advisory")
public class CropAdvisoryServlet extends BaseApiServlet {

    private static final Map<String, Map<String, List<String[]>>> RECOMMENDATIONS = new LinkedHashMap<>();

    static {
        // Format: {name, description, growingPeriod}
        Map<String, List<String[]>> flatland = new LinkedHashMap<>();
        flatland.put("spring", List.of(
            new String[]{"Rice (Paddy)", "Main staple crop, transplant in monsoon-ready fields", "120-150 days"},
            new String[]{"Maize", "Versatile cereal for food and fodder", "90-120 days"},
            new String[]{"Jute", "Cash crop for fiber production", "100-120 days"}
        ));
        flatland.put("summer", List.of(
            new String[]{"Rice (Paddy)", "Peak season for lowland rice cultivation", "120-150 days"},
            new String[]{"Sugarcane", "Long-duration cash crop", "270-365 days"},
            new String[]{"Vegetables (Cucumber, Bottle Gourd)", "Quick income from vegetable farming", "60-90 days"}
        ));
        flatland.put("autumn", List.of(
            new String[]{"Wheat", "Winter cereal, sow after rice harvest", "120-150 days"},
            new String[]{"Mustard", "Oilseed crop for winter season", "90-120 days"},
            new String[]{"Lentil (Masoor)", "Protein-rich pulse crop", "100-120 days"}
        ));
        flatland.put("winter", List.of(
            new String[]{"Wheat", "Continue winter wheat cultivation", "120-150 days"},
            new String[]{"Potato", "High-value root vegetable", "90-120 days"},
            new String[]{"Pea", "Cool-season legume", "60-90 days"}
        ));
        RECOMMENDATIONS.put("flatland", flatland);

        Map<String, List<String[]>> hilly = new LinkedHashMap<>();
        hilly.put("spring", List.of(
            new String[]{"Maize", "Primary cereal for hill regions", "90-120 days"},
            new String[]{"Millet (Kodo/Kaguno)", "Drought-tolerant grain", "90-120 days"},
            new String[]{"Ginger", "High-value spice crop", "240-270 days"}
        ));
        hilly.put("summer", List.of(
            new String[]{"Rice (Upland)", "Direct-seeded rice on terraces", "120-150 days"},
            new String[]{"Cardamom", "Cash crop under shade trees", "Perennial"},
            new String[]{"Turmeric", "Spice and medicinal crop", "210-270 days"}
        ));
        hilly.put("autumn", List.of(
            new String[]{"Wheat", "Winter cereal for mid-hills", "120-150 days"},
            new String[]{"Barley", "Hardy cereal for higher elevations", "100-120 days"},
            new String[]{"Rapeseed", "Oilseed for cool-season", "90-120 days"}
        ));
        hilly.put("winter", List.of(
            new String[]{"Potato", "Cool-climate root crop", "90-120 days"},
            new String[]{"Cabbage", "Cold-hardy vegetable", "80-100 days"},
            new String[]{"Garlic", "High-value allium crop", "120-150 days"}
        ));
        RECOMMENDATIONS.put("hilly", hilly);

        Map<String, List<String[]>> mountain = new LinkedHashMap<>();
        mountain.put("spring", List.of(
            new String[]{"Buckwheat", "Short-season grain for high altitude", "60-90 days"},
            new String[]{"Barley", "Cold-tolerant cereal", "100-120 days"},
            new String[]{"Apple", "Temperate fruit for mountains", "Perennial"}
        ));
        mountain.put("summer", List.of(
            new String[]{"Potato", "High-altitude potato cultivation", "90-120 days"},
            new String[]{"Amaranth", "Nutritious pseudo-cereal", "60-90 days"},
            new String[]{"Beans", "Nitrogen-fixing legume", "60-90 days"}
        ));
        mountain.put("autumn", List.of(
            new String[]{"Buckwheat", "Second season buckwheat", "60-90 days"},
            new String[]{"Radish", "Quick-growing root vegetable", "40-60 days"},
            new String[]{"Turnip", "Cold-hardy root crop", "40-60 days"}
        ));
        mountain.put("winter", List.of(
            new String[]{"Limited Options", "Most mountain areas under snow cover", "N/A"},
            new String[]{"Greenhouse Vegetables", "Tomato, capsicum under protection", "60-90 days"},
            new String[]{"Mushroom", "Indoor cultivation possible year-round", "30-60 days"}
        ));
        RECOMMENDATIONS.put("mountain", mountain);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String landType = request.getParameter("landType");
        String season = request.getParameter("season");

        if (landType == null || season == null || landType.isBlank() || season.isBlank()) {
            // Return available options
            writeJson(response, HttpServletResponse.SC_OK,
                "{\"landTypes\":[\"flatland\",\"hilly\",\"mountain\"],\"seasons\":[\"spring\",\"summer\",\"autumn\",\"winter\"]}");
            return;
        }

        landType = landType.toLowerCase().trim();
        season = season.toLowerCase().trim();

        Map<String, List<String[]>> landData = RECOMMENDATIONS.get(landType);
        if (landData == null) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid land type. Use: flatland, hilly, mountain");
            return;
        }

        List<String[]> crops = landData.get(season);
        if (crops == null) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid season. Use: spring, summer, autumn, winter");
            return;
        }

        List<String> items = new ArrayList<>();
        for (String[] crop : crops) {
            items.add("{\"name\":" + quote(crop[0]) + ",\"description\":" + quote(crop[1]) + ",\"growingPeriod\":" + quote(crop[2]) + "}");
        }

        writeJson(response, HttpServletResponse.SC_OK,
            "{\"landType\":" + quote(landType) + ",\"season\":" + quote(season) + ",\"recommendations\":" + jsonArray(items) + "}");
    }
}
