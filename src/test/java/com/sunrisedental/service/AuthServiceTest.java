package com.sunrisedental.service;

import com.sunrisedental.model.User;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class AuthServiceTest {

    private final AuthService authService = new AuthService();

    @Test
    void shouldAuthenticateValidUser() throws Exception {

        User user = authService.authenticate("admin", "your-admin-password");

        assertNotNull(user);
        assertEquals("admin", user.getUsername());
        assertEquals("ADMIN", user.getRole());
        assertTrue(user.isEnabled());
    }

    @Test
    void shouldRejectInvalidPassword() throws Exception {

        User user = authService.authenticate(
                "admin",
                "incorrect-password"
        );

        assertNull(user);
    }

    @Test
    void shouldRejectUnknownUsername() throws Exception {

        User user = authService.authenticate(
                "does-not-exist",
                "anything"
        );

        assertNull(user);
    }

    @Test
    void shouldRejectBlankUsername() throws Exception {

        User user = authService.authenticate(
                "",
                "anything"
        );

        assertNull(user);
    }

    @Test
    void shouldRejectBlankPassword() throws Exception {

        User user = authService.authenticate(
                "admin",
                ""
        );

        assertNull(user);
    }

    @Test
    void shouldRejectInactiveUser() throws Exception {
        User disabledUser = new User();
        disabledUser.setId(10L);
        disabledUser.setUsername("inactive_staff");
        disabledUser.setPassword(org.mindrot.jbcrypt.BCrypt.hashpw("Password123", org.mindrot.jbcrypt.BCrypt.gensalt(10)));
        disabledUser.setEnabled(false);
        disabledUser.setRole("STAFF");

        com.sunrisedental.dao.UserDAO stubDAO = new com.sunrisedental.dao.UserDAO() {
            @Override
            public User findByUsername(String username) {
                if ("inactive_staff".equalsIgnoreCase(username)) {
                    return disabledUser;
                }
                return null;
            }
        };

        AuthService service = new AuthService(stubDAO);
        User result = service.authenticate("inactive_staff", "Password123");

        assertNull(result, "Inactive user must not be authenticated");
    }
}