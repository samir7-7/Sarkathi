package Model;

import java.security.Timestamp;

public class User {
    private int id;
    private String name;
    private String email;
    private String password;
    private String number;
    private final Timestamp DOB;
    private boolean isActive;
    private char gender;
    private List<Document> documents;
    private boolean isVerified;

    public User(String name, int id, String email, String password, String number, Timestamp DOB, boolean isActive, char gender, Document arrayList, boolean isVerified) {
        this.name = name;
        this.id = id;
        this.email = email;
        this.password = password;
        this.number = number;
        this.DOB = DOB;
        this.isActive = isActive;
        this.gender = gender;
        ArrayList = arrayList;
        this.isVerified = isVerified;
    }

    public User() {
    }

    public User(String name, String email, String password, String number, Timestamp DOB, boolean isActive, char gender, Document arrayList, boolean isVerified) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.number = number;
        this.DOB = DOB;
        this.isActive = isActive;
        this.gender = gender;
        ArrayList = arrayList;
        this.isVerified = isVerified;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getNumber() {
        return number;
    }

    public void setNumber(String number) {
        this.number = number;
    }

    public Timestamp getDOB() {
        return DOB;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public char getGender() {
        return gender;
    }

    public void setGender(char gender) {
        this.gender = gender;
    }

    public Document getArrayList() {
        return ArrayList;
    }

    public void setArrayList(Document arrayList) {
        ArrayList = arrayList;
    }

    public boolean isVerified() {
        return isVerified;
    }

    public void setVerified(boolean verified) {
        isVerified = verified;
    }
}
