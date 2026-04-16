package Model;

public class Ward {
    private int wardId;
    private int wardNumber;
    private String municipalityName;
    private String province;
    private String wardStampImage;

    public Ward() {
    }

    public Ward(int wardId, int wardNumber, String municipalityName, String province, String wardStampImage) {
        this.wardId = wardId;
        this.wardNumber = wardNumber;
        this.municipalityName = municipalityName;
        this.province = province;
        this.wardStampImage = wardStampImage;
    }

    public int getWardId() {
        return wardId;
    }

    public void setWardId(int wardId) {
        this.wardId = wardId;
    }

    public int getWardNumber() {
        return wardNumber;
    }

    public void setWardNumber(int wardNumber) {
        this.wardNumber = wardNumber;
    }

    public String getMunicipalityName() {
        return municipalityName;
    }

    public void setMunicipalityName(String municipalityName) {
        this.municipalityName = municipalityName;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public String getWardStampImage() {
        return wardStampImage;
    }

    public void setWardStampImage(String wardStampImage) {
        this.wardStampImage = wardStampImage;
    }
}