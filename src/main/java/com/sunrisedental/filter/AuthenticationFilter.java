package com.sunrisedental.filter;

import com.sunrisedental.model.User;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {
        "/dashboard",
        "/appointments",
        "/patients",
        "/dentists",
        "/treatments",
        "/bills",
        "/reports",
        "/reports/*",
        "/help",
        "/pages/*"
})
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(
            ServletRequest request,
            ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest =
                (HttpServletRequest) request;

        HttpServletResponse httpResponse =
                (HttpServletResponse) response;

        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = uri.substring(contextPath.length());

        // Allow login page and login servlet without authentication
        if (path.equals("/pages/login.html") || path.equals("/login")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session =
                httpRequest.getSession(false);

        User loggedInUser = null;

        if (session != null) {
            loggedInUser =
                    (User) session.getAttribute("loggedInUser");
        }

        if (loggedInUser == null) {

            httpResponse.sendRedirect(
                    httpRequest.getContextPath()
                            + "/pages/login.html"
            );

            return;
        }

        chain.doFilter(request, response);
    }
}
