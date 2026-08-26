package com.sunrisedental.controller;

import com.sunrisedental.model.User;
import com.sunrisedental.service.UserService;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

class UserServletTest {

    private UserService mockUserService;
    private UserServlet servlet;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private HttpSession session;
    private RequestDispatcher dispatcher;

    private User adminUser;

    @BeforeEach
    void setUp() {
        mockUserService = mock(UserService.class);
        servlet = new UserServlet(mockUserService);

        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        session = mock(HttpSession.class);
        dispatcher = mock(RequestDispatcher.class);

        adminUser = new User();
        adminUser.setId(1L);
        adminUser.setUsername("admin");
        adminUser.setRole("ADMIN");
        adminUser.setEnabled(true);

        when(request.getContextPath()).thenReturn("/sunrise-dental");
        when(request.getSession(false)).thenReturn(session);
        when(request.getRequestDispatcher("/pages/users.jsp")).thenReturn(dispatcher);
    }

    @Test
    void shouldRedirectToLoginWhenNotAuthenticatedOnGet() throws Exception {
        when(session.getAttribute("loggedInUser")).thenReturn(null);

        servlet.doGet(request, response);

        verify(response).sendRedirect("/sunrise-dental/pages/login.html");
        verify(dispatcher, never()).forward(any(), any());
    }

    @Test
    void shouldRedirectToDashboardWhenNonAdminOnGet() throws Exception {
        User staff = new User();
        staff.setId(2L);
        staff.setUsername("receptionist");
        staff.setRole("RECEPTIONIST");

        when(session.getAttribute("loggedInUser")).thenReturn(staff);

        servlet.doGet(request, response);

        verify(response).sendRedirect("/sunrise-dental/dashboard?error=unauthorized");
        verify(dispatcher, never()).forward(any(), any());
    }

    @Test
    void shouldForwardToUsersJspForAdminOnGet() throws Exception {
        when(session.getAttribute("loggedInUser")).thenReturn(adminUser);
        when(mockUserService.getAllUsers()).thenReturn(List.of(adminUser));

        servlet.doGet(request, response);

        verify(request).setAttribute("users", List.of(adminUser));
        verify(request).setAttribute("user", adminUser);
        verify(dispatcher).forward(request, response);
    }

    @Test
    void shouldLoadEditUserOnGetWithEditId() throws Exception {
        when(session.getAttribute("loggedInUser")).thenReturn(adminUser);
        when(request.getParameter("editId")).thenReturn("5");

        User editUser = new User();
        editUser.setId(5L);
        editUser.setUsername("user5");
        when(mockUserService.getUserById(5L)).thenReturn(editUser);

        servlet.doGet(request, response);

        verify(request).setAttribute("editUser", editUser);
        verify(dispatcher).forward(request, response);
    }

    @Test
    void shouldLoadPwdUserOnGetWithPwdId() throws Exception {
        when(session.getAttribute("loggedInUser")).thenReturn(adminUser);
        when(request.getParameter("pwdId")).thenReturn("7");

        User pwdUser = new User();
        pwdUser.setId(7L);
        pwdUser.setUsername("user7");
        when(mockUserService.getUserById(7L)).thenReturn(pwdUser);

        servlet.doGet(request, response);

        verify(request).setAttribute("pwdUser", pwdUser);
        verify(dispatcher).forward(request, response);
    }

    @Test
    void shouldHandleCreateActionOnPost() throws Exception {
        when(session.getAttribute("loggedInUser")).thenReturn(adminUser);
        when(request.getParameter("action")).thenReturn("create");
        when(request.getParameter("username")).thenReturn("new_user");
        when(request.getParameter("fullName")).thenReturn("New User Full Name");
        when(request.getParameter("role")).thenReturn("DENTIST");
        when(request.getParameter("password")).thenReturn("Secret123");
        when(request.getParameter("confirmPassword")).thenReturn("Secret123");

        servlet.doPost(request, response);

        verify(mockUserService).createUser(any(User.class), eq("Secret123"), eq("Secret123"));
        verify(response).sendRedirect("/sunrise-dental/users?success=created");
    }

    @Test
    void shouldHandleUpdateActionOnPost() throws Exception {
        when(session.getAttribute("loggedInUser")).thenReturn(adminUser);
        when(request.getParameter("action")).thenReturn("update");
        when(request.getParameter("id")).thenReturn("10");
        when(request.getParameter("fullName")).thenReturn("Updated Full Name");
        when(request.getParameter("role")).thenReturn("RECEPTIONIST");

        servlet.doPost(request, response);

        verify(mockUserService).updateUser(eq(10L), eq("Updated Full Name"), eq("RECEPTIONIST"), eq(adminUser));
        verify(response).sendRedirect("/sunrise-dental/users?success=updated");
    }

    @Test
    void shouldHandleActivateActionOnPost() throws Exception {
        when(session.getAttribute("loggedInUser")).thenReturn(adminUser);
        when(request.getParameter("action")).thenReturn("activate");
        when(request.getParameter("id")).thenReturn("12");

        servlet.doPost(request, response);

        verify(mockUserService).activateUser(12L);
        verify(response).sendRedirect("/sunrise-dental/users?success=activated");
    }

    @Test
    void shouldHandleDeactivateActionOnPost() throws Exception {
        when(session.getAttribute("loggedInUser")).thenReturn(adminUser);
        when(request.getParameter("action")).thenReturn("deactivate");
        when(request.getParameter("id")).thenReturn("15");

        servlet.doPost(request, response);

        verify(mockUserService).deactivateUser(15L, adminUser);
        verify(response).sendRedirect("/sunrise-dental/users?success=deactivated");
    }

    @Test
    void shouldHandleChangePasswordActionOnPost() throws Exception {
        when(session.getAttribute("loggedInUser")).thenReturn(adminUser);
        when(request.getParameter("action")).thenReturn("changePassword");
        when(request.getParameter("id")).thenReturn("18");
        when(request.getParameter("newPassword")).thenReturn("NewPass123");
        when(request.getParameter("confirmPassword")).thenReturn("NewPass123");

        servlet.doPost(request, response);

        verify(mockUserService).changePassword(18L, "NewPass123", "NewPass123");
        verify(response).sendRedirect("/sunrise-dental/users?success=password_changed");
    }

    @Test
    void shouldForwardWithErrorMessageOnValidationError() throws Exception {
        when(session.getAttribute("loggedInUser")).thenReturn(adminUser);
        when(request.getParameter("action")).thenReturn("create");
        when(request.getParameter("username")).thenReturn("ab");

        doThrow(new IllegalArgumentException("Username must be at least 3 characters long."))
                .when(mockUserService).createUser(any(), any(), any());

        servlet.doPost(request, response);

        verify(request).setAttribute("error", "Username must be at least 3 characters long.");
        verify(dispatcher).forward(request, response);
    }
}
