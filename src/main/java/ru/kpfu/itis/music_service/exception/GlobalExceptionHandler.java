package ru.kpfu.itis.music_service.exception;

import jakarta.persistence.EntityNotFoundException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@ControllerAdvice
public class GlobalExceptionHandler {

    // Обработка REST/AJAX запросов
    @ExceptionHandler(value = {EntityNotFoundException.class})
    public ResponseEntity<Object> handleNotFoundException(EntityNotFoundException ex, HttpServletRequest request) {
        if (isAjaxRequest(request)) {
            Map<String, Object> body = new HashMap<>();
            body.put("error", "Not Found");
            body.put("message", ex.getMessage());
            body.put("status", HttpStatus.NOT_FOUND.value());
            
            log.error("Not found error: {}", ex.getMessage());
            return new ResponseEntity<>(body, HttpStatus.NOT_FOUND);
        }
        return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
    }

    @ExceptionHandler(value = {AccessDeniedException.class})
    public ResponseEntity<Object> handleAccessDeniedException(AccessDeniedException ex, HttpServletRequest request) {
        if (isAjaxRequest(request)) {
            Map<String, Object> body = new HashMap<>();
            body.put("error", "Access Denied");
            body.put("message", "You don't have permission to access this resource");
            body.put("status", HttpStatus.FORBIDDEN.value());
            
            log.error("Access denied error: {}", ex.getMessage());
            return new ResponseEntity<>(body, HttpStatus.FORBIDDEN);
        }
        return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
    }

    @ExceptionHandler(value = {AuthenticationException.class})
    public ResponseEntity<Object> handleAuthenticationException(AuthenticationException ex, HttpServletRequest request) {
        if (isAjaxRequest(request)) {
            Map<String, Object> body = new HashMap<>();
            body.put("error", "Authentication Failed");
            body.put("message", "Please login to continue");
            body.put("status", HttpStatus.UNAUTHORIZED.value());
            
            log.error("Authentication error: {}", ex.getMessage());
            return new ResponseEntity<>(body, HttpStatus.UNAUTHORIZED);
        }
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
    }

    // Обработка обычных запросов
    @ExceptionHandler(Exception.class)
    public ModelAndView handleAllExceptions(Exception ex, HttpServletRequest request) {
        log.error("Unexpected error occurred: ", ex);
        
        if (isAjaxRequest(request)) {
            return null; // Вернется статус 500
        }

        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("exception", ex);
        modelAndView.addObject("message", ex.getMessage());
        modelAndView.addObject("url", request.getRequestURL());
        modelAndView.setViewName("error/500");
        
        return modelAndView;
    }

    private boolean isAjaxRequest(HttpServletRequest request) {
        String requestedWithHeader = request.getHeader("X-Requested-With");
        return "XMLHttpRequest".equals(requestedWithHeader);
    }
} 