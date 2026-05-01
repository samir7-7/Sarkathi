package Controller;

import DAO.impl.ApplicationDAO;
import DAO.impl.ApplicationDocumentDAO;
import DAO.impl.CitizenDAO;
import DAO.impl.CitizenDocumentVaultDAO;
import DAO.impl.ServiceTypeDAO;
import DAO.impl.WardDAO;
import Model.Application;
import Model.ApplicationDocument;
import Model.Citizen;
import Model.CitizenDocumentVault;
import Model.ServiceType;
import Model.Ward;
import Util.DatabaseConnection;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@WebServlet(name = "applicationServlet", urlPatterns = "/api/applications/*")
public class ApplicationServlet extends BaseApiServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String trackingId = request.getParameter("trackingId");
        String citizenIdParam = request.getParameter("citizenId");

        try (Connection connection = DatabaseConnection.getConnection()) {
            ApplicationDAO applicationDAO = new ApplicationDAO(connection);
            ApplicationDocumentDAO documentDAO = new ApplicationDocumentDAO(connection);
            CitizenDAO citizenDAO = new CitizenDAO(connection);
            ServiceTypeDAO serviceTypeDAO = new ServiceTypeDAO(connection);
            WardDAO wardDAO = new WardDAO(connection);

            Map<Integer, Citizen> citizens = mapCitizens(citizenDAO.findAll());
            Map<Integer, ServiceType> serviceTypes = mapServices(serviceTypeDAO.findAll(false));
            Map<Integer, Ward> wards = mapWards(wardDAO.findAll());

            if (trackingId != null && !trackingId.isBlank()) {
                Application application = applicationDAO.findByTrackingId(trackingId).orElse(null);
                if (application != null && isCitizen(request)) {
                    requireCitizenOwnership(request, application.getCitizenId());
                }
                writeJson(response, HttpServletResponse.SC_OK,
                        "{\"application\":" + (application == null ? "null"
                                : toApplicationJson(application, documentDAO, citizens, serviceTypes, wards)) + "}");
                return;
            }

            List<Application> applications;
            if (citizenIdParam != null && !citizenIdParam.isBlank()) {
                int citizenId = Integer.parseInt(citizenIdParam);
                requireCitizenOwnership(request, citizenId);
                applications = applicationDAO.findByCitizenId(citizenId);
            } else {
                requireAdmin(request);
                applications = applicationDAO.findAll();
            }

            writeJson(response, HttpServletResponse.SC_OK,
                    applicationsToJson(applications, documentDAO, citizens, serviceTypes, wards));
        } catch (IllegalArgumentException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        } catch (SecurityException e) {
            writeError(response, HttpServletResponse.SC_FORBIDDEN, e.getMessage());
        } catch (SQLException e) {
            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String redirectTo = getOptionalParameter(request, "redirectTo");
        try (Connection connection = DatabaseConnection.getConnection()) {
            int citizenId = Integer.parseInt(getRequiredParameter(request, "citizenId"));
            requireCitizenOwnership(request, citizenId);

            int serviceTypeId = Integer.parseInt(getRequiredParameter(request, "serviceTypeId"));
            int wardId = Integer.parseInt(getRequiredParameter(request, "wardId"));

            ServiceTypeDAO serviceTypeDAO = new ServiceTypeDAO(connection);
            WardDAO wardDAO = new WardDAO(connection);
            if (serviceTypeDAO.findAll(false).stream().noneMatch(service -> service.getServiceTypeId() == serviceTypeId && service.isActive())) {
                throw new IllegalArgumentException("Selected service type is not available");
            }
            if (wardDAO.findById(wardId).isEmpty()) {
                throw new IllegalArgumentException("Selected ward does not exist");
            }

            Application application = new Application();
            application.setTrackingId("UDAS-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            application.setCitizenId(citizenId);
            application.setServiceTypeId(serviceTypeId);
            application.setWardId(wardId);
            application.setStatus("submitted");
            application.setSubmittedAt(LocalDateTime.now());
            String formData = getOptionalParameter(request, "formData");
            if (formData != null && formData.length() > 8000) {
                throw new IllegalArgumentException("Application form data is too large");
            }
            application.setFormData(formData == null || formData.isBlank() ? "{}" : formData);
            application.setLastUpdatedAt(LocalDateTime.now());
            application.setRemarks(getOptionalParameter(request, "remarks"));
            application.setReviewedByAdminId(0);

            ApplicationDAO applicationDAO = new ApplicationDAO(connection);
            ApplicationDocumentDAO documentDAO = new ApplicationDocumentDAO(connection);
            CitizenDocumentVaultDAO vaultDAO = new CitizenDocumentVaultDAO(connection);
            CitizenDAO citizenDAO = new CitizenDAO(connection);

            Application savedApplication = applicationDAO.create(application);
            attachReusedDocuments(request, savedApplication, documentDAO, vaultDAO);

            Map<Integer, Citizen> citizens = mapCitizens(citizenDAO.findAll());
            Map<Integer, ServiceType> serviceTypes = mapServices(serviceTypeDAO.findAll(false));
            Map<Integer, Ward> wards = mapWards(wardDAO.findAll());

            redirectOrWriteJson(request, response, redirectTo, HttpServletResponse.SC_CREATED,
                    "{\"success\":true,\"application\":"
                            + toApplicationJson(savedApplication, documentDAO, citizens, serviceTypes, wards) + "}");
        } catch (IllegalArgumentException e) {
            redirectOrWriteError(request, response, redirectTo, e.getMessage(), HttpServletResponse.SC_BAD_REQUEST);
        } catch (SecurityException e) {
            redirectOrWriteError(request, response, redirectTo, e.getMessage(), HttpServletResponse.SC_FORBIDDEN);
        } catch (SQLException e) {
            redirectOrWriteError(request, response, redirectTo, e.getMessage(), HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private void redirectOrWriteJson(HttpServletRequest request, HttpServletResponse response, String redirectTo,
                                     int statusCode, String json) throws IOException {
        if (redirectTo != null && !redirectTo.isBlank()) {
            response.sendRedirect(formRedirectUrl(request, redirectTo, null));
            return;
        }
        writeJson(response, statusCode, json);
    }

    private void redirectOrWriteError(HttpServletRequest request, HttpServletResponse response, String redirectTo,
                                      String message, int statusCode) throws IOException {
        if (redirectTo != null && !redirectTo.isBlank()) {
            response.sendRedirect(formRedirectUrl(request, redirectTo, message));
            return;
        }
        writeError(response, statusCode, message);
    }

    private String formRedirectUrl(HttpServletRequest request, String redirectTo, String error) {
        String target = redirectTo.startsWith("/") && !redirectTo.startsWith("//") ? redirectTo : "/citizen/tracking";
        String url = request.getContextPath() + target;
        if (error == null || error.isBlank()) {
            return url;
        }
        return url + "?error=" + URLEncoder.encode(error, StandardCharsets.UTF_8);
    }

    private void attachReusedDocuments(HttpServletRequest request, Application application,
                                       ApplicationDocumentDAO documentDAO,
                                       CitizenDocumentVaultDAO vaultDAO) throws SQLException {
        List<Integer> reuseIds = parseReuseDocumentIds(request);
        if (reuseIds.isEmpty()) {
            return;
        }

        List<CitizenDocumentVault> vaultDocuments = vaultDAO.findByCitizenIdAndIds(application.getCitizenId(), reuseIds);
        for (CitizenDocumentVault vaultDocument : vaultDocuments) {
            ApplicationDocument applicationDocument = new ApplicationDocument();
            applicationDocument.setApplicationId(application.getApplicationId());
            applicationDocument.setDocumentType(vaultDocument.getDocumentType());
            applicationDocument.setFilePath(vaultDocument.getFilePath());
            applicationDocument.setUploadedAt(LocalDateTime.now());
            applicationDocument.setReusable(true);
            documentDAO.create(applicationDocument);
        }
    }

    private List<Integer> parseReuseDocumentIds(HttpServletRequest request) {
        List<Integer> ids = new ArrayList<>();
        String[] values = request.getParameterValues("reuseDocumentIds");
        if (values != null) {
            for (String value : values) {
                ids.addAll(parseCsvIds(value));
            }
            return ids;
        }
        return parseCsvIds(getOptionalParameter(request, "reuseDocumentIds"));
    }

    private List<Integer> parseCsvIds(String csv) {
        List<Integer> ids = new ArrayList<>();
        if (csv == null || csv.isBlank()) {
            return ids;
        }

        for (String token : csv.split(",")) {
            String trimmed = token.trim();
            if (!trimmed.isEmpty()) {
                ids.add(Integer.parseInt(trimmed));
            }
        }
        return ids;
    }

    private String applicationsToJson(List<Application> applications, ApplicationDocumentDAO documentDAO,
                                      Map<Integer, Citizen> citizens, Map<Integer, ServiceType> serviceTypes,
                                      Map<Integer, Ward> wards) throws SQLException {
        List<String> items = new ArrayList<>();
        for (Application application : applications) {
            items.add(toApplicationJson(application, documentDAO, citizens, serviceTypes, wards));
        }
        return jsonArray(items);
    }

    private String toApplicationJson(Application application, ApplicationDocumentDAO documentDAO,
                                     Map<Integer, Citizen> citizens, Map<Integer, ServiceType> serviceTypes,
                                     Map<Integer, Ward> wards) throws SQLException {
        Citizen citizen = citizens.get(application.getCitizenId());
        ServiceType serviceType = serviceTypes.get(application.getServiceTypeId());
        Ward ward = wards.get(application.getWardId());
        List<ApplicationDocument> documents = documentDAO.findByApplicationId(application.getApplicationId());

        String wardLabel = ward == null
                ? null
                : "Ward " + ward.getWardNumber() + (ward.getMunicipalityName() == null ? "" : " - " + ward.getMunicipalityName());

        return "{"
                + "\"applicationId\":" + application.getApplicationId() + ","
                + "\"trackingId\":" + quote(application.getTrackingId()) + ","
                + "\"citizenId\":" + application.getCitizenId() + ","
                + "\"citizenName\":" + quote(citizen == null ? null : citizen.getFullName()) + ","
                + "\"citizenEmail\":" + quote(citizen == null ? null : citizen.getEmail()) + ","
                + "\"serviceTypeId\":" + application.getServiceTypeId() + ","
                + "\"serviceName\":" + quote(serviceType == null ? null : serviceType.getServiceName()) + ","
                + "\"serviceDescription\":" + quote(serviceType == null ? null : serviceType.getDescription()) + ","
                + "\"wardId\":" + application.getWardId() + ","
                + "\"wardNumber\":" + (ward == null ? "null" : ward.getWardNumber()) + ","
                + "\"wardLabel\":" + quote(wardLabel) + ","
                + "\"municipalityName\":" + quote(ward == null ? null : ward.getMunicipalityName()) + ","
                + "\"wardStampImage\":" + quote(ward == null ? null : ward.getWardStampImage()) + ","
                + "\"status\":" + quote(application.getStatus()) + ","
                + "\"submittedAt\":" + quote(application.getSubmittedAt() == null ? null : application.getSubmittedAt().toString()) + ","
                + "\"formData\":" + quote(application.getFormData()) + ","
                + "\"lastUpdatedAt\":" + quote(application.getLastUpdatedAt() == null ? null : application.getLastUpdatedAt().toString()) + ","
                + "\"remarks\":" + quote(application.getRemarks()) + ","
                + "\"reviewedByAdminId\":" + application.getReviewedByAdminId() + ","
                + "\"documents\":" + documentsToJson(documents)
                + "}";
    }

    private String documentsToJson(List<ApplicationDocument> documents) {
        List<String> items = new ArrayList<>();
        for (ApplicationDocument document : documents) {
            items.add("{"
                    + "\"docId\":" + document.getDocId() + ","
                    + "\"applicationId\":" + document.getApplicationId() + ","
                    + "\"documentType\":" + quote(document.getDocumentType()) + ","
                    + "\"filePath\":" + quote(document.getFilePath()) + ","
                    + "\"uploadedAt\":" + quote(document.getUploadedAt() == null ? null : document.getUploadedAt().toString()) + ","
                    + "\"reusable\":" + document.isReusable()
                    + "}");
        }
        return jsonArray(items);
    }

    private Map<Integer, Citizen> mapCitizens(List<Citizen> citizens) {
        Map<Integer, Citizen> map = new HashMap<>();
        for (Citizen citizen : citizens) {
            map.put(citizen.getCitizenId(), citizen);
        }
        return map;
    }

    private Map<Integer, ServiceType> mapServices(List<ServiceType> services) {
        Map<Integer, ServiceType> map = new LinkedHashMap<>();
        for (ServiceType serviceType : services) {
            map.put(serviceType.getServiceTypeId(), serviceType);
        }
        return map;
    }

    private Map<Integer, Ward> mapWards(List<Ward> wards) {
        Map<Integer, Ward> map = new LinkedHashMap<>();
        for (Ward ward : wards) {
            map.put(ward.getWardId(), ward);
        }
        return map;
    }
}
