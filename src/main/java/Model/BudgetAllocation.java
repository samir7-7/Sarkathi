package Model;

import java.math.BigDecimal;

/**
 * A budget line item — how much money a particular ward is allocating to a
 * particular department for a particular fiscal year.
 * <p>
 * Used by the public budget transparency page so citizens can see where the
 * money is going. Admins create and edit these from the admin budgets page.
 *
 * @author SarkarSathi
 */
public class BudgetAllocation {
    private int budgetId;
    private int wardId;
    private String department;
    private BigDecimal allocatedAmount;
    private String fiscalYear;
    private String description;

    /**
     * Creates an empty budget allocation.
     */
    public BudgetAllocation() {
    }

    /**
     * Creates a fully-populated budget allocation.
     *
     * @param budgetId         database primary key
     * @param wardId           ward this allocation belongs to
     * @param department       department receiving the allocation (e.g.
     *                         {@code "Sanitation"}, {@code "Education"})
     * @param allocatedAmount  amount in the local currency
     * @param fiscalYear       fiscal year string (e.g. {@code "2081/82"})
     * @param description      human-readable description of what the money is for
     */
    public BudgetAllocation(int budgetId, int wardId, String department,
                            BigDecimal allocatedAmount, String fiscalYear, String description) {
        this.budgetId = budgetId;
        this.wardId = wardId;
        this.department = department;
        this.allocatedAmount = allocatedAmount;
        this.fiscalYear = fiscalYear;
        this.description = description;
    }

    /** @return the allocation's database id */
    public int getBudgetId() {
        return budgetId;
    }

    /** @param budgetId new database id */
    public void setBudgetId(int budgetId) {
        this.budgetId = budgetId;
    }

    /** @return id of the ward this allocation belongs to */
    public int getWardId() {
        return wardId;
    }

    /** @param wardId ward this allocation belongs to */
    public void setWardId(int wardId) {
        this.wardId = wardId;
    }

    /** @return name of the department receiving the allocation */
    public String getDepartment() {
        return department;
    }

    /** @param department department name */
    public void setDepartment(String department) {
        this.department = department;
    }

    /** @return allocated amount in the local currency */
    public BigDecimal getAllocatedAmount() {
        return allocatedAmount;
    }

    /** @param allocatedAmount allocated amount */
    public void setAllocatedAmount(BigDecimal allocatedAmount) {
        this.allocatedAmount = allocatedAmount;
    }

    /** @return fiscal year string */
    public String getFiscalYear() {
        return fiscalYear;
    }

    /** @param fiscalYear fiscal year string (e.g. {@code "2081/82"}) */
    public void setFiscalYear(String fiscalYear) {
        this.fiscalYear = fiscalYear;
    }

    /** @return human-readable description of the allocation */
    public String getDescription() {
        return description;
    }

    /** @param description human-readable description */
    public void setDescription(String description) {
        this.description = description;
    }
}
