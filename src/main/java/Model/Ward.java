package Model;

/**
 * A municipal ward — the geographic unit applications are routed to.
 * <p>
 * Every {@link AdminUser} is assigned to a ward, and every
 * {@link Application} is processed by the ward it was filed in. The
 * {@link #wardStampImage} field stores the path to the official stamp image
 * that gets stamped onto generated certificates.
 *
 * @author SarkarSathi
 */
public class Ward {
    private int wardId;
    private int wardNumber;
    private String municipalityName;
    private String province;
    private String wardStampImage;

    /**
     * Creates an empty ward.
     */
    public Ward() {
    }

    /**
     * Creates a fully-populated ward.
     *
     * @param wardId           database primary key
     * @param wardNumber       the ward's number within its municipality
     * @param municipalityName name of the parent municipality
     * @param province         province this ward sits in
     * @param wardStampImage   path to the official stamp image used on certificates
     */
    public Ward(int wardId, int wardNumber, String municipalityName, String province, String wardStampImage) {
        this.wardId = wardId;
        this.wardNumber = wardNumber;
        this.municipalityName = municipalityName;
        this.province = province;
        this.wardStampImage = wardStampImage;
    }

    /** @return the ward's database id */
    public int getWardId() {
        return wardId;
    }

    /** @param wardId new database id */
    public void setWardId(int wardId) {
        this.wardId = wardId;
    }

    /** @return the ward's number within its municipality */
    public int getWardNumber() {
        return wardNumber;
    }

    /** @param wardNumber ward number within the municipality */
    public void setWardNumber(int wardNumber) {
        this.wardNumber = wardNumber;
    }

    /** @return name of the parent municipality */
    public String getMunicipalityName() {
        return municipalityName;
    }

    /** @param municipalityName name of the parent municipality */
    public void setMunicipalityName(String municipalityName) {
        this.municipalityName = municipalityName;
    }

    /** @return province this ward belongs to */
    public String getProvince() {
        return province;
    }

    /** @param province province this ward belongs to */
    public void setProvince(String province) {
        this.province = province;
    }

    /** @return path to the official ward stamp image */
    public String getWardStampImage() {
        return wardStampImage;
    }

    /** @param wardStampImage path to the official ward stamp image */
    public void setWardStampImage(String wardStampImage) {
        this.wardStampImage = wardStampImage;
    }
}
