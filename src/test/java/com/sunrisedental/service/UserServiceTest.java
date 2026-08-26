package com.sunrisedental.service;

import com.sunrisedental.dao.UserDAO;
import com.sunrisedental.model.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

class UserServiceTest {

    private UserService userService;
    private InMemoryUserDAO stubUserDAO;

    @BeforeEach
    void setUp() {
        stubUserDAO = new InMemoryUserDAO();
        userService = new UserService(stubUserDAO);
    }

    @Test
    void shouldCreateValidUserWithReceptionistRole() throws SQLException {
        User user = new User();
        user.setUsername("receptionist1");
        user.setFullName("John Doe");
        user.setRole("receptionist");

        boolean result = userService.createUser(user, "Password123", "Password123");

        assertTrue(result);
        assertEquals("RECEPTIONIST", user.getRole());
        assertTrue(user.isEnabled());
        assertNotNull(user.getPassword());
        assertTrue(BCrypt.checkpw("Password123", user.getPassword()));
        assertNotNull(stubUserDAO.findByUsername("receptionist1"));
    }

    @Test
    void shouldCreateValidUserWithDentistRole() throws SQLException {
        User user = new User();
        user.setUsername("dentist1");
        user.setFullName("Dr. Sarah Connor");
        user.setRole("DENTIST");

        boolean result = userService.createUser(user, "DentistPass1", "DentistPass1");

        assertTrue(result);
        assertEquals("DENTIST", user.getRole());
        assertTrue(user.isEnabled());
    }

    @Test
    void shouldCreateValidUserWithAdminRole() throws SQLException {
        User user = new User();
        user.setUsername("admin2");
        user.setFullName("Super Admin");
        user.setRole("ADMIN");

        boolean result = userService.createUser(user, "AdminPass1", "AdminPass1");

        assertTrue(result);
        assertEquals("ADMIN", user.getRole());
        assertTrue(user.isEnabled());
    }

    @Test
    void shouldRejectNullUser() {
        assertThrows(
                IllegalArgumentException.class,
                () -> userService.createUser(null, "Password123", "Password123")
        );
    }

    @Test
    void shouldRejectBlankUsername() {
        User user = new User();
        user.setUsername("   ");
        user.setFullName("John Doe");
        user.setRole("RECEPTIONIST");

        IllegalArgumentException ex = assertThrows(
                IllegalArgumentException.class,
                () -> userService.createUser(user, "Password123", "Password123")
        );
        assertEquals("Username is required.", ex.getMessage());
    }

    @Test
    void shouldRejectShortUsername() {
        User user = new User();
        user.setUsername("ab");
        user.setFullName("John Doe");
        user.setRole("RECEPTIONIST");

        IllegalArgumentException ex = assertThrows(
                IllegalArgumentException.class,
                () -> userService.createUser(user, "Password123", "Password123")
        );
        assertTrue(ex.getMessage().contains("at least 3 characters"));
    }

    @Test
    void shouldRejectDuplicateUsername() {
        User user1 = new User();
        user1.setUsername("duplicate_user");
        user1.setFullName("First User");
        user1.setRole("RECEPTIONIST");
        assertDoesNotThrow(() -> userService.createUser(user1, "Pass123", "Pass123"));

        User user2 = new User();
        user2.setUsername("duplicate_user");
        user2.setFullName("Second User");
        user2.setRole("ADMIN");

        IllegalArgumentException ex = assertThrows(
                IllegalArgumentException.class,
                () -> userService.createUser(user2, "Pass123", "Pass123")
        );
        assertTrue(ex.getMessage().contains("already exists"));
    }

    @Test
    void shouldRejectBlankFullName() {
        User user = new User();
        user.setUsername("validuser");
        user.setFullName("  ");
        user.setRole("RECEPTIONIST");

        IllegalArgumentException ex = assertThrows(
                IllegalArgumentException.class,
                () -> userService.createUser(user, "Password123", "Password123")
        );
        assertEquals("Full name is required.", ex.getMessage());
    }

    @Test
    void shouldRejectInvalidRole() {
        User user = new User();
        user.setUsername("validuser");
        user.setFullName("John Doe");
        user.setRole("STAFF");

        IllegalArgumentException ex = assertThrows(
                IllegalArgumentException.class,
                () -> userService.createUser(user, "Password123", "Password123")
        );
        assertTrue(ex.getMessage().contains("Role must be ADMIN, DENTIST, or RECEPTIONIST"));
    }

    @Test
    void shouldRejectBlankPassword() {
        User user = new User();
        user.setUsername("validuser");
        user.setFullName("John Doe");
        user.setRole("RECEPTIONIST");

        IllegalArgumentException ex = assertThrows(
                IllegalArgumentException.class,
                () -> userService.createUser(user, "", "")
        );
        assertEquals("Password is required.", ex.getMessage());
    }

    @Test
    void shouldRejectShortPassword() {
        User user = new User();
        user.setUsername("validuser");
        user.setFullName("John Doe");
        user.setRole("RECEPTIONIST");

        IllegalArgumentException ex = assertThrows(
                IllegalArgumentException.class,
                () -> userService.createUser(user, "12345", "12345")
        );
        assertTrue(ex.getMessage().contains("at least 6 characters"));
    }

    @Test
    void shouldRejectPasswordMismatch() {
        User user = new User();
        user.setUsername("validuser");
        user.setFullName("John Doe");
        user.setRole("RECEPTIONIST");

        IllegalArgumentException ex = assertThrows(
                IllegalArgumentException.class,
                () -> userService.createUser(user, "Secret123", "DifferentPassword")
        );
        assertTrue(ex.getMessage().contains("do not match"));
    }

    @Test
    void shouldUpdateUserSuccessfully() throws SQLException {
        User user = new User();
        user.setUsername("updatable_user");
        user.setFullName("Original Name");
        user.setRole("RECEPTIONIST");
        userService.createUser(user, "Pass123", "Pass123");

        User created = stubUserDAO.findByUsername("updatable_user");
        assertNotNull(created);

        User admin = new User();
        admin.setId(99L);
        admin.setUsername("admin_boss");
        admin.setRole("ADMIN");

        boolean updated = userService.updateUser(created.getId(), "Updated Name", "DENTIST", admin);
        assertTrue(updated);

        User refreshed = stubUserDAO.findById(created.getId());
        assertEquals("Updated Name", refreshed.getFullName());
        assertEquals("DENTIST", refreshed.getRole());
    }

    @Test
    void shouldPreventChangingRoleOfLastActiveAdmin() throws SQLException {
        User soleAdmin = new User();
        soleAdmin.setUsername("sole_admin");
        soleAdmin.setFullName("Sole Admin");
        soleAdmin.setRole("ADMIN");
        userService.createUser(soleAdmin, "AdminPass1", "AdminPass1");

        User created = stubUserDAO.findByUsername("sole_admin");
        assertNotNull(created);

        User loggedIn = new User();
        loggedIn.setId(created.getId());
        loggedIn.setUsername("sole_admin");

        IllegalArgumentException ex = assertThrows(
                IllegalArgumentException.class,
                () -> userService.updateUser(created.getId(), "Sole Admin", "RECEPTIONIST", loggedIn)
        );
        assertTrue(ex.getMessage().contains("only remaining active administrator"));
    }

    @Test
    void shouldAllowChangingRoleOfAdminWhenAnotherAdminExists() throws SQLException {
        User admin1 = new User();
        admin1.setUsername("admin_alpha");
        admin1.setFullName("Admin Alpha");
        admin1.setRole("ADMIN");
        userService.createUser(admin1, "AdminPass1", "AdminPass1");

        User admin2 = new User();
        admin2.setUsername("admin_beta");
        admin2.setFullName("Admin Beta");
        admin2.setRole("ADMIN");
        userService.createUser(admin2, "AdminPass2", "AdminPass2");

        User created1 = stubUserDAO.findByUsername("admin_alpha");
        User created2 = stubUserDAO.findByUsername("admin_beta");

        boolean result = userService.updateUser(created1.getId(), "Admin Alpha", "DENTIST", created2);
        assertTrue(result);
        assertEquals("DENTIST", stubUserDAO.findById(created1.getId()).getRole());
    }

    @Test
    void shouldRejectUpdateWithInvalidParameters() {
        User admin = new User();
        admin.setId(1L);
        admin.setUsername("admin");

        assertThrows(IllegalArgumentException.class, () -> userService.updateUser(null, "Name", "ADMIN", admin));
        assertThrows(IllegalArgumentException.class, () -> userService.updateUser(-1L, "Name", "ADMIN", admin));
        assertThrows(IllegalArgumentException.class, () -> userService.updateUser(999L, "Name", "ADMIN", admin));
    }

    @Test
    void shouldActivateAndDeactivateUser() throws SQLException {
        User user = new User();
        user.setUsername("receptionist_member");
        user.setFullName("Staff Member");
        user.setRole("RECEPTIONIST");
        userService.createUser(user, "Pass123", "Pass123");

        User admin = new User();
        admin.setId(99L);
        admin.setUsername("admin_boss");
        admin.setRole("ADMIN");

        User created = stubUserDAO.findByUsername("receptionist_member");
        assertNotNull(created);

        // Deactivate staff
        boolean deactivated = userService.deactivateUser(created.getId(), admin);
        assertTrue(deactivated);
        assertFalse(stubUserDAO.findById(created.getId()).isEnabled());

        // Reactivate staff
        boolean activated = userService.activateUser(created.getId());
        assertTrue(activated);
        assertTrue(stubUserDAO.findById(created.getId()).isEnabled());
    }

    @Test
    void shouldPreventSelfDeactivation() throws SQLException {
        User admin = new User();
        admin.setUsername("admin_self");
        admin.setFullName("Admin User");
        admin.setRole("ADMIN");
        userService.createUser(admin, "AdminPass123", "AdminPass123");

        User createdAdmin = stubUserDAO.findByUsername("admin_self");

        IllegalArgumentException ex = assertThrows(
                IllegalArgumentException.class,
                () -> userService.deactivateUser(createdAdmin.getId(), createdAdmin)
        );
        assertTrue(ex.getMessage().contains("cannot deactivate your own"));
    }

    @Test
    void shouldPreventDeactivatingLastActiveAdmin() throws SQLException {
        User onlyAdmin = new User();
        onlyAdmin.setUsername("only_admin");
        onlyAdmin.setFullName("Sole Admin");
        onlyAdmin.setRole("ADMIN");
        userService.createUser(onlyAdmin, "AdminPass123", "AdminPass123");

        User createdOnlyAdmin = stubUserDAO.findByUsername("only_admin");

        // Another actor attempting to deactivate the only active admin
        User otherActor = new User();
        otherActor.setId(999L);
        otherActor.setUsername("different_caller");

        IllegalArgumentException ex = assertThrows(
                IllegalArgumentException.class,
                () -> userService.deactivateUser(createdOnlyAdmin.getId(), otherActor)
        );
        assertTrue(ex.getMessage().contains("only remaining active administrator"));
    }

    @Test
    void shouldAllowDeactivatingAdminIfAnotherAdminExists() throws SQLException {
        User admin1 = new User();
        admin1.setUsername("admin_one");
        admin1.setFullName("Admin One");
        admin1.setRole("ADMIN");
        userService.createUser(admin1, "AdminPass1", "AdminPass1");

        User admin2 = new User();
        admin2.setUsername("admin_two");
        admin2.setFullName("Admin Two");
        admin2.setRole("ADMIN");
        userService.createUser(admin2, "AdminPass2", "AdminPass2");

        User created1 = stubUserDAO.findByUsername("admin_one");
        User created2 = stubUserDAO.findByUsername("admin_two");

        // Admin2 deactivates Admin1
        boolean result = userService.deactivateUser(created1.getId(), created2);
        assertTrue(result);
        assertFalse(stubUserDAO.findById(created1.getId()).isEnabled());
    }

    @Test
    void shouldChangePasswordSuccessfully() throws SQLException {
        User user = new User();
        user.setUsername("password_changer");
        user.setFullName("User Test");
        user.setRole("DENTIST");
        userService.createUser(user, "OldPassword1", "OldPassword1");

        User created = stubUserDAO.findByUsername("password_changer");

        boolean changed = userService.changePassword(created.getId(), "NewSecretPassword123", "NewSecretPassword123");
        assertTrue(changed);

        User updated = stubUserDAO.findById(created.getId());
        assertTrue(BCrypt.checkpw("NewSecretPassword123", updated.getPassword()));
        assertFalse(BCrypt.checkpw("OldPassword1", updated.getPassword()));
    }

    @Test
    void shouldRejectPasswordChangeForNonExistentUser() {
        assertThrows(
                IllegalArgumentException.class,
                () -> userService.changePassword(9999L, "NewPassword123", "NewPassword123")
        );
    }

    @Test
    void shouldRetrieveUserByIdAndUsernameAndAll() throws SQLException {
        User user = new User();
        user.setUsername("retrieval_user");
        user.setFullName("Retrieval Test");
        user.setRole("RECEPTIONIST");
        userService.createUser(user, "Pass123", "Pass123");

        User foundById = userService.getUserById(user.getId());
        assertNotNull(foundById);
        assertEquals("retrieval_user", foundById.getUsername());

        User foundByUsername = userService.getUserByUsername("retrieval_user");
        assertNotNull(foundByUsername);
        assertEquals(user.getId(), foundByUsername.getId());

        List<User> all = userService.getAllUsers();
        assertFalse(all.isEmpty());

        assertNull(userService.getUserById(null));
        assertNull(userService.getUserById(-1L));
        assertNull(userService.getUserByUsername(null));
        assertNull(userService.getUserByUsername("   "));
    }

    // In-memory stub for testing UserDAO logic in isolation
    private static class InMemoryUserDAO extends UserDAO {
        private final Map<Long, User> store = new HashMap<>();
        private long idSequence = 1L;

        @Override
        public User findByUsername(String username) {
            if (username == null) return null;
            return store.values().stream()
                    .filter(u -> u.getUsername().equalsIgnoreCase(username))
                    .findFirst()
                    .orElse(null);
        }

        @Override
        public User findById(Long id) {
            if (id == null) return null;
            return store.get(id);
        }

        @Override
        public List<User> findAll() {
            return new ArrayList<>(store.values());
        }

        @Override
        public boolean save(User user) {
            if (user == null) return false;
            user.setId(idSequence++);
            store.put(user.getId(), user);
            return true;
        }

        @Override
        public boolean update(User user) {
            if (user == null || user.getId() == null) return false;
            store.put(user.getId(), user);
            return true;
        }

        @Override
        public boolean updateStatus(Long id, boolean enabled) {
            if (id == null) return false;
            User u = store.get(id);
            if (u != null) {
                u.setEnabled(enabled);
                return true;
            }
            return false;
        }

        @Override
        public boolean updatePassword(Long id, String hashedPassword) {
            if (id == null || hashedPassword == null) return false;
            User u = store.get(id);
            if (u != null) {
                u.setPassword(hashedPassword);
                return true;
            }
            return false;
        }

        @Override
        public boolean existsByUsername(String username) {
            if (username == null) return false;
            return findByUsername(username) != null;
        }

        @Override
        public int countActiveAdmins() {
            return (int) store.values().stream()
                    .filter(u -> "ADMIN".equalsIgnoreCase(u.getRole()) && u.isEnabled())
                    .count();
        }
    }
}
