package com.sunrisedental.util;

import org.junit.jupiter.api.Test;

import java.sql.Connection;

import static org.junit.jupiter.api.Assertions.*;

class DatabaseConnectionTest {

    @Test
    void shouldConnectToDatabase() {

        try (Connection connection = DatabaseConnection.getConnection()) {

            assertNotNull(connection);
            assertFalse(connection.isClosed());

        } catch (Exception e) {
            fail("Database connection failed: " + e.getMessage());
        }
    }
}