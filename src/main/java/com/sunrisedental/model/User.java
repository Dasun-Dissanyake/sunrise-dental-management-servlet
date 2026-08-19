package com.sunrisedental.model;

import java.time.LocalDateTime;

public class User {

    private Long id;
    private LocalDateTime createdAt;
    private boolean enabled;
    private String fullName;
    private String password;
    private String role;
    private String username;

    public User() {
    }

    public User(Long id,
                LocalDateTime createdAt,
                boolean enabled,
                String fullName,
                String password,
                String role,
                String username) {

        this.id = id;
        this.createdAt = createdAt;
        this.enabled = enabled;
        this.fullName = fullName;
        this.password = password;
        this.role = role;
        this.username = username;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isEnabled() {
        return enabled;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }
}