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
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

class PayrollApplicationTest {
    static List<PaymentResult> results;
    static List<Overtime> overtimes;

    @BeforeAll
    static void setUp() {
        SimpleCsvParser parser = new SimpleCsvParser(new DefaultFileReader());
        FileServiceImpl fileService = new FileServiceImpl("data", parser);
        results = fileService.loadResult();
        overtimes = fileService.loadOvertimes();
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
    public void test_04_01() {
        TaxClass taxClass = new TaxClass("I", 0.25);
        double result = new BasePayServiceIml().getTaxFactor(taxClass);
        assertEquals(0.75, result, 0.001);
    }

    @Test
    public void test_05_01() {
        List<Calendar> calendarData = Arrays.asList(
            new Calendar(2024, 1, 1, DayOfWeek.MONDAY, true),
            new Calendar(2024, 1, 2, DayOfWeek.TUESDAY, false),
            new Calendar(2024, 1, 3, DayOfWeek.WEDNESDAY, false),
            new Calendar(2024, 1, 4, DayOfWeek.THURSDAY, false),
            new Calendar(2024, 1, 5, DayOfWeek.FRIDAY, false),
            new Calendar(2024, 1, 6, DayOfWeek.SATURDAY, false),
            new Calendar(2024, 1, 7, DayOfWeek.SUNDAY, false),
            new Calendar(2024, 1, 8, DayOfWeek.MONDAY, false),
            new Calendar(2024, 1, 9, DayOfWeek.TUESDAY, false),
            new Calendar(2024, 1, 10, DayOfWeek.WEDNESDAY, false),
            new Calendar(2024, 1, 11, DayOfWeek.THURSDAY, false),
            new Calendar(2024, 1, 12, DayOfWeek.FRIDAY, false),
            new Calendar(2024, 1, 13, DayOfWeek.SATURDAY, false),
            new Calendar(2024, 1, 14, DayOfWeek.SUNDAY, false),
            new Calendar(2024, 1, 15, DayOfWeek.MONDAY, false),
            new Calendar(2024, 1, 16, DayOfWeek.TUESDAY, false),
            new Calendar(2024, 1, 17, DayOfWeek.WEDNESDAY, false),
            new Calendar(2024, 1, 18, DayOfWeek.THURSDAY, false),
            new Calendar(2024, 1, 19, DayOfWeek.FRIDAY, false),
            new Calendar(2024, 1, 20, DayOfWeek.SATURDAY, false),
            new Calendar(2024, 1, 21, DayOfWeek.SUNDAY, false),
            new Calendar(2024, 1, 22, DayOfWeek.MONDAY, false),
            new Calendar(2024, 1, 23, DayOfWeek.TUESDAY, false),
            new Calendar(2024, 1, 24, DayOfWeek.WEDNESDAY, false),
            new Calendar(2024, 1, 25, DayOfWeek.THURSDAY, false),
            new Calendar(2024, 1, 26, DayOfWeek.FRIDAY, false),
            new Calendar(2024, 1, 27, DayOfWeek.SATURDAY, false),
            new Calendar(2024, 1, 28, DayOfWeek.SUNDAY, false),
            new Calendar(2024, 1, 29, DayOfWeek.MONDAY, false),
            new Calendar(2024, 1, 30, DayOfWeek.TUESDAY, false),
            new Calendar(2024, 1, 31, DayOfWeek.WEDNESDAY, false)
        );

        Payment payment = new Payment(1, 2024, "2024-01-15");

        double result = new BasePayServiceIml().getDaysRatio(calendarData, payment);

        assertEquals(0.7097, result, 0.001);
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
    void test_06_11() {
        existNone("44828372"); // Ruben Schlosser
    }

    @Test
    void test_06_12() {
        existNone("20493289"); // Hedi Baum
    }

    @Test
    void test_08_01() {
        checkOvertimeSingleWithMonth("21233182", 5); // Shenk
    }

    @Test
    void test_08_02() {
        checkOvertimeSingleWithMonth("20937689", 5); // Graf
    }

    @Test
    void test_08_03() {
        checkOvertimeSingleWithMonth("88492285", 5); // Trub
    }

    @Test
    void test_08_04() {
        checkOvertimeSingleWithMonth("93564379", 5); // Holt
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