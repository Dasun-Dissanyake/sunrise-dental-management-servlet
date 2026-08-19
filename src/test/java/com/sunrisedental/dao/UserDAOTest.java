package com.sunrisedental.dao;

import com.sunrisedental.model.User;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class UserDAOTest {

    @Test
    void shouldFindUserByUsername() throws Exception {

        UserDAO userDAO = new UserDAO();

        User user = userDAO.findByUsername("admin");

        assertNotNull(user);
        assertEquals("admin", user.getUsername());
        assertNotNull(user.getFullName());
        assertNotNull(user.getRole());
    }
}