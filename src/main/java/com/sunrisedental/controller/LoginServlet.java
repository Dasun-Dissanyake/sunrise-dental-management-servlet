package com.sunrisedental.controller;

import com.sunrisedental.model.User;
import com.sunrisedental.service.AuthService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private AuthService authService;

    @Override
    public void init() throws ServletException {
        authService = new AuthService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.sendRedirect("pages/login.html");
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {

            User user = authService.authenticate(username, password);

            if (user != null) {

                HttpSession session = request.getSession();

                session.setAttribute("loggedInUser", user);

                   response.sendRedirect(
            request.getContextPath() + "/dashboard"
        );

            } else {

                request.setAttribute(
                        "errorMessage",
                        "Invalid username or password."
                );

                request.getRequestDispatcher(
                        "/login.html"
                ).forward(request, response);
            }

        } catch (Exception e) {

            throw new ServletException(
                    "An error occurred during login.",
                    e
            );
        }
    }
}