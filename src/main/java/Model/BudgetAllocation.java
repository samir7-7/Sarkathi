package Model;

import java.math.BigDecimal;

public class BudgetAllocation {
    private int budgetId;
    private int wardId;
    private String department;
    private BigDecimal allocatedAmount;
    private String fiscalYear;
    private String description;

    public BudgetAllocation() {
    }

    public BudgetAllocation(int budgetId, int wardId, String department,
                            BigDecimal allocatedAmount, String fiscalYear, String description) {
        this.budgetId = budgetId;
        this.wardId = wardId;
        this.department = department;
        this.allocatedAmount = allocatedAmount;
        this.fiscalYear = fiscalYear;
        this.description = description;
    }

    public int getBudgetId() {
        return budgetId;
    }

    public void setBudgetId(int budgetId) {
        this.budgetId = budgetId;
    }

    public int getWardId() {
        return wardId;
    }

    public void setWardId(int wardId) {
        this.wardId = wardId;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public BigDecimal getAllocatedAmount() {
        return allocatedAmount;
    }

    public void setAllocatedAmount(BigDecimal allocatedAmount) {
        this.allocatedAmount = allocatedAmount;
    }

    public String getFiscalYear() {
        return fiscalYear;
    }

    public void setFiscalYear(String fiscalYear) {
        this.fiscalYear = fiscalYear;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}