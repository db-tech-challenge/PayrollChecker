package com.payroll;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import com.payroll.model.Calendar;
import com.payroll.model.Overtime;
import com.payroll.model.Payment;
import com.payroll.model.PaymentResult;
import com.payroll.model.TaxClass;
import com.payroll.service.impl.BasePayServiceIml;
import com.payroll.service.impl.FileServiceImpl;
import com.payroll.util.DefaultFileReader;
import com.payroll.util.SimpleCsvParser;
import java.time.DayOfWeek;
import java.util.Arrays;
import java.util.List;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

class PayrollApplicationTest {
    static List<PaymentResult> results;
    static List<Overtime> overtimes;
    static List<Payment> payments;

    @BeforeAll
    static void setUp() {
        SimpleCsvParser parser = new SimpleCsvParser(new DefaultFileReader());
        FileServiceImpl fileService = new FileServiceImpl("data", parser);
        results = fileService.loadResult();
        overtimes = fileService.loadOvertimes();
        payments = fileService.loadPayments();
    }

    @Test
    void test_01_01() {
        existOne("24778715");
    }

    @Test
    void test_02_01() {
        existOne("98198992");
    }

    @Test
    void test_03_01() {
        Assertions.fail();
    }

    @Test
    public void test_04_01() {
        TaxClass taxClass = new TaxClass("4", 0.1);
        double result = new BasePayServiceIml().getTaxFactor(taxClass);
        assertEquals(0.9, result, 0.001);
    }
    @Test
    public void test_04_02() {
        TaxClass taxClass = new TaxClass("3", 0.15);
        double result = new BasePayServiceIml().getTaxFactor(taxClass);
        assertEquals(0.85, result, 0.001);
    }
    @Test
    public void test_04_03() {
        TaxClass taxClass = new TaxClass("k", 0.20);
        double result = new BasePayServiceIml().getTaxFactor(taxClass);
        assertEquals(0.8, result, 0.001);
    }
    @Test
    public void test_04_04() {
        TaxClass taxClass = new TaxClass("0", 0.25);
        double result = new BasePayServiceIml().getTaxFactor(taxClass);
        assertEquals(0.75, result, 0.001);
    }

    @Test
    public void test_05_01() {
        List<Calendar> calendarData = Arrays.asList(
            new Calendar(2025, 6, 1, DayOfWeek.SUNDAY, false),
            new Calendar(2025, 6, 2, DayOfWeek.MONDAY, false),
            new Calendar(2025, 6, 3, DayOfWeek.TUESDAY, false),
            new Calendar(2025, 6, 4, DayOfWeek.WEDNESDAY, false),
            new Calendar(2025, 6, 5, DayOfWeek.THURSDAY, false),
            new Calendar(2025, 6, 6, DayOfWeek.FRIDAY, false),
            new Calendar(2025, 6, 7, DayOfWeek.SATURDAY, false),
            new Calendar(2025, 6, 8, DayOfWeek.SUNDAY, false),
            new Calendar(2025, 6, 9, DayOfWeek.MONDAY, true),
            new Calendar(2025, 6, 10, DayOfWeek.TUESDAY, false),
            new Calendar(2025, 6, 11, DayOfWeek.WEDNESDAY, false),
            new Calendar(2025, 6, 12, DayOfWeek.THURSDAY, false),
            new Calendar(2025, 6, 13, DayOfWeek.FRIDAY, false),
            new Calendar(2025, 6, 14, DayOfWeek.SATURDAY, false),
            new Calendar(2025, 6, 15, DayOfWeek.SUNDAY, false),
            new Calendar(2025, 6, 16, DayOfWeek.MONDAY, false),
            new Calendar(2025, 6, 17, DayOfWeek.TUESDAY, false),
            new Calendar(2025, 6, 18, DayOfWeek.WEDNESDAY, false),
            new Calendar(2025, 6, 19, DayOfWeek.THURSDAY, false),
            new Calendar(2025, 6, 20, DayOfWeek.FRIDAY, false),
            new Calendar(2025, 6, 21, DayOfWeek.SATURDAY, false),
            new Calendar(2025, 6, 22, DayOfWeek.SUNDAY, false),
            new Calendar(2025, 6, 23, DayOfWeek.MONDAY, false),
            new Calendar(2025, 6, 24, DayOfWeek.TUESDAY, false),
            new Calendar(2025, 6, 25, DayOfWeek.WEDNESDAY, false),
            new Calendar(2025, 6, 26, DayOfWeek.THURSDAY, false),
            new Calendar(2025, 6, 27, DayOfWeek.FRIDAY, false),
            new Calendar(2025, 6, 28, DayOfWeek.SATURDAY, false),
            new Calendar(2025, 6, 29, DayOfWeek.SUNDAY, false),
            new Calendar(2025, 6, 30, DayOfWeek.MONDAY, false)
        );

        Payment payment = new Payment(7, 2025, 9);

        double result = new BasePayServiceIml().getDaysRatio(5, calendarData, payment);

        assertEquals(0.25, result, 0.001);
    }

    @Test
    void test_06_01() {
        existNone("44828372"); // Ruben Schlosser
    }

    @Test
    void test_06_02() {
        existNone("63380933"); // Julia Schäfer
    }

    @Test
    void test_06_03() {
        existNone("60195987"); // Zbigniew Pechel
    }

    @Test
    void test_06_04() {
        existNone("29679748"); // Roman Hamann
    }

    @Test
    void test_06_05() {
        existNone("31665139"); // Nina Chuba
    }

    @Test
    void test_06_06() {
        existNone("76282192"); // Emmi Weinhage
    }

    @Test
    void test_06_07() {
        existNone("46771500"); // Regine Blümel
    }

    @Test
    void test_06_08() {
        existNone("75696039"); // Bernard Weinhage
    }

    @Test
    void test_06_09() {
        existNone("96391050"); // Henryk Jüttner
    }

    @Test
    void test_06_10() {
        existNone("66965048"); // Arne Drewes
    }

    @Test
    void test_07_01() {
        Assertions.fail();
    }

    @Test
    void test_08_01() {
        checkOvertimeSingleWithMonth("21233182", 10); // Shenk
    }

    @Test
    void test_08_02() {
        checkOvertimeSingleWithMonth("20937689", 10); // Graf
    }

    @Test
    void test_08_03() {
        checkOvertimeSingleWithMonth("88492285", 10); // Trub
    }

    @Test
    void test_08_04() {
        checkOvertimeSingleWithMonth("93564379", 10); // Holt
    }

    private static void checkOvertimeSingleWithMonth(String id, int month) {
        List<Overtime> mrGrafOvertimes =
            overtimes.stream().filter(o -> o.employeeId().equals(id)).toList();
        assertEquals(1, mrGrafOvertimes.size());
        assertEquals(month, mrGrafOvertimes.getFirst().date().getMonthValue());
    }

    @Test
    void test_09_01() {
        existOne("17792663");
    }

    @Test
    void test_10_01() {
        dateMatched();
        assertEquals("11.18.2025", existOne("89847194").date());
    }


    @Test
    void test_10_02() {
        dateMatched();
        assertEquals("11.18.2025", existOne("96151283").date());
    }

    @Test
    void test_10_03() {
        dateMatched();
        assertEquals("11.18.2025", existOne("25837554").date());
    }

    @Test
    void test_10_04() {
        dateMatched();
        assertEquals("11.18.2025", existOne("31679018").date());
    }

    @Test
    void test_10_05() {
        dateMatched();
        assertEquals("11.18.2025", existOne("37398297").date());
    }

    @Test
    void test_11_01() {
        Assertions.fail();
    }

    private static void dateMatched() {
        assertEquals(1, payments.size());
        Payment payment = payments.getFirst();
        assertEquals(2025, payment.year());
        assertEquals(11, payment.month());
        assertEquals(19, payment.paymentDate());
    }


    private PaymentResult existOne(String id) {
        List<PaymentResult> list = results.stream().filter(x -> x.employeeId().equals(id)).toList();
        assertEquals(1, list.size(), "Employee with ID " + id + " should exist and be unique");
        return list.getFirst();
    }

    private void existNone(String id) {
        boolean notExists = results.stream().noneMatch(x -> x.employeeId().equals(id));
        assertTrue(notExists, "Employee with ID " + id + " should not exist");
    }

}